import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:yks_deneme_takip/services/giris_servisi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yks_deneme_takip/models/User.dart'; // UserModel import
import 'package:yks_deneme_takip/pages/homepage.dart'; // Anasayfa importunu unutma!

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final GirisServisi _girisServisi = GirisServisi();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
                          await _girisServisi.epostaIleKayit(
                            email: emailController.text.trim(),
                            sifre: passwordController.text.trim(),
                          );

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

                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Kayıt sırasında hata oluştu: $e")),
                          );
                        }
                      },
                      child: Container(
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
                        child: const Center(
                          child: Text(
                            "Kayıt Ol",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Google ile giriş butonu
                  _buildGoogleButton(),

                  const SizedBox(height: 10),

                  // GitHub ile giriş butonu
                  _buildGitHubButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

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
              SnackBar(
                content: Text("Google ile kayıt başarısız: $e"),
              ),
            );
          }
        },
        child: _buildButton("Google ile Devam Et", isGoogle: true),
      ),
    );
  }

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
              SnackBar(
                content: Text("GitHub ile giriş sırasında hata oluştu: $e"),
              ),
            );
          }
        },
        child: _buildButton("GitHub ile Devam Et"),
      ),
    );
  }

  Widget _buildButton(String text, {bool isGoogle = false}) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: isGoogle
            ? const LinearGradient(
          colors: [
            Color(0xFF4285F4),
            Color(0xFF357AE8),
          ],
        )
            : const LinearGradient(
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
            Image.asset(
              'assets/images/google_logo.png',
              height: 24,
            ),
          if (isGoogle) const SizedBox(width: 10),
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
