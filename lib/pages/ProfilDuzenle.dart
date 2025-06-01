import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:animate_do/animate_do.dart';
import 'homepage.dart';

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
    'Adana', 'Adıyaman', 'Afyonkarahisar', 'Ağrı', 'Amasya', 'Ankara',
    'Antalya', 'Artvin', 'Aydın', 'Balıkesir', 'Bilecik', 'Bingöl', 'Bitlis',
    'Bolu', 'Burdur', 'Bursa', 'Çanakkale', 'Çankırı', 'Çorum', 'Denizli',
    'Diyarbakır', 'Edirne', 'Elazığ', 'Erzincan', 'Erzurum', 'Eskişehir',
    'Gaziantep', 'Giresun', 'Gümüşhane', 'Hakkâri', 'Hatay', 'Isparta',
    'Mersin', 'İstanbul', 'İzmir', 'Kars', 'Kastamonu', 'Kayseri', 'Kırklareli',
    'Kırşehir', 'Kocaeli', 'Konya', 'Kütahya', 'Malatya', 'Manisa',
    'Kahramanmaraş', 'Mardin', 'Muğla', 'Muş', 'Nevşehir', 'Niğde', 'Ordu',
    'Rize', 'Sakarya', 'Samsun', 'Siirt', 'Sinop', 'Sivas', 'Tekirdağ',
    'Tokat', 'Trabzon', 'Tunceli', 'Şanlıurfa', 'Uşak', 'Van', 'Yozgat',
    'Zonguldak', 'Aksaray', 'Bayburt', 'Karaman', 'Kırıkkale', 'Batman',
    'Şırnak', 'Bartın', 'Ardahan', 'Iğdır', 'Yalova', 'Karabük', 'Kilis',
    'Osmaniye', 'Düzce'
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
    if (doc.exists) {
      final data = doc.data();
      if (data != null) {
        nameController.text = data['ad'] ?? '';
        surnameController.text = data['soyad'] ?? '';
        selectedBirthPlace = data['dogum_yeri'];
        selectedCity = data['yasadigi_il'];
        final String? dateStr = data['dogum_tarihi'];
        if (dateStr != null) {
          selectedDate = DateTime.tryParse(dateStr);
        }
      }
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

  // Firebase ve Supabase'e kaydet
  Future<void> kullaniciBilgileriniKaydet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final ad = nameController.text.trim();
    final soyad = surnameController.text.trim();
    final email = emailController.text.trim();
    final uid = user.uid;
    final dogumTarihi = selectedDate;
    final dogumYeri = selectedBirthPlace;
    final yasadigiIl = selectedCity;

    if ([ad, soyad, email, uid, dogumYeri, yasadigiIl].contains(null) || dogumTarihi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
      return;
    }

    // Firebase kaydet
    try {
      await FirebaseFirestore.instance.collection('kullanicilar').doc(uid).set({
        'ad': ad,
        'soyad': soyad,
        'email': email,
        'uid': uid,
        'dogum_tarihi': dogumTarihi!.toIso8601String(),
        'dogum_yeri': dogumYeri,
        'yasadigi_il': yasadigiIl,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Firebase kaydetme hatası: $e")),
      );
      return;
    }

    // Supabase kaydet
    try {
      await Supabase.instance.client.from('kullanicilar').upsert({
        'uid': uid,
        'ad': ad,
        'soyad': soyad,
        'email': email,
        'dogum_tarihi': dogumTarihi!.toIso8601String(),
        'dogum_yeri': dogumYeri,
        'yasadigi_il': yasadigiIl,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Supabase kaydetme hatası: $e")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil bilgileri başarıyla kaydedildi.")),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AnaSayfa()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Düzenle")),
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
