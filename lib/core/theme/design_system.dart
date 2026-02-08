import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class AppColors {
  // Primary colors - Bright and vibrant
  static const Color primary = Color(0xFF1F5FF7); // Bright Blue
  static const Color primaryLight = Color(0xFFD6E4FF);

  // Vibrant secondary colors
  static const Color sendColor = Color(0xFF1F5FF7); // Blue for Send
  static const Color receiveColor = Color(0xFF21C63F); // Green for Receive
  static const Color filesColor = Color(0xFF0055CC); // Darker Blue

  // Category colors for files
  static const Color musicColor = Color(0xFFEF5350); // Red/Pink
  static const Color appsColor = Color(0xFF2196F3); // Light Blue
  static const Color videosColor = Color(0xFF9C27B0); // Purple
  static const Color photosColor = Color(0xFF4CAF50); // Green
  static const Color documentsColor = Color(0xFFFB8C00); // Orange

  // Backgrounds
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color surfaceDark = Color(0xFF121212);

  // Text
  static const Color textDark = Color(0xFF1F1F1F);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textGrey = Color(0xFF808080);
}

class AppTheme {
  static const double radius = 20;
  static const double elevation = 2;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing48 = 48;

  static final lightScheme = FlexSchemeColor(
    primary: AppColors.primary,
    primaryContainer: AppColors.primaryLight,
    secondary: AppColors.receiveColor,
    secondaryContainer: const Color(0xFFD6FFE4),
    tertiary: AppColors.filesColor,
    tertiaryContainer: AppColors.primaryLight,
    appBarColor: AppColors.surfaceLight,
    error: Colors.red,
  );

  static final darkScheme = FlexSchemeColor(
    primary: const Color(0xFF3388FF),
    primaryContainer: const Color(0xFF003366),
    secondary: AppColors.receiveColor,
    secondaryContainer: const Color(0xFF003322),
    tertiary: AppColors.filesColor,
    tertiaryContainer: const Color(0xFF002244),
    appBarColor: AppColors.surfaceDark,
    error: Colors.redAccent,
  );

  static ThemeData lightTheme = FlexThemeData.light(
    colors: lightScheme,
    appBarStyle: FlexAppBarStyle.primary,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Roboto',
  ).copyWith(
    scaffoldBackgroundColor: AppColors.surfaceLight,
    cardTheme: CardThemeData(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      margin: const EdgeInsets.all(spacing16),
      color: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      foregroundColor: AppColors.textDark,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textDark,
      ),
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textGrey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppColors.primary, width: 3),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textDark),
      headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textDark),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textDark),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.textDark),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.textDark),
      bodySmall: TextStyle(fontSize: 12, color: AppColors.textGrey),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textDark),
    ),
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    colors: darkScheme,
    appBarStyle: FlexAppBarStyle.primary,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Roboto',
  ).copyWith(
    cardTheme: CardThemeData(
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
