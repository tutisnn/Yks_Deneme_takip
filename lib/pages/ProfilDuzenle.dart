import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';
import 'package:yks_deneme_takip/widgets/custom_app_bar.dart';
import 'package:yks_deneme_takip/models/User.dart';

class ProfilDuzenle extends StatefulWidget {
  const ProfilDuzenle({super.key});

  @override
  State<ProfilDuzenle> createState() => _ProfilDuzenleState();
}

class _ProfilDuzenleState extends State<ProfilDuzenle> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  DateTime? selectedDate;
  String? selectedBirthPlace;
  String? selectedCity;

  bool isLoading = true;

  final List<String> cities = [
    // Şehirler burada aynı şekilde
  ];

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailController.text = user.email ?? "";
      _loadUserData(user.uid);
    }
  }

  Future<void> _loadUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('kullanicilar').doc(uid).get();
    final prefs = await SharedPreferences.getInstance();
    if (doc.exists) {
      final userData = UserModel.fromMap(doc.data()!);

      nameController.text = userData.name ?? '';
      surnameController.text = userData.surname ?? '';
      selectedBirthPlace = userData.birthPlace;
      selectedCity = userData.city;
      selectedDate = userData.birthDate;

      await prefs.setString('uid', uid);
      await prefs.setString('email', userData.email ?? '');
      await prefs.setString('name', userData.name ?? '');
      await prefs.setString('surname', userData.surname ?? '');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı bilgileri yüklendi.")),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime(2000, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> kullaniciBilgileriniKaydet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    UserModel updatedUser = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
      birthPlace: selectedBirthPlace,
      city: selectedCity,
      birthDate: selectedDate,
    );

    if ([updatedUser.name, updatedUser.surname, updatedUser.birthPlace, updatedUser.city].contains(null) || updatedUser.birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('kullanicilar').doc(updatedUser.uid).set(updatedUser.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Firebase'e kaydedildi.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Firebase kaydetme hatası: $e")),
      );
      return;
    }

    try {
      await Supabase.instance.client.from('kullanicilar').upsert(updatedUser.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Supabase'e kaydedildi.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Supabase kaydetme hatası: $e")),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', updatedUser.uid);
      await prefs.setString('email', updatedUser.email);
      await prefs.setString('name', updatedUser.name ?? '');
      await prefs.setString('surname', updatedUser.surname ?? '');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SharedPreferences'e kaydedildi.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("SharedPreferences hatası: $e")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tüm kayıtlar başarıyla tamamlandı.")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AnaSayfa()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profil Düzenle"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            FadeInUp(
              duration: const Duration(milliseconds: 1800),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color.fromRGBO(143, 148, 251, 1)),
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
                    _buildReadOnlyTextField("E-posta", emailController, icon: Icons.email),
                    _buildTextField("Adınız", nameController, icon: Icons.person),
                    _buildTextField("Soyadınız", surnameController, icon: Icons.person_outline),
                    _buildDatePicker(context),
                    _buildDropdown("Doğum Yeri", selectedBirthPlace, (value) {
                      setState(() => selectedBirthPlace = value);
                    }),
                    _buildDropdown("Yaşadığınız İl", selectedCity, (value) {
                      setState(() => selectedCity = value);
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: kullaniciBilgileriniKaydet,
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildReadOnlyTextField(String hint, TextEditingController controller, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        enabled: false,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: InputDecorator(
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Doğum Tarihi",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          child: Text(
            selectedDate == null
                ? "Doğum Tarihi Seç"
                : "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}",
            style: TextStyle(color: selectedDate == null ? Colors.grey : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String? selectedValue, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(border: InputBorder.none),
        hint: Text(label),
        value: selectedValue,
        items: cities.map((city) {
          return DropdownMenuItem<String>(
            value: city,
            child: Text(city),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
