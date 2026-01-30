import 'package:flutter/material.dart';

// Thème centralisé, couleurs et typographie
final Color kPrimary = const Color(0xFF0066FF);
final Color kNeutral = const Color(0xFFFFFFFF);

ThemeData appTheme() {
  final colorScheme = ColorScheme.fromSeed(seedColor: kPrimary, primary: kPrimary);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: kNeutral,

    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: kNeutral,
      foregroundColor: Colors.black,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: Colors.grey.shade600,
      showUnselectedLabels: true,
      elevation: 8,
    ),

    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: Colors.white,
      indicatorColor: colorScheme.primaryContainer,
      unselectedIconTheme: IconThemeData(color: Colors.grey.shade700),
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade900),
      titleMedium: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade800),
      bodyMedium: TextStyle(color: Colors.grey.shade800),
    ),

    // Subtle scrollbar / page transitions for desktop feel
    pageTransitionsTheme: const PageTransitionsTheme(builders: {
      TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    }),
  );
}