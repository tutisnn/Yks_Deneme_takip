import 'package:flutter/material.dart';
import '../themes/Themes.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

//  Tema değişimlerini yöneten Provider sınıfı
class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;
  late SharedPreferences prefs; // Kalıcı veri tutmak için kullanılacak SharedPreferences


  ThemeProvider({bool isDark = false}) {
    _selectedTheme = isDark ? darkTheme : lightTheme;
  }


  ThemeData get getTheme => _selectedTheme;

  //  Temayı değiştir ve kullanıcı tercihine göre SharedPreferences'a kaydet
  Future<void> changeTheme() async {
    prefs = await SharedPreferences.getInstance(); // prefs nesnesini başlat
    if (_selectedTheme == darkTheme) {
      _selectedTheme = lightTheme; // Tema açık moda geçer
      await prefs.setBool("isDark", false); // Tercihleri kaydet
    } else {
      _selectedTheme = darkTheme; // Tema koyu moda geçer
      await prefs.setBool("isDark", true);
    }
    notifyListeners(); // Temanın değiştiğini tüm dinleyicilere bildir (UI yenilenir)
  }
}
