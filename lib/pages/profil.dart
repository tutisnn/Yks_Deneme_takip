import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BasePage.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('userName') ?? '';
      surnameController.text = prefs.getString('userSurname') ?? '';
      emailController.text = prefs.getString('userEmail') ?? '';
      passwordController.text = prefs.getString('userPassword') ?? '';
      userId = prefs.getString('userId') ?? 'Henüz bir ID yok';
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    // Eğer userId daha önce oluşturulmamışsa, şimdi oluştur
    if (prefs.getString('userId') == null) {
      String randomId = DateTime.now().millisecondsSinceEpoch.toString();
      await prefs.setString('userId', randomId);
      setState(() {
        userId = randomId;
      });
    }

    await prefs.setString('userName', nameController.text);
    await prefs.setString('userSurname', surnameController.text);
    await prefs.setString('userEmail', emailController.text);
    await prefs.setString('userPassword', passwordController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil bilgileri kaydedildi!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Profilim',
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("Adınız", nameController),
            _buildTextField("Soyadınız", surnameController),
            _buildTextField("E-posta Adresiniz", emailController),
            _buildTextField("Şifre", passwordController, obscure: true),
            const SizedBox(height: 20),
            Text(
              "Kullanıcı ID: $userId",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserData,
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
