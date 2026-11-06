// SPDX-License-Identifier: MIT
import 'package:flutter/material.dart';

import 'app/opening.dart';
import 'pages/home_page.dart';
import 'src/rust/frb_generated.dart';
import 'ui/theme.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  final archive = await openArchive();
  runApp(AktujoApp(home: HomePage(archive: archive)));
}

/// The app around a page: aktujo's look, light or dark like the system, English or German.
class AktujoApp extends StatelessWidget {
  const AktujoApp({super.key, required this.home, this.locale});

  final Widget home;

  /// The language; none: the system's.
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: aktujoTheme(Brightness.light),
      darkTheme: aktujoTheme(Brightness.dark),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: home,
    );
  }
}
