import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yks_deneme_takip/logo_saglayici.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('username');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogoSaglayici(),
      child: Builder(
        builder: (context) {
          final logoSaglayici = Provider.of<LogoSaglayici>(context);

          return Drawer(
            backgroundColor: const Color.fromRGBO(242, 242, 242, 1),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  decoration: const BoxDecoration(color: Colors.white),
                  child: logoSaglayici.yukleniyor
                      ? const Center(child: CircularProgressIndicator())
                      : logoSaglayici.imageURL == null
                      ? const Center(
                    child: Text(
                      "Aşağıdaki butona basınız, apiden foto gelecek",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.network(
                      logoSaglayici.imageURL!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),

                // Loginden aldıgımız kullanici adi
                if (userName != null && userName!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8,
                    ),
                    child: Text(
                      "Merhaba, $userName ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                  icon: Icons.history,
                  color: Colors.black,
                  title: 'Profil Sayfası',
                  routeName: '/ProfilSayfasi',
                ),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade100,
                      foregroundColor: Colors.black,
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

  //Her menu itemi için build widget
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

  //divider icin widget
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
