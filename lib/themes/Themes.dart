import 'package:flutter/material.dart';

// Light Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.white,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 20, color: Colors.black),
  ),
);

// Dark Theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontSize: 20, color: Colors.white),
  ),
);
