import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/User.dart';
import 'package:yks_deneme_takip/services/firebase_service.dart';
import '../services/supabase_service.dart';
import 'package:yks_deneme_takip/services/shared_prefs_service.dart';
import 'Anasayfa.dart';
import '../widgets/custom_app_bar.dart';

class ProfilDuzenle extends StatefulWidget {
  const ProfilDuzenle({super.key});

  @override
  State<ProfilDuzenle> createState() => _ProfilDuzenleState();
}

class _ProfilDuzenleState extends State<ProfilDuzenle> {
  // TextField kontrolörleri
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  // Seçilen doğum tarihi, doğum yeri ve şehir
  DateTime? selectedDate;
  String? selectedBirthPlace;
  String? selectedCity;

  // Yüklenme durumu
  bool isLoading = true;

  // Türkiye'deki iller listesi
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
    // Kullanıcı giriş yaptıysa e-postayı yükle ve diğer bilgileri getir
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      emailController.text = user.email ?? "";
      _loadUserData(user.uid);
    }
  }

  // Kullanıcı verilerini Firebase'den yükle
  Future<void> _loadUserData(String uid) async {
    final userData = await FirebaseService.getUser(uid);
    if (userData != null) {
      setState(() {
        // TextField'lara ve seçimlere verileri doldur
        nameController.text = userData.name ?? '';
        surnameController.text = userData.surname ?? '';
        selectedBirthPlace = userData.birthPlace;
        selectedCity = userData.city;
        selectedDate = userData.birthDate;
        isLoading = false;
      });

      // Bilgi yüklendi mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kullanıcı bilgileri yüklendi.")),
      );
    }
  }

  // Kullanıcı bilgilerini kaydetme işlemi
  Future<void> kullaniciBilgileriniKaydet() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Güncellenmiş kullanıcı modeli oluştur
    UserModel updatedUser = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: nameController.text.trim(),
      surname: surnameController.text.trim(),
      birthPlace: selectedBirthPlace,
      city: selectedCity,
      birthDate: selectedDate,
    );

    // Gerekli alanların dolu olduğundan emin ol
    if ([updatedUser.name, updatedUser.surname, updatedUser.birthPlace, updatedUser.city].contains(null) || updatedUser.birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen tüm alanları doldurun")),
      );
      return;
    }

    try {
      // Firebase'e kaydet
      await FirebaseService.saveUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Firebase'e kaydedildi.")),
      );

      // Supabase'e kaydet
      await SupabaseService.saveUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Supabase'e kaydedildi.")),
      );

      // SharedPreferences'e kaydet
      await SharedPrefsService.saveUser(updatedUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("SharedPreferences'e kaydedildi.")),
      );

      // Başarı mesajı ve ana sayfaya yönlendir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tüm kayıtlar başarıyla tamamlandı.")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AnaSayfa()),
      );
    } catch (e) {
      // Hata mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profil Düzenle"),
      body: isLoading
      // Yükleniyorsa spinner göster
          ? const Center(child: CircularProgressIndicator())
      // Yüklendiyse formu göster
          : SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            // E-posta alanı (sadece okunabilir)
            _buildStyledField(_buildReadOnlyTextField("E-posta", emailController, icon: Icons.email)),
            // Ad alanı
            _buildStyledField(_buildTextField("Adınız", nameController, icon: Icons.person)),
            // Soyad alanı
            _buildStyledField(_buildTextField("Soyadınız", surnameController, icon: Icons.person_outline)),
            // Doğum tarihi seçici
            _buildStyledField(_buildDatePicker(context)),
            // Doğum yeri dropdown
            _buildStyledField(_buildDropdown("Doğum Yeri", selectedBirthPlace, (value) {
              setState(() => selectedBirthPlace = value);
            })),
            // Yaşanılan il dropdown
            _buildStyledField(_buildDropdown("Yaşadığınız İl", selectedCity, (value) {
              setState(() => selectedCity = value);
            })),
            const SizedBox(height: 30),
            // Kaydet butonu
            ElevatedButton(
              onPressed: kullaniciBilgileriniKaydet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Kaydet"),
            ),
          ],
        ),
      ),
    );
  }

  // TextField veya diğer widget'ları stilize etmek için konteyner
  Widget _buildStyledField(Widget child) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: theme.cardColor, // Tema uyumlu arkaplan
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromRGBO(143, 148, 251, 1)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(143, 148, 251, .2),
            blurRadius: 10.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // Normal düzenlenebilir TextField oluşturur
  Widget _buildTextField(String hint, TextEditingController controller, {IconData? icon}) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: theme.iconTheme.color) : null,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(color: theme.hintColor),
      ),
    );
  }

  // Sadece okunabilir TextField (örneğin e-posta için)
  Widget _buildReadOnlyTextField(String hint, TextEditingController controller, {IconData? icon}) {
    return TextField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(
        prefixIcon: icon != null ? Icon(icon, color: Colors.black) : null,
        border: InputBorder.none,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
      ),
    );
  }

  // Tarih seçici widget
  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime(2000, 1),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => selectedDate = picked);
        }
      },
      child: Row(
        children: [
          const Icon(Icons.date_range, color: Colors.black),
          const SizedBox(width: 10),
          Text(
            selectedDate == null
                ? "Doğum Tarihi Seç"
                : "${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}",
            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
        ],
      ),
    );
  }

  // Dropdown widget oluşturur (şehir ve doğum yeri için)
  Widget _buildDropdown(String label, String? selectedValue, ValueChanged<String?> onChanged) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<String>(
      dropdownColor: theme.cardColor, // Koyu modda güzel görünmesi için
      decoration: const InputDecoration(border: InputBorder.none),
      hint: Text(label, style: TextStyle(color: theme.hintColor)), // Etiket
      value: selectedValue,
      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
      items: cities.map((city) {
        return DropdownMenuItem<String>(
          value: city,
          child: Text(city, style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

}
