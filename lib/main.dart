import 'package:flutter/material.dart';
import 'widgets/drawer.dart';
import 'pages/DenemeHesaplama.dart';
import 'pages/GecmisSinavlar.dart';
import 'pages/Anasayfa.dart';
import 'pages/GirisSayfasi.dart';
import 'pages/KonuTakip.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/ProfilEkrani.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/ProfilDuzenle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Supabase.initialize(
    url: 'https://fjzlacogmiibgqxmhbao.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZqemxhY29nbWlpYmdxeG1oYmFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg3MjE4MzUsImV4cCI6MjA2NDI5NzgzNX0._px-yE2tOJn8F7MblEHTqhemmO5iG8ygnr2Xw1Lw4rM',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => GirisSayfasi(),
        '/denemehesapla': (context) => Denemehesaplama(),
        '/gecmisSinavlariGor': (context) => GecmisSinavlar(),
        '/Anasayfa':(context)=>AnaSayfa(),
        '/girisYap':(context)=>GirisSayfasi(),
        '/KonuTakip':(context)=>Konutakip(),
        '/ProfilSayfasi':(context)=>ProfilEkrani(),
        '/ProfilDuzenle':(context)=>ProfilDuzenle(),

      },
    );
  }
}