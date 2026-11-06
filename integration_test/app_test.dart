// SPDX-License-Identifier: MIT
//
// The app on the device, with the real Rust side: `flutter test integration_test -d macos` (or another device). It
// makes an archive in a temporary folder, with a key of its own in the secure storage, and removes both. With a relay
// (`aktujo relay --data <folder>`) named by `--dart-define=AKTUJO_TEST_RELAY=http://127.0.0.1:8072`, it also starts
// syncing through it and invites; without one that test does nothing.
import 'dart:io';

import 'package:aktujo/app/opening.dart';
import 'package:aktujo/main.dart';
import 'package:aktujo/pages/home_page.dart';
import 'package:aktujo/src/rust/frb_generated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Pumps until [finder] finds what is expected: the Rust side answers on its own threads, which `pumpAndSettle` does
/// not wait for.
Future<void> waitFor(WidgetTester tester, Finder finder, {Duration timeout = const Duration(seconds: 10)}) async {
  final end = DateTime.now().add(timeout);
  while (finder.evaluate().isEmpty && DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pumpAndSettle();
}

const testRelay = String.fromEnvironment('AKTUJO_TEST_RELAY');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async => RustLib.init());

  testWidgets('a space is founded, a file added, found and put into the bin', (tester) async {
    final scratch = await Directory.systemTemp.createTemp('aktujo-app-test');
    const keyName = 'aktujo.data-folder.test';
    await keptKeys.delete(key: keyName);
    final archive = await openArchive(folder: '${scratch.path}/data', keyName: keyName);
    final file = File('${scratch.path}/Lease 2026.pdf')..writeAsBytesSync('%PDF-1.4 lease'.codeUnits);

    await tester.pumpWidget(
      AktujoApp(
        locale: const Locale('en'),
        home: HomePage(archive: archive, pickFiles: () async => [file.path]),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'New space'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Home');
    await tester.tap(find.widgetWithText(FilledButton, 'Found'));
    await waitFor(tester, find.text('Add files'));
    expect(find.text('Home'), findsWidgets);

    await tester.tap(find.text('Add files'));
    await waitFor(tester, find.text('Lease 2026'));
    expect(find.text('1 added'), findsOneWidget);
    expect(find.text('Lease 2026'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'nothing like it');
    await waitFor(tester, find.text('Nothing found.'));
    expect(find.text('Nothing found.'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'lease');
    await waitFor(tester, find.text('Lease 2026'));

    await tester.tap(find.text('Lease 2026').first);
    await waitFor(tester, find.text('Lease 2026.pdf'));
    expect(find.text('Lease 2026.pdf'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Flat');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await waitFor(tester, find.text('Flat'));
    expect(find.text('Flat'), findsOneWidget);
    await tester.tap(find.byTooltip('Into the bin'));
    await waitFor(tester, find.byTooltip('Out of the bin'));
    expect(find.byTooltip('Out of the bin'), findsOneWidget);
    await tester.pageBack();
    await waitFor(tester, find.text('Nothing found.'));
    expect(find.text('Lease 2026'), findsNothing);

    // Opened again with the kept key: the same archive.
    final again = await openArchive(folder: '${scratch.path}/data', keyName: keyName);
    expect((await again.spaces()).single.trashed, 1);

    await keptKeys.delete(key: keyName);
    await scratch.delete(recursive: true);
  });

  testWidgets('sync is offered, and a relay that does not answer or a wrong invitation is said so', (tester) async {
    final scratch = await Directory.systemTemp.createTemp('aktujo-app-sync');
    const keyName = 'aktujo.data-folder.test-sync';
    await keptKeys.delete(key: keyName);
    final archive = await openArchive(folder: '${scratch.path}/data', keyName: keyName);
    await archive.foundSpace(name: 'Home');

    await tester.pumpWidget(
      AktujoApp(
        locale: const Locale('en'),
        home: HomePage(archive: archive),
      ),
    );
    await waitFor(tester, find.byTooltip('Sync and sharing'));
    await tester.tap(find.byTooltip('Sync and sharing'));
    await waitFor(tester, find.text('Start syncing'));
    // Port 9 (discard) of this machine: nothing answers there.
    await tester.enterText(find.widgetWithText(TextField, 'Address of the relay'), 'http://127.0.0.1:9');
    await tester.enterText(find.widgetWithText(TextField, 'Name of this device'), 'Test');
    await tester.tap(find.text('Start syncing'));
    await waitFor(tester, find.textContaining('Something went wrong'), timeout: const Duration(seconds: 30));
    expect(find.textContaining('Something went wrong'), findsOneWidget);
    expect(find.text('Start syncing'), findsOneWidget, reason: 'not synced after a failure');
    await tester.pageBack();
    await tester.pumpAndSettle();

    final drawer = find.byTooltip('Open navigation menu');
    if (drawer.evaluate().isNotEmpty) {
      await tester.tap(drawer);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Join a space'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Invitation'), 'not an invitation');
    await tester.tap(find.widgetWithText(FilledButton, 'Join a space'));
    await waitFor(tester, find.textContaining('Something went wrong'));
    expect(find.textContaining('Something went wrong'), findsOneWidget);
    expect((await archive.spaces()).length, 1);

    await keptKeys.delete(key: keyName);
    await scratch.delete(recursive: true);
  });

  testWidgets('a space is synced through a real relay, its code shown once, and a device invited', (tester) async {
    if (testRelay.isEmpty) return;
    final scratch = await Directory.systemTemp.createTemp('aktujo-app-relay');
    const keyName = 'aktujo.data-folder.test-relay';
    await keptKeys.delete(key: keyName);
    final archive = await openArchive(folder: '${scratch.path}/data', keyName: keyName);
    await archive.foundSpace(name: 'Shared');

    await tester.pumpWidget(
      AktujoApp(
        locale: const Locale('en'),
        home: HomePage(archive: archive),
      ),
    );
    await waitFor(tester, find.byTooltip('Sync and sharing'));
    await tester.tap(find.byTooltip('Sync and sharing'));
    await waitFor(tester, find.text('Start syncing'));
    await tester.enterText(find.widgetWithText(TextField, 'Address of the relay'), testRelay);
    await tester.enterText(find.widgetWithText(TextField, 'Name of this device'), 'Laptop');
    await tester.tap(find.text('Start syncing'));
    await waitFor(tester, find.text('Recovery code'), timeout: const Duration(seconds: 30));
    expect(find.text('Recovery code'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await waitFor(tester, find.text(testRelay));
    expect(find.text('may manage'), findsWidgets);

    await tester.tap(find.widgetWithText(FilledButton, 'Invite'));
    await waitFor(tester, find.text('Invitation'), timeout: const Duration(seconds: 30));
    expect(find.textContaining('#join='), findsOneWidget);
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sync now'));
    await waitFor(tester, find.textContaining('received'), timeout: const Duration(seconds: 30));
    expect(find.textContaining('received'), findsOneWidget);

    await keptKeys.delete(key: keyName);
    await scratch.delete(recursive: true);
  });
}
