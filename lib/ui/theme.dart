// SPDX-License-Identifier: MIT
import 'package:flutter/material.dart';

/// aktujo's colours, as aktujo/brand has them: sealing-wax red as the accent – on dark for areas only, never for small
/// text – and Space Mono for headings.
class AktujoColours {
  static const accentOnLight = Color(0xFF9E1F24);
  static const accentOnDark = Color(0xFFB3262B);
  static const backgroundLight = Color(0xFFF7F8FA);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const textLight = Color(0xFF14202B);
  static const mutedLight = Color(0xFF4A5563);
  static const borderLight = Color(0xFFDDE2E8);
  static const backgroundDark = Color(0xFF0D1117);
  static const surfaceDark = Color(0xFF12171E);
  static const textDark = Color(0xFFE6EDF3);
  static const mutedDark = Color(0xFF8B949E);
  static const borderDark = Color(0xFF1C232B);
  static const dangerDark = Color(0xFFF0857F);
}

ThemeData aktujoTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final accent = dark ? AktujoColours.accentOnDark : AktujoColours.accentOnLight;
  final scheme = ColorScheme(
    brightness: brightness,
    primary: accent,
    onPrimary: Colors.white,
    secondary: accent,
    onSecondary: Colors.white,
    error: dark ? AktujoColours.dangerDark : AktujoColours.accentOnLight,
    onError: dark ? AktujoColours.backgroundDark : Colors.white,
    surface: dark ? AktujoColours.surfaceDark : AktujoColours.surfaceLight,
    onSurface: dark ? AktujoColours.textDark : AktujoColours.textLight,
    onSurfaceVariant: dark ? AktujoColours.mutedDark : AktujoColours.mutedLight,
    outline: dark ? AktujoColours.borderDark : AktujoColours.borderLight,
  );
  const heading = TextStyle(fontFamily: 'Space Mono', fontWeight: FontWeight.w700);
  final base = ThemeData(colorScheme: scheme, useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: dark ? AktujoColours.backgroundDark : AktujoColours.backgroundLight,
    // Text in the accent on dark would be small red text on black: links and buttons take the text colour there.
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: dark ? scheme.onSurface : accent),
    ),
    textTheme: base.textTheme.copyWith(
      headlineSmall: base.textTheme.headlineSmall?.merge(heading),
      titleLarge: base.textTheme.titleLarge?.merge(heading),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: dark ? AktujoColours.backgroundDark : AktujoColours.backgroundLight,
      foregroundColor: scheme.onSurface,
      titleTextStyle: heading.copyWith(fontSize: 20, color: scheme.onSurface),
    ),
    dividerTheme: DividerThemeData(color: scheme.outline),
  );
}
