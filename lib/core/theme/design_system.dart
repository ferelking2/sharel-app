import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const double radius = 20;
  static const double elevation = 2;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  static final lightScheme = FlexSchemeColor(
    primary: const Color(0xFF0066FF),
    primaryContainer: const Color(0xFFD6E4FF),
    secondary: const Color(0xFF00DD88),
    secondaryContainer: const Color(0xFFD6FFE4),
    tertiary: const Color(0xFF0055CC),
    tertiaryContainer: const Color(0xFFD6E4FF),
    appBarColor: const Color(0xFFF5F5F5),
    error: Colors.red,
  );

  static final darkScheme = FlexSchemeColor(
    primary: const Color(0xFF3388FF),
    primaryContainer: const Color(0xFF003366),
    secondary: const Color(0xFF00DD88),
    secondaryContainer: const Color(0xFF003322),
    tertiary: const Color(0xFF0055CC),
    tertiaryContainer: const Color(0xFF002244),
    appBarColor: const Color(0xFF222222),
    error: Colors.redAccent,
  );

  static ThemeData lightTheme = FlexThemeData.light(
    colors: lightScheme,
    useMaterial3: true,
    appBarStyle: FlexAppBarStyle.primary,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Roboto',
  ).copyWith(
    cardTheme: CardTheme(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      margin: const EdgeInsets.all(spacing16),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    colors: darkScheme,
    useMaterial3: true,
    appBarStyle: FlexAppBarStyle.primary,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Roboto',
  ).copyWith(
    cardTheme: CardTheme(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      margin: const EdgeInsets.all(spacing16),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
    ),
  );
}
