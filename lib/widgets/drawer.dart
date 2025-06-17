import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:yks_deneme_takip/services/giris_servisi.dart';
import '../models/ThemeNotifier.dart';

class MenuDrawer extends StatelessWidget {
  MenuDrawer({super.key});

  final GirisServisi _girisServisi = GirisServisi();

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey[800] // Dark Mode için gri ton
                  : const Color(0xFF9575CD), // Light Mode için lila rengin
            ),

            accountName: Text('Hoş geldin'),
            accountEmail: Text(currentUser?.email ?? 'kullanici@example.com'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40, color: Colors.white),
              backgroundColor: Colors.deepPurple,
            ),
          ),

          ListTile(
            leading: Icon(Icons.home, color: Theme.of(context).iconTheme.color),
            title: const Text('Ana Sayfa'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/Anasayfa');
            },
          ),
          ListTile(
            leading: Icon(Icons.calculate, color: Theme.of(context).iconTheme.color),
            title: const Text('Deneme Sınavı Hesapla'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/denemehesapla');
            },
          ),
          ListTile(
            leading: Icon(Icons.track_changes, color: Theme.of(context).iconTheme.color),
            title: const Text('Konu Takip'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/KonuTakip');
            },
          ),
          ListTile(
            leading: Icon(Icons.history, color: Theme.of(context).iconTheme.color),
            title: const Text('Geçmiş Sınavlar'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/gecmisSinavlariGor');
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle, color: Theme.of(context).iconTheme.color),
            title: const Text('Profil Sayfası'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/ProfilSayfasi');
            },
          ),
          ListTile(
            leading: Icon(Icons.mail, color: Theme.of(context).iconTheme.color),
            title: const Text('Bize Ulaşın'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/bizeUlasin');
            },
          ),

          // Dark Mode butonu
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).changeTheme();
                  },
                  activeColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey // Dark Mode’da gri
                      : const Color(0xFF9575CD), // Light Mode’da lila
                ),

                const SizedBox(width: 8),
                Text(
                  'Dark Mode',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.exit_to_app, color: Theme.of(context).iconTheme.color),
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
