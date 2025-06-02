import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/drawer.dart';
import 'pages/deneme_hesaplama_page.dart';
import 'pages/gecmis_sinavlar_page.dart';
import 'pages/homepage.dart';
import 'pages/login_page.dart';
import 'pages/konu_takip_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/ProfilEkrani.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/ProfilDuzenle.dart';

// ThemeProvider importunu ekliyoruz!
import 'theme_provider.dart';

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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
            primarySwatch: Colors.deepPurple,
            scaffoldBackgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: themeProvider.isDarkMode ? Colors.grey[900] : Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
            drawerTheme: DrawerThemeData(
              backgroundColor: themeProvider.isDarkMode ? Colors.grey[900] : Colors.white,
            ),
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => LoginPage(),
            '/denemehesapla': (context) => Denemehesaplama(),
            '/gecmisSinavlariGor': (context) => GecmisSinavlar(),
            '/Anasayfa': (context) => AnaSayfa(),
            '/girisYap': (context) => LoginPage(),
            '/KonuTakip': (context) => Konutakip(),
            '/ProfilSayfasi': (context) => ProfilEkrani(),
            '/ProfilDuzenle': (context) => ProfilDuzenle(),
          },
        );
      },
    );
  }
}
