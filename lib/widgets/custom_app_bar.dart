// CustomAppBar: Sayfalar için özelleştirilmiş AppBar yapısı
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title; // AppBar başlığı
  final PreferredSizeWidget? bottom; // Opsiyonel: Alt kısım (örneğin TabBar)

  const CustomAppBar({
    super.key,
    required this.title,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Theme.of(context).textTheme.bodyLarge!.color, // blacktheme ekledim: Yazı rengi temaya göre
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // blacktheme ekledim: Arka plan temaya göre
      centerTitle: true, // Başlığı ortala
      elevation: 0, // Gölge yok
      bottom: bottom, // Alt kısım eklenirse (örneğin TabBar)
      iconTheme: IconThemeData(
        color: Theme.of(context).iconTheme.color, // blacktheme ekledim: Menü ikonu temaya göre
      ),
      actions: [
        // Sağ üst köşede küçük yuvarlak bir alan (profil veya ayar simgesi için)
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor, // blacktheme ekledim: Daire rengi temaya göre
              shape: BoxShape.circle, // Yuvarlak şekil
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0),
  );
}
