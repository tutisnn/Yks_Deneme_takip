import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart'; // Özel app bar bileşeni import edildi

class BizeUlasin extends StatefulWidget {
  const BizeUlasin({super.key});

  @override
  State<BizeUlasin> createState() => _BizeUlasinState();
}

class _BizeUlasinState extends State<BizeUlasin> {
  final _formKey = GlobalKey<FormState>(); // Form doğrulama için anahtar
  final TextEditingController emailController = TextEditingController(); // E-posta alanı kontrolcüsü
  final TextEditingController subjectController = TextEditingController(); // Konu alanı kontrolcüsü
  final TextEditingController messageController = TextEditingController(); // Mesaj alanı kontrolcüsü

  // Gönder butonuna basıldığında çağrılır
  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      // Form validasyonu başarılı ise mesaj gönderildi bildirimi gösterilir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mesajınız gönderildi!")),
      );

      // Form alanları temizlenir
      emailController.clear();
      subjectController.clear();
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema bilgisi alınır

    return Scaffold(
      appBar: CustomAppBar(title: "Bize Ulaşın"), // Özel AppBar kullanılıyor
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24), // Sayfa içi boşluklar
        child: Form(
          key: _formKey, // Form anahtarı atandı
          child: Column(
            children: [
              // E-posta girişi için özel alan
              _buildInputField(
                controller: emailController,
                label: "E-posta",
                hint: "ornek@mail.com",
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen e-posta adresinizi girin"; // Boşsa hata mesajı
                  }
                  return null; // Geçerli ise null döner
                },
              ),
              // Konu girişi için özel alan
              _buildInputField(
                controller: subjectController,
                label: "Konu",
                hint: "Konu başlığınızı girin",
                icon: Icons.subject,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen konuyu girin"; // Boşsa hata mesajı
                  }
                  return null;
                },
              ),
              // Mesaj girişi için çok satırlı özel alan
              _buildInputField(
                controller: messageController,
                label: "Mesaj",
                hint: "Mesajınızı buraya yazın",
                icon: Icons.message,
                maxLines: 6, // Mesaj alanı 6 satır yüksekliğinde
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen mesajınızı yazın"; // Boşsa hata mesajı
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24), // Buton ve form arasına boşluk
              ElevatedButton.icon(
                onPressed: _sendMessage, // Buton tıklanma olayı
                icon: const Icon(Icons.send), // Gönderme ikonu
                label: const Text("Gönder"), // Buton yazısı
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 1), // Buton arkaplan rengi
                  foregroundColor: Colors.white, // Yazı rengi
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14), // Buton köşe yuvarlama
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Tekrarlanan input alanları için reusable fonksiyon
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1, // Default tek satır
  }) {
    final theme = Theme.of(context); // Tema bilgisi

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10), // Dikey boşluk
      decoration: BoxDecoration(
        color: theme.cardColor, // Kart arkaplan rengi
        borderRadius: BorderRadius.circular(12), // Köşe yuvarlama
        border: Border.all(color: const Color.fromRGBO(143, 148, 251, 1)), // Kenarlık rengi
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(143, 148, 251, 0.15), // Hafif gölge
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller, // Kontrolcü atanıyor
        maxLines: maxLines, // Satır sayısı
        validator: validator, // Doğrulama fonksiyonu
        decoration: InputDecoration(
          prefixIcon: Icon(icon), // Başındaki ikon
          hintText: hint, // İpucu metni
          labelText: label, // Etiket metni
          border: InputBorder.none, // Kenarlık yok
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), // İç boşluk
        ),
      ),
    );
  }
}
