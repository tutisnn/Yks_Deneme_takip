import 'package:flutter/material.dart';
import 'package:yks_deneme_takip/widgets/drawer.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget content;

  const BasePage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: MenuDrawer(),
      body: content,
    );
  }
}

