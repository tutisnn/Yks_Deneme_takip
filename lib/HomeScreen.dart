import 'package:flutter/material.dart';
import 'dart:async';

import 'package:yks_deneme_takip2/drawer.dart'; // Timer için gerekli

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  late DateTime examDate;
  late Duration remainingTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    examDate = DateTime(2025, 6, 15);
    updateRemainingTime();

    // Timer'ı her saniye bir güncelleyerek kalan süreyi doğru şekilde hesapla
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        updateRemainingTime();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Sayfa kapatıldığında timer'ı durdur
    super.dispose();
  }

  // Kalan süreyi hesaplamak
  void updateRemainingTime() {
    final now = DateTime.now();
    remainingTime = examDate.difference(now);
  }

  @override
  Widget build(BuildContext context) {
    String daysRemaining = remainingTime.inDays.toString();
    String hoursRemaining = (remainingTime.inHours % 24).toString().padLeft(2, '0');
    String minutesRemaining = (remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    String secondsRemaining = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Scaffold(
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text('Ana Sayfa'),
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
      ),
      backgroundColor: Color.fromRGBO(242, 242, 242, 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),

                // Kalan süreyi güncellenmiş şekilde göster
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Denemeden Gerçek Başarıya",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(115, 120, 119, 1),
                        fontSize: 42,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      "YKS Netlerini Hesapla\nBaşarıyı Planla!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 42,
                        height: 1.2,
                      ),
                    ),
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
                                  "\n",
                                  Icons.home,
                                  '/', // Route name
                                ),
                                SizedBox(height: 8),
                                buildMenuItem(
                                  "Deneme Sınavı Hesapla",
                                  "Toplan netini hangi dersten ne kadar net yapıldığını öğren",
                                  Icons.calculate,
                                  '/denemehesapla', // Route name
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
                                  '/gecmisSinavlariGor', // Route name
                                ),
                                SizedBox(height: 8),
                                buildMenuItem(
                                  "Konu Takip",
                                  "Hangi dersten hangi konuları bitirdiğine bak",
                                  Icons.book,
                                  '/Anasayfa', // Route name
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(24),
                      margin: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, 4), // Yatay ve dikey gölge
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.access_alarm,
                                color: Colors.black,
                                size: 30,
                              ),
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
                              color: Colors.black, // Zengin bir renk tonu
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(String title, String subtitle, IconData icon, String routeName) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        width: double.infinity,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
            ),
          ],
        ),
      ),
    );
  }
}
