import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart' as flutter_provider;
import 'package:yks_deneme_takip/services/giris_servisi.dart';
import 'package:yks_deneme_takip/providers/theme_provider.dart';

class MenuDrawer extends StatelessWidget {
  MenuDrawer({super.key});

  final GirisServisi _girisServisi = GirisServisi();

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final themeProvider = flutter_provider.Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            accountName: Text(currentUser?.displayName ?? 'Kullanıcı Adı'),
            accountEmail: Text(currentUser?.email ?? 'kullanici@example.com'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40, color: Colors.white),
              backgroundColor: Colors.deepPurple,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black),
            title: const Text('Ana Sayfa'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/Anasayfa');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate, color: Colors.black),
            title: const Text('Deneme Sınavı Hesapla'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/denemehesapla');
            },
          ),
          ListTile(
            leading: const Icon(Icons.track_changes, color: Colors.black),
            title: const Text('Konu Takip'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/KonuTakip');
            },
          ),
          ListTile(
            leading: const Icon(Icons.history, color: Colors.black),
            title: const Text('Geçmiş Sınavlar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/gecmisSinavlariGor');
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.black),
            title: const Text('Profil Sayfası'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ProfilSayfasi');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.brightness_6, color: Colors.black),
            title: Text(themeProvider.isDarkMode ? 'Açık Tema' : 'Koyu Tema'),
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.black),
            title: const Text('Çıkış Yap'),
            onTap: () async {
              Navigator.pop(context);
              await _girisServisi.signOut();
              Navigator.pushReplacementNamed(context, '/girisYap');
            },
          ),
        ],
      ),
    );
  }
}
