import 'package:flutter/material.dart';

///  Açık Tema Tanımı
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light, // Uygulamanın genel aydınlık görünümünü belirler
  primaryColor: Colors.white, // Ana tema rengi (örn. AppBar gibi alanlarda kullanılabilir)
  scaffoldBackgroundColor: Colors.white, // Sayfanın arka plan rengi
  canvasColor: Colors.white, // Drawer gibi bileşenlerin arka plan rengi
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 20,
      color: Colors.black, // Varsayılan metin rengi siyah (açık temada)
    ),
  ),
);

///  Karanlık Tema Tanımı
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark, // Uygulamanın karanlık modda olduğunu belirtir
  primaryColor: Colors.grey[900], // Ana renk koyu gri ton (örneğin üst barlar)
  scaffoldBackgroundColor: Color(0xFF5A5A5A), // Sayfa arka planı için koyu gri renk
  canvasColor: Color(0xFF2C2C2C), // Drawer gibi yüzeylerin rengi (daha koyu)
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      fontSize: 20,
      color: Colors.white, // Varsayılan metin rengi beyaz (karanlık temada okunabilirlik için)
    ),
  ),
);
