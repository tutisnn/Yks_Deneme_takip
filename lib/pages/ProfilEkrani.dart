import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/drawer.dart';
import 'package:yks_deneme_takip/widgets/base_page.dart';
import 'ProfilDuzenle.dart';
import 'package:yks_deneme_takip/models/User.dart';

class ProfilEkrani extends StatefulWidget {
  const ProfilEkrani({super.key});

  @override
  State<ProfilEkrani> createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  UserModel? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance.collection('kullanicilar').doc(user.uid).get();
    if (doc.exists) {
      setState(() {
        currentUser = UserModel.fromMap(doc.data()!);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BasePage(
      title: "Profilim",
      content: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentUser == null
          ? const Center(child: Text("Kullanıcı verisi bulunamadı."))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: FadeInUp(
          duration: const Duration(milliseconds: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                runSpacing: 12,
                children: [
                  _buildInfoCard(context, "Ad", currentUser?.name),
                  _buildInfoCard(context, "Soyad", currentUser?.surname),
                  _buildInfoCard(context, "E-posta", currentUser?.email),
                  _buildInfoCard(context, "Doğum Tarihi", _formatDate(currentUser?.birthDate)),
                  _buildInfoCard(context, "Doğum Yeri", currentUser?.birthPlace),
                  _buildInfoCard(context, "Yaşadığı İl", currentUser?.city),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilDuzenle()),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Profili Düzenle"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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

  Widget _buildInfoCard(BuildContext context, String label, String? value) {
    final theme = Theme.of(context);
    return Card(
      color: theme.cardColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            Expanded(
              child: Text(
                value ?? "-",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyLarge?.color?.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day}.${date.month}.${date.year}";
  }
}
