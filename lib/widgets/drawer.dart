import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yks_deneme_takip/logo_saglayici.dart';
import 'package:yks_deneme_takip/theme_provider.dart'; // ThemeProvider import et

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return ChangeNotifierProvider(
      create: (context) => LogoSaglayici(),
      child: Consumer<LogoSaglayici>(
        builder: (context, logoSaglayici, _) {
          return Drawer(
            backgroundColor: isDarkMode ? Colors.grey[900] : const Color.fromRGBO(242, 242, 242, 1),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.deepPurple,
                  ),
                  accountName: Text(
                    currentUser?.displayName ?? 'kullanıcı adı',
                    style: TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    currentUser?.email ?? 'kullanici@example.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: logoSaglayici.yukleniyor
                      ? const CircularProgressIndicator(color: Colors.white)
                      : (logoSaglayici.imageURL != null
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(logoSaglayici.imageURL!),
                  )
                      : const CircleAvatar(
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                    backgroundColor: Colors.deepPurple,
                  )),
                ),

                _buildMenuItem(
                  context,
                  icon: Icons.home,
                  color: isDarkMode ? Colors.white : Colors.black,
                  title: "Home",
                  routeName: '/Anasayfa',
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.person,
                  color: isDarkMode ? Colors.white : Colors.black,
                  title: "Giriş Yap",
                  routeName: '/girisYap',
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.calculate,
                  color: isDarkMode ? Colors.white : Colors.black,
                  title: "Deneme Sınavı Hesapla",
                  routeName: '/denemehesapla',
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.track_changes,
                  color: isDarkMode ? Colors.white : Colors.black,
                  title: "Konu Takip",
                  routeName: '/KonuTakip',
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.history,
                  color: isDarkMode ? Colors.white : Colors.black,
                  title: "Geçmiş Sınavlar",
                  routeName: '/gecmisSinavlariGor',
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.account_circle,
                  color: isDarkMode ? Colors.white : Colors.black,
                  title: "Profil Sayfası",
                  routeName: '/ProfilSayfasi',
                ),
                _buildDivider(),

                SwitchListTile(
                  title: Text(
                    'Karanlık Mod',
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                  ),
                  value: isDarkMode,
                  onChanged: (value) {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                  secondary: Icon(
                    isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.history,
                  color: Colors.black,
                  title: 'dnem',
                  routeName: '/bos',
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.deepPurple.shade200 : Colors.deepPurple.shade100,
                      foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    ),
                    onPressed: () {
                      logoSaglayici.fetchRandomImage();
                    },
                    child: const Text("Tıklayınız Apiden foto gelecek"),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
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
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: color),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color.withOpacity(0.7)),
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
    );
  }
}
