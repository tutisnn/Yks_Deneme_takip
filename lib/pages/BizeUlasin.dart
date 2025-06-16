import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class BizeUlasin extends StatefulWidget {
  const BizeUlasin({super.key});

  @override
  State<BizeUlasin> createState() => _BizeUlasinState();
}

class _BizeUlasinState extends State<BizeUlasin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void _sendMessage() {
    if (_formKey.currentState!.validate()) {
      // Burada form bilgilerini işleyebilirsin (örn. Firebase'e gönderme, e-posta API'si vs.)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mesajınız gönderildi!")),
      );

      // Temizle
      emailController.clear();
      subjectController.clear();
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: "Bize Ulaşın"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField(
                controller: emailController,
                label: "E-posta",
                hint: "ornek@mail.com",
                icon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen e-posta adresinizi girin";
                  }
                  return null;
                },
              ),
              _buildInputField(
                controller: subjectController,
                label: "Konu",
                hint: "Konu başlığınızı girin",
                icon: Icons.subject,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen konuyu girin";
                  }
                  return null;
                },
              ),
              _buildInputField(
                controller: messageController,
                label: "Mesaj",
                hint: "Mesajınızı buraya yazın",
                icon: Icons.message,
                maxLines: 6,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Lütfen mesajınızı yazın";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _sendMessage,
                icon: const Icon(Icons.send),
                label: const Text("Gönder"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color.fromRGBO(143, 148, 251, 1)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(143, 148, 251, 0.15),
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint,
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
