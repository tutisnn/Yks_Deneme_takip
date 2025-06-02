import 'package:flutter/material.dart';
import 'dart:async';
import 'homepage.dart';
import  'package:yks_deneme_takip/widgets/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yks_deneme_takip/widgets/custom_app_bar.dart';

const Color primaryLilac = Color(0xFFD1C4E9);
const Color accentLilac = Color(0xFF9575CD);

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {

  // Yks Sınavı için kalan süreyi hesaplamak için oluşturulan değişenler ve fonksiyonlar
  late DateTime examDate;
  late Duration remainingTime;
  late Timer _timer;

  // Sayfa ilk açıldığında yapılacak işlemler
  @override
  void initState() {
    super.initState();

    // Sınav tarihini belirleme


    examDate = DateTime(2025, 6, 15);
    //Kalan sürşyi hesaplama
    updateRemainingTime();

    //her saniye bu kalan süreyi güncellleme
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        updateRemainingTime();
      });
    });
  }

  // sayfa kapanınca bu timer işlemini iptal etme. boşa kaynak tüketmesin diye yapılir
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
// Kalan süre hesaplama Fonksiyonu
  void updateRemainingTime() {
    final now = DateTime.now();
    remainingTime = examDate.difference(now);
  }


  //ana widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
       appBar: CustomAppBar(
      title: 'Anasayfa',

    ),
      backgroundColor: Color.fromRGBO(242, 242, 242, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(), // <-- Başlık kısmı çıkarıldı
                SizedBox(height: 24),
                Container(
                  height: 280,
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            buildMenuItem(
                              "AnaSayfa",
                              "\n \u200B",
                              Icons.home,
                              '/Anasayfa',
                            ),
                            SizedBox(height: 8),
                            buildMenuItem(
                              "Deneme Sınavı Hesapla",
                              "Toplan netini hangi dersten ne kadar net yapıldığını öğren \n ads",
                              Icons.calculate,
                              '/denemehesapla',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          children: [
                            buildMenuItem(
                              "Geçmiş Denemeler",
                              "Geçmiş Denemelerini inceleme şansı bul",
                              Icons.history,
                              '/gecmisSinavlariGor',
                            ),
                            SizedBox(height: 8),
                            buildMenuItem(
                              "Konu Takip",
                              "Hangi dersten hangi konuları bitirdiğine bak",
                              Icons.book,
                              '/KonuTakip',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                buildCountdown(), // <-- Geri sayım kısmı çıkarıldı
              ],
            ),
          ),
        ),
      ),
    );
  }

// Başlık widget'i
  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Denemeden Gerçek Başarıya",
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: accentLilac,
          ),
        ),
        Text(
          "YKS Netlerini Hesapla\nBaşarıyı Planla!",
          style: GoogleFonts.quicksand(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ],
    );
  }

// Geri sayım widget'i
  Widget buildCountdown() {
    String daysRemaining = remainingTime.inDays.toString();
    String hoursRemaining = (remainingTime.inHours % 24).toString().padLeft(2, '0');
    String minutesRemaining = (remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    String secondsRemaining = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: EdgeInsets.all(24),
      margin: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: primaryLilac,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: accentLilac.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_alarm, color: Colors.black, size: 30),
              SizedBox(width: 8),
              Text(
                "Sınav için Kalan Süre",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "$daysRemaining Gün  $hoursRemaining Saat  $minutesRemaining Dakika  $secondsRemaining Saniye",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

//Her menu itemi için widget
  Widget buildMenuItem(String title, String subtitle, IconData icon, String routeName) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        width: double.infinity,

        decoration: BoxDecoration(
          color: primaryLilac,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: accentLilac.withOpacity(0.25),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.all(12),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // içeriğe göre yükseklik
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: Colors.deepPurple),
              SizedBox(height: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle.trim().isNotEmpty)
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

}

