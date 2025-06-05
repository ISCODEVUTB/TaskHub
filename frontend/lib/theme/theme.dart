import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldLight,
    cardColor: AppColors.surfaceLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.primary,
      textColor: AppColors.textPrimary,
      tileColor: AppColors.surfaceLight,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      backgroundColor: AppColors.scaffoldLight,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textPrimary,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.scaffoldDark,
    cardColor: AppColors.surfaceDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textOnPrimary,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.textOnPrimary,
      textColor: AppColors.textOnPrimary,
      tileColor: AppColors.surfaceDark,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.grey,
      backgroundColor: AppColors.scaffoldDark,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textOnPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textOnPrimary,
      ),
      bodyMedium: TextStyle(
        color: AppColors.textOnPrimary,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.textOnPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: AppColors.textSecondary,
      ),
    ),
  );
}