import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4E88FF),
    scaffoldBackgroundColor: const Color(0xFFEEF1F7),
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF4E88FF),
      secondary: const Color(0xFF1F2937),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF1F2937)),
    ),
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF3B6CD9),
    scaffoldBackgroundColor: const Color(0xFF1F2937),
    fontFamily: 'Inter',
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
      primary: const Color(0xFF3B6CD9),
      secondary: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}