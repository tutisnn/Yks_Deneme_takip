import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // Animasyonlar için kütüphane
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication
import 'package:yks_deneme_takip/services/giris_servisi.dart'; // Özel giriş servisi
import 'package:yks_deneme_takip/models/User.dart'; // User model
import 'Anasayfa.dart'; // AnaSayfa import
import 'KayitSayfasi.dart'; // Kayıt sayfası import

// Giriş Sayfası Stateful Widget
class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final TextEditingController emailController = TextEditingController(); // Email input kontrolcüsü
  final TextEditingController passwordController = TextEditingController(); // Şifre input kontrolcüsü

  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth örneği
  final GirisServisi _girisServisi = GirisServisi(); // Özel giriş servisi örneği

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Arka plan rengi
      body: SingleChildScrollView( // Sayfanın scroll olması için
        child: Column(
          children: <Widget>[
            _buildHeader(), // Başlık ve görsel bölümü
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildLoginForm(), // Email ve şifre alanları
                  const SizedBox(height: 30),
                  _buildLoginButton(), // Giriş butonu
                  const SizedBox(height: 15),
                  _buildGoogleButton(), // Google ile giriş
                  const SizedBox(height: 15),
                  _buildGitHubButton(), // GitHub ile giriş
                  const SizedBox(height: 30),
                  // Kayıt ol kısmı
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Hesabın yok mu? ",
                          style: TextStyle(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const KayitSayfasi(),
                              ),
                            );
                          },
                          child: const Text(
                            "Kayıt ol",
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
            ),
          ],
        ),
      ),
    );
  }

  // Üst kısım (arka plan ve animasyonlar)
  Widget _buildHeader() {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: <Widget>[
          // Işık ve saat animasyonları
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
                    "YKS Deneme Takip",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Email ve şifre giriş alanları
  Widget _buildLoginForm() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1800),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF2A2A2A) //  Dark Mode arkaplan
              : Colors.white,           // Light Mode arkaplan
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
            customTextField(
              controller: emailController,
              hintText: "Email",
              icon: Icons.email,
            ),
            customTextField(
              controller: passwordController,
              hintText: "Şifre",
              isPassword: true,
              icon: Icons.lock,
            ),
          ],
        ),
      ),
    );
  }

  // Giriş yap butonu
  Widget _buildLoginButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 1900),
      child: GestureDetector(
        onTap: () async {
          String email = emailController.text.trim();
          String password = passwordController.text.trim();

          if (email.isEmpty || password.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Lütfen email ve şifre girin."),
                backgroundColor: Colors.redAccent,
              ),
            );
            return;
          }

          try {
            // Firebase e-posta şifre ile giriş
            await _girisServisi.epostaIleGiris(email: email, sifre: password);
            User? firebaseUser = _auth.currentUser;
            if (firebaseUser != null) {
              UserModel user = UserModel(
                uid: firebaseUser.uid,
                email: firebaseUser.email ?? '',
              );

              print("Giriş yapan kullanıcı: ${user.email}, UID: ${user.uid}");

              // Ana sayfaya yönlendirme
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AnaSayfa()),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(e.toString().replaceFirst('Exception: ', '')),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: _buildButton("Giriş Yap"),
      ),
    );
  }

  // Google ile giriş butonu
  Widget _buildGoogleButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 2000),
      child: GestureDetector(
        onTap: () async {
          try {
            final user = await _girisServisi.googleIleGiris();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AnaSayfa()),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Google ile giriş başarısız: ${e.toString()}"),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: _buildButton("Google ile Giriş Yap", isGoogle: true),
      ),
    );
  }

  // GitHub ile giriş butonu
  Widget _buildGitHubButton() {
    return FadeInUp(
      duration: const Duration(milliseconds: 2000),
      child: GestureDetector(
        onTap: () async {
          try {
            final user = await _girisServisi.signInWithGitHub();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AnaSayfa()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("GitHub ile giriş başarısız."),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("GitHub ile giriş sırasında hata oluştu: $e"),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: _buildButton("GitHub ile Giriş Yap", isGitHub: true),
      ),
    );
  }

  // Ortak buton widget'ı (Giriş/Google/GitHub)
  Widget _buildButton(String text, {bool isGoogle = false, bool isGitHub = false}) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 5),
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

  // Özel textfield widget'ı
  Widget customTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black), // ✨ Yazı rengi
        cursorColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, // ✨ İmleç rengi
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
      ),

    );
  }
}
