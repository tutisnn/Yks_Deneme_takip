import 'package:flutter/material.dart';
import 'package:yks_deneme_takip/LogoSaglayici.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: logoSaglayici.yukleniyor
                      ? Center(child: CircularProgressIndicator())
                      : logoSaglayici.imageURL == null
                      ? Center(
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
                    child: Text("Tıklayınız Apiden foto gelecek"),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          );
        },
      ),
    );
  }


//her menüm elemani için widgwt
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
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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
