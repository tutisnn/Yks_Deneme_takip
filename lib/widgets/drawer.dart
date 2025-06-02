import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Drawer(
      backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            accountName: Text(currentUser?.displayName ?? 'kullanıcı adı'),
            accountEmail: Text(currentUser?.email ?? 'kullanici@example.com'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person, size: 40, color: Colors.white),
              backgroundColor: Colors.deepPurple,
            ),
          ),
          _buildMenuItem(
            context,
            icon: Icons.home,
            color: Colors.black,
            title: "Home",
            routeName: '/Anasayfa',
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.person,
            color: Colors.black,
            title: "Giriş Yap",
            routeName: '/girisYap',
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.calculate,
            color: Colors.black,
            title: "Deneme Sınavı Hesapla",
            routeName: '/denemehesapla',
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.track_changes,
            color: Colors.black,
            title: "Konu Takip",
            routeName: '/KonuTakip',
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.history,
            color: Colors.black,
            title: "Geçmiş Sınavlar",
            routeName: '/gecmisSinavlariGor',
          ),
          _buildDivider(),
          _buildMenuItem(
            context,
            icon: Icons.account_circle,
            color: Colors.black,
            title: "Profil Sayfası",
            routeName: '/ProfilSayfasi',
          ),
          _buildDivider(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, {
        required IconData icon,
        required Color color,
        required String title,
        required String routeName,
      }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, routeName);
      },
    );
  }

  Widget _buildDivider() {
    return Divider(
      thickness: 1,
      height: 0,
      indent: 16,
      endIndent: 16,
      color: Colors.grey.shade300,
    );
  }
}
