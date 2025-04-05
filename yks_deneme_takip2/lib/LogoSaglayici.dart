import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class LogoSaglayici extends ChangeNotifier {
  String? imageURL;
  bool yukleniyor = false;

  Future<void> fetchRandomImage() async {
    yukleniyor = true;
    notifyListeners();
    try {
      int randomId = Random().nextInt(1000) + 1;
      final uri = Uri.parse('https://picsum.photos/id/$randomId/info');
      print("API isteği yapılıyor: $uri");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        imageURL = jsonData['download_url'];
        print("Resim URL: $imageURL");
      } else {
        throw Exception('Resim yüklenemedi');
      }
    } catch (e) {
      print("Hata: $e");
      imageURL = null;
    } finally {
      yukleniyor = false;
      notifyListeners();
    }
  }
}
