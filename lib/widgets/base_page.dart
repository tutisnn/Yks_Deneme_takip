// BasePage: Uygulamanın tüm sayfaları için temel yapı (AppBar ve Drawer içerir)
import 'package:flutter/material.dart';
import 'package:yks_deneme_takip/widgets/drawer.dart';

class BasePage extends StatelessWidget {
  final String title; // Sayfa başlığı
  final Widget content; // Sayfanın içeriği

  const BasePage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)), // Başlık kısmı
      drawer: MenuDrawer(), // Yan menü (Drawer)
      body: content, // Ana içerik alanı
    );
  }
}
