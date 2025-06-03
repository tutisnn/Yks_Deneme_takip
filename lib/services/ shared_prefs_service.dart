// SharedPrefsService: SharedPreferences üzerinde kullanıcı bilgilerini saklamak için servis
import 'package:shared_preferences/shared_preferences.dart';
import '../models/User.dart';

class SharedPrefsService {
  // Kullanıcı bilgilerini (uid, email, name, surname) SharedPreferences'a kaydeder
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);
    await prefs.setString('email', user.email);
    await prefs.setString('name', user.name ?? '');
    await prefs.setString('surname', user.surname ?? '');
  }
}
