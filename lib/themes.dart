import 'package:flutter/material.dart';

class Themes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorSchemeSeed: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple.shade100,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorSchemeSeed: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.deepPurple.shade700,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: TextStyle(fontSize: 14),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Colors.deepPurple,
    ),
  );
}
