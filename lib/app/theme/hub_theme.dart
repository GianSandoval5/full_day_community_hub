import 'package:flutter/material.dart';

abstract final class HubColors {
  static const background = Color(0xFF06111F);
  static const surface = Color(0xFF0D1B2D);
  static const surfaceStrong = Color(0xFF13263D);
  static const flutterBlue = Color(0xFF42A5F5);
  static const cyan = Color(0xFF38D9F5);
  static const firebaseAmber = Color(0xFFFFCA28);
  static const live = Color(0xFF45E59A);
}

abstract final class HubTheme {
  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: HubColors.flutterBlue,
      brightness: Brightness.dark,
      surface: HubColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: HubColors.background,
      fontFamily: 'sans-serif',
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontWeight: FontWeight.w800, letterSpacing: -2),
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
        ),
        headlineMedium: TextStyle(fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontWeight: FontWeight.w700),
      ),
      cardTheme: CardThemeData(
        color: HubColors.surface.withValues(alpha: 0.92),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
    );
  }
}
