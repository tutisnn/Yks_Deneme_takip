import 'package:flutter/material.dart';
import 'package:yks_deneme_takip/widgets/drawer.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget content;
  final Widget? bottom; // 🔥 Ekledik!

  const BasePage({
    super.key,
    required this.title,
    required this.content,
    this.bottom, // 🔥 Ekledik!
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: MenuDrawer(),
      body: content,
      bottomNavigationBar: bottom, // 🔥 Ekledik!
    );
  }
}
