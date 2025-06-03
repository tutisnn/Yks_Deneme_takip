import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // Animasyonlar için kütüphane
import 'package:yks_deneme_takip/services/giris_servisi.dart'; // Giriş işlemleri servisi
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:yks_deneme_takip/models/User.dart'; // Kullanıcı modeli
import 'package:yks_deneme_takip/pages/Anasayfa.dart'; // Ana sayfa import

// Kayıt Sayfası Stateful Widget
class KayitSayfasi extends StatefulWidget {
  const KayitSayfasi({super.key});

  @override
  State<KayitSayfasi> createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  final TextEditingController emailController = TextEditingController(); // Email input kontrolcüsü
  final TextEditingController passwordController = TextEditingController(); // Şifre input kontrolcüsü

  final GirisServisi _girisServisi = GirisServisi(); // Özel giriş servisi
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth örneği

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arka plan rengi
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Üst kısım: Arka plan ve animasyonlu görseller
            Container(
              height: 300,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  // Işık animasyonları
                  Positioned(
                    left: 30,
                    width: 80,
                    height: 200,
                    child: FadeInUp(
                      duration: const Duration(seconds: 1),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-1.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/light-2.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 40,
                    top: 40,
                    width: 80,
                    height: 150,
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/clock.png'),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Başlık yazısı
                  Positioned(
                    child: FadeInUp(
                      duration: const Duration(milliseconds: 1600),
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Center(
                          child: Text(
                            "Kayıt Ol",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Email ve şifre giriş alanları
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  FadeInUp(
                    duration: const Duration(milliseconds: 1800),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromRGBO(143, 148, 251, 1),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          _buildTextField("Email", emailController, icon: Icons.email),
                          _buildTextField("Şifre", passwordController, isPassword: true, icon: Icons.lock),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Kayıt ol butonu
                  FadeInUp(
                    duration: const Duration(milliseconds: 1900),
                    child: GestureDetector(
                      onTap: () async {
                        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Lütfen email ve şifreyi doldurun")),
                          );
                          return;
                        }
                        if (passwordController.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Şifre en az 6 karakter olmalıdır")),
                          );
                          return;
                        }

                        try {
                          // Firebase'e kayıt ol
                          await _girisServisi.epostaIleKayit(
                            email: emailController.text.trim(),
                            sifre: passwordController.text.trim(),
                          );

                          // Kullanıcıyı Firestore'a ekle
                          User? user = _auth.currentUser;
                          if (user != null) {
                            UserModel newUser = UserModel(
                              uid: user.uid,
                              email: user.email ?? '',
                            );

                            await FirebaseFirestore.instance.collection('kullanicilar').doc(newUser.uid).set(newUser.toJson());
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Kayıt başarılı!")),
                          );

                          Navigator.pop(context); // Giriş sayfasına dön
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Kayıt sırasında hata oluştu: $e")),
                          );
                        }
                      },
                      child: _buildButton("Kayıt Ol"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Google ile kayıt
                  _buildGoogleButton(),
                  const SizedBox(height: 10),
                  // GitHub ile kayıt
                  _buildGitHubButton(),
                  const SizedBox(height: 20),
                  // Giriş sayfasına yönlendirme
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Zaten bir üyeliğiniz var mı? ",
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Giriş sayfasına dön
                          },
                          child: const Text(
                            "Giriş Yap",
                            style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Email ve şifre alanları için özel TextField
  Widget _buildTextField(String hint, TextEditingController controller, {bool isPassword = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  // Google ile kayıt butonu
  Widget _buildGoogleButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 2000),
      child: GestureDetector(
        onTap: () async {
          try {
            final user = await _girisServisi.googleIleGiris();
            if (user != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Google ile kayıt başarılı!")),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AnaSayfa()),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Google ile kayıt başarısız: $e")),
            );
          }
        },
        child: _buildButton("Google ile Devam Et", isGoogle: true),
      ),
    );
  }

  // GitHub ile kayıt butonu
  Widget _buildGitHubButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 2000),
      child: GestureDetector(
        onTap: () async {
          try {
            final user = await _girisServisi.signInWithGitHub();
            if (user != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("GitHub ile giriş başarılı!")),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AnaSayfa()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("GitHub ile giriş başarısız!")),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("GitHub ile giriş sırasında hata oluştu: $e")),
            );
          }
        },
        child: _buildButton("GitHub ile Devam Et", isGitHub: true),
      ),
    );
  }

  // Ortak buton yapısı
  Widget _buildButton(String text, {bool isGoogle = false, bool isGitHub = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(143, 148, 251, 1),
            Color.fromRGBO(143, 148, 251, .6),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isGoogle)
            Image.asset('assets/images/google_logo.png', height: 24),
          if (isGitHub)
            Image.asset('assets/images/github.png', height: 24),
          if (isGoogle || isGitHub) const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
