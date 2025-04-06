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
      // Fetch the logos list from the API
      final uri = Uri.parse('https://67f24369ec56ec1a36d295de.mockapi.io/api/YksDenemeTakip/logos');
      print("API isteği yapılıyor: $uri");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        // Get a random logo from the list
        int randomIndex = Random().nextInt(jsonData.length);
        final logoData = jsonData[randomIndex];

        // Assuming 'logoImageLink' contains the Imgur link, directly use it
        String imgurLink = logoData['logoImageLink'];

        // Convert Imgur link by adding parameters for size and quality
        imageURL = imgurLink; //'$imgurLink?maxwidth=760&fidelity=grand';

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
