// SPDX-License-Identifier: MIT
//
// The app on the device, with the real Rust side: `flutter test integration_test -d macos` (or another device). It
// makes an archive in a temporary folder, with a key of its own in the secure storage, and removes both. With a relay
// (`aktujo relay --data <folder>`) named by `--dart-define=AKTUJO_TEST_RELAY=http://127.0.0.1:8072`, it also starts
// syncing through it and invites; without one that test does nothing.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:aktujo/app/opening.dart';
import 'package:aktujo/main.dart';
import 'package:aktujo/pages/home_page.dart';
import 'package:aktujo/pages/kinds_page.dart';
import 'package:aktujo/pages/scan_page.dart';
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

/// A photo of a page as a PNG: light paper with dark lines of "text".
Future<void> writePage(String path) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(const Rect.fromLTWH(0, 0, 300, 400), Paint()..color = const Color(0xFFEBE6DC));
  for (var y = 30.0; y < 380; y += 24) {
    canvas.drawRect(Rect.fromLTWH(30, y, 240, 6), Paint()..color = const Color(0xFF1E1E28));
  }
  final image = await recorder.endRecording().toImage(300, 400);
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  await File(path).writeAsBytes(png!.buffer.asUint8List());
}

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

  testWidgets('kinds are made and imported, and a document gets a kind and values', (tester) async {
    final scratch = await Directory.systemTemp.createTemp('aktujo-app-kinds');
    const keyName = 'aktujo.data-folder.test-kinds';
    await keptKeys.delete(key: keyName);
    final archive = await openArchive(folder: '${scratch.path}/data', keyName: keyName);
    final space = await archive.foundSpace(name: 'Home');
    final file = File('${scratch.path}/Lease.pdf')..writeAsBytesSync('%PDF-1.4 lease'.codeUnits);
    await archive.addFiles(space: space, paths: [file.path]);
    final kindsFile = File('${scratch.path}/kinds.json')
      ..writeAsStringSync('[{"id": "receipt", "name": "Receipt", "fields": []}]');

    await tester.pumpWidget(
      AktujoApp(
        locale: const Locale('en'),
        home: KindsPage(archive: archive, space: space, pickFile: () async => kindsFile.path),
      ),
    );
    await waitFor(tester, find.text('No kinds yet. Add one, or take a template from a catalog.'));
    await tester.tap(find.text('Add a kind').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Contract');
    await tester.tap(find.widgetWithText(FilledButton, 'Add a kind'));
    await waitFor(tester, find.text('Contract'));
    await tester.tap(find.text('Contract'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Add a field'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Name of the field'), 'Deposit');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('amount').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Add a field'));
    await waitFor(tester, find.text('deposit · amount'));
    expect(find.text('deposit · amount'), findsOneWidget);
    await tester.tap(find.byTooltip('Import a file of kinds'));
    await waitFor(tester, find.text('1 kinds changed'));
    expect(find.text('Receipt'), findsOneWidget);

    // The document: its kind chosen, a value typed.
    final document = (await archive.documents(space: space, words: '', bin: false)).single.id;
    await tester.pumpWidget(
      AktujoApp(
        locale: const Locale('en'),
        home: HomePage(archive: archive),
      ),
    );
    await waitFor(tester, find.text('Lease'));
    await tester.tap(find.text('Lease'));
    await waitFor(tester, find.text('No kind'));
    await tester.tap(find.text('No kind').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Contract').last);
    await waitFor(tester, find.text('Deposit'));
    await tester.tap(find.text('Deposit'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, '1200,50 eur');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await waitFor(tester, find.text('1200.50 EUR'));
    expect(find.text('1200.50 EUR'), findsOneWidget);
    final detail = await archive.document(space: space, document: document);
    expect(detail.kindId, 'contract');

    await keptKeys.delete(key: keyName);
    await scratch.delete(recursive: true);
  });

  testWidgets('pages are scanned into one PDF, shown as they will be', (tester) async {
    final scratch = await Directory.systemTemp.createTemp('aktujo-app-scan');
    const keyName = 'aktujo.data-folder.test-scan';
    await keptKeys.delete(key: keyName);
    final archive = await openArchive(folder: '${scratch.path}/data', keyName: keyName);
    final space = await archive.foundSpace(name: 'Home');
    final pages = ['${scratch.path}/page 1.png', '${scratch.path}/page 2.png'];
    await tester.runAsync(() async {
      for (final page in pages) {
        await writePage(page);
      }
    });

    String? saved;
    await tester.pumpWidget(
      AktujoApp(
        locale: const Locale('en'),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () async {
                  saved = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScanPage(archive: archive, space: space, pickImages: () async => pages),
                    ),
                  );
                },
                child: const Text('Start'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    expect(find.text('No pages yet.'), findsOneWidget);
    expect(find.text('Take a photo'), findsNothing, reason: 'a computer chooses images');
    expect(find.text('Find the sheet and correct its perspective'), findsOneWidget);
    await tester.tap(find.text('grey'));
    await tester.tap(find.text('Choose images'));
    await waitFor(tester, find.byType(Image), timeout: const Duration(seconds: 30));
    await tester.scrollUntilVisible(find.text('Page 1'), 200);
    expect(find.text('Page 1'), findsOneWidget);
    await tester.tap(find.byTooltip('Turn').first);
    await tester.pump(const Duration(milliseconds: 400));
    // The corners of the sheet, moved by hand: the top left a little inwards.
    await tester.tap(find.byTooltip('Corners').first);
    await waitFor(tester, find.byKey(const ValueKey('corner-0')), timeout: const Duration(seconds: 30));
    expect(find.text('Drag each corner onto a corner of the sheet.'), findsOneWidget);
    await tester.drag(find.byKey(const ValueKey('corner-0')), const Offset(40, 30));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Corners'), findsWidgets);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.scrollUntilVisible(find.text('Save as a document'), 300);
    await tester.enterText(find.widgetWithText(TextField, 'Title'), 'Letter');
    await tester.tap(find.text('Save as a document'));
    final end = DateTime.now().add(const Duration(seconds: 60));
    while (saved == null && DateTime.now().isBefore(end)) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(saved, isNotNull);
    final detail = await archive.document(space: space, document: saved!);
    expect(detail.item.title, 'Letter');
    expect(detail.versions.single.mediaType, 'application/pdf');

    await keptKeys.delete(key: keyName);
    await scratch.delete(recursive: true);
  });

  testWidgets('a space is exported as a ZIP and read back in as a new one', (tester) async {
    final scratch = await Directory.systemTemp.createTemp('aktujo-app-export');
    const keyName = 'aktujo.data-folder.test-export';
    await keptKeys.delete(key: keyName);
    final archive = await openArchive(folder: '${scratch.path}/data', keyName: keyName);
    final space = await archive.foundSpace(name: 'Home');
    final file = File('${scratch.path}/Lease.pdf')..writeAsBytesSync('%PDF-1.4 lease'.codeUnits);
    await archive.addFiles(space: space, paths: [file.path]);
    String? zip;

    await tester.pumpWidget(
      AktujoApp(
        locale: const Locale('en'),
        home: HomePage(
          archive: archive,
          saveTo: (suggested) async => zip = '${scratch.path}/$suggested',
          pickZip: () async => zip,
        ),
      ),
    );
    await waitFor(tester, find.text('Lease'));
    await tester.tap(find.byTooltip('More'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Export').last);
    await tester.pumpAndSettle();
    expect(find.textContaining('not encrypted'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Export'));
    await waitFor(tester, find.text('Exported: 1 documents.'));
    expect(find.text('Exported: 1 documents.'), findsOneWidget);
    expect(File(zip!).existsSync(), isTrue);
    expect(zip!.endsWith('.zip'), isTrue);

    final drawer = find.byTooltip('Open navigation menu');
    if (drawer.evaluate().isNotEmpty) {
      await tester.tap(drawer);
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Read an export back in'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).last, 'Home again');
    await tester.tap(find.widgetWithText(FilledButton, 'Read in'));
    await waitFor(tester, find.textContaining('Read in: 1 documents'));
    expect(find.textContaining('Read in: 1 documents'), findsOneWidget);
    final spaces = await archive.spaces();
    expect(spaces.map((s) => s.name), containsAll(['Home', 'Home again']));

    await keptKeys.delete(key: keyName);
    await scratch.delete(recursive: true);
  });
}
