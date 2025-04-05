import 'package:flutter/material.dart';
import 'LogoSaglayici.dart';
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
            backgroundColor: Color.fromRGBO(242, 242, 242, 1),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [

                DrawerHeader(
                  child: logoSaglayici.yukleniyor
                      ? Center(child: CircularProgressIndicator())
                      : logoSaglayici.imageURL == null
                      ? Text("Foto gelcek")


                      : Image.network(
                    logoSaglayici.imageURL!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
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
                  routeName: '/iki',
                ),
                _buildDivider(),
                _buildMenuItem(
                  context,
                  icon: Icons.history,
                  color: Colors.black,
                  title: "Geçmiş Sınavlar",
                  routeName: '/gecmisSinavlariGor',
                ),
                TextButton(
                  onPressed: () {
                    logoSaglayici.fetchRandomImage();
                  },
                  child: Text("Tıkla Apiden foto gelcek"),
                )
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

  // Divider widget'ı
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