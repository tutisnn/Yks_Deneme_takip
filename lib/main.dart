import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as flutter_provider;
import 'widgets/drawer.dart';
import 'pages/deneme_hesaplama_page.dart';
import 'pages/gecmis_sinavlar_page.dart';
import 'pages/homepage.dart';
import 'pages/login_page.dart';
import 'pages/konu_takip_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/ProfilEkrani.dart';
import 'pages/ProfilDuzenle.dart';
import 'providers/theme_provider.dart'; // ThemeProvider import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://fjzlacogmiibgqxmhbao.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqemxhY29nbWlpYmdxeG1oYmFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3MjE4MzUsImV4cCI6MjA2NDI5NzgzNX0._px-yE2tOJn8F7MblEHTqhemmO5iG8ygnr2Xw1Lw4rM',
  );

  runApp(
    flutter_provider.ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = flutter_provider.Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black), // 🌸 Light Theme Icon Color
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
        ),
        iconTheme: const IconThemeData(color: Colors.white), // 🌙 Dark Theme Icon Color
      ),
      themeMode: themeProvider.currentTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/denemehesapla': (context) => Denemehesaplama(),
        '/gecmisSinavlariGor': (context) => GecmisSinavlar(),
        '/Anasayfa': (context) => AnaSayfa(),
        '/girisYap': (context) => LoginPage(),
        '/KonuTakip': (context) => Konutakip(),
        '/ProfilSayfasi': (context) => ProfilEkrani(),
        '/ProfilDuzenle': (context) => ProfilDuzenle(),
      },
    );
  }
}
