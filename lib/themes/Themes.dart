import 'package:flutter/material.dart';

// Light Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 20, color: Colors.black),
  ),
);

// Dark Theme (gri arka planlı)
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[900],
  scaffoldBackgroundColor: Color(0xFF2C2C2C), //  koyu gri
  canvasColor: Color(0xFF2C2C2C),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 20, color: Colors.white),
  ),
);
