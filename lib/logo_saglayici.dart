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
      //Burda kendi logolarımızı yerleştidiğiöiz  apimziden alıyoruz
      final uri = Uri.parse('https://67f24369ec56ec1a36d295de.mockapi.io/api/YksDenemeTakip/logos');
      print("API isteği yapılıyor: $uri");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        int randomIndex = Random().nextInt(jsonData.length);
        final logoData = jsonData[randomIndex];


        imageURL  = logoData['logoImageLink'];


        print("Resim URL: $imageURL");
      } else {
        throw Exception('Resimler yüklenemedi');
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
