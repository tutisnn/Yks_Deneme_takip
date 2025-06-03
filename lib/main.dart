// Ana uygulama dosyası (main.dart): Firebase ve Supabase entegrasyonu, uygulama başlangıç ayarları
import 'package:flutter/material.dart';
import 'widgets/drawer.dart'; // Drawer widget'ı
import 'pages/DenemeHesaplama.dart'; // Deneme hesaplama sayfası
import 'pages/GecmisSinavlar.dart'; // Geçmiş sınavlar sayfası
import 'pages/Anasayfa.dart'; // Ana sayfa
import 'pages/GirisSayfasi.dart'; // Giriş sayfası
import 'pages/KonuTakip.dart'; // Konu takip sayfası
import 'firebase_options.dart'; // Firebase ayarları
import 'package:firebase_core/firebase_core.dart'; // Firebase entegrasyonu
import 'pages/ProfilEkrani.dart'; // Profil ekranı
import 'package:supabase_flutter/supabase_flutter.dart'; // Supabase entegrasyonu
import 'pages/ProfilDuzenle.dart'; // Profil düzenleme sayfası

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter'ın widget binding'ini başlatır

  // Firebase başlatılır
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Supabase başlatılır
  await Supabase.initialize(
    url: 'https://fjzlacogmiibgqxmhbao.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqemxhY29nbWlpYmdxeG1oYmFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3MjE4MzUsImV4cCI6MjA2NDI5NzgzNX0._px-yE2tOJn8F7MblEHTqhemmO5iG8ygnr2Xw1Lw4rM',
  );

  runApp(MyApp()); // Uygulama başlatılır
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // Uygulamanın genel tema rengi
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/', // Uygulama açıldığında ilk açılacak sayfa
      routes: {
        // Uygulama sayfaları ve route isimleri
        '/': (context) => GirisSayfasi(),
        '/denemehesapla': (context) => Denemehesaplama(),
        '/gecmisSinavlariGor': (context) => GecmisSinavlar(),
        '/Anasayfa': (context) => AnaSayfa(),
        '/girisYap': (context) => GirisSayfasi(),
        '/KonuTakip': (context) => Konutakip(),
        '/ProfilSayfasi': (context) => ProfilEkrani(),
        '/ProfilDuzenle': (context) => ProfilDuzenle(),
      },
    );
  }
}
