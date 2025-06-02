import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';
import '../widgets/drawer.dart'; // DrawerMenu importu
import 'package:yks_deneme_takip/widgets/base_page.dart';
import 'ProfilDuzenle.dart';
import 'package:yks_deneme_takip/models/User.dart'; // UserModel import!

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
    return BasePage(
      title: "Profilim",
      content: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentUser == null
          ? const Center(child: Text("Kullanıcı verisi bulunamadı."))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoTile("Ad", currentUser?.name),
                    _buildInfoTile("Soyad", currentUser?.surname),
                    _buildInfoTile("E-posta", currentUser?.email),
                    _buildInfoTile("Doğum Tarihi", _formatDate(currentUser?.birthDate)),
                    _buildInfoTile("Doğum Yeri", currentUser?.birthPlace),
                    _buildInfoTile("Yaşadığı İl", currentUser?.city),
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? "-", style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return "${date.day}.${date.month}.${date.year}";
  }
}
