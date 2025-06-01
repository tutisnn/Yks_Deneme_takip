// ProfilEkrani.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animate_do/animate_do.dart';
import 'ProfilDuzenle.dart';

class ProfilEkrani extends StatefulWidget {
  const ProfilEkrani({super.key});

  @override
  State<ProfilEkrani> createState() => _ProfilEkraniState();
}

class _ProfilEkraniState extends State<ProfilEkrani> {
  String? name;
  String? surname;
  String? email;
  String? birthPlace;
  String? city;
  String? birthDateRaw;

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
    final data = doc.data();

    if (data != null) {
      setState(() {
        name = data['ad'];
        surname = data['soyad'];
        email = data['email'];
        birthPlace = data['dogum_yeri'];
        city = data['yasadigi_il'];
        birthDateRaw = data['dogum_tarihi'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profilim")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
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
                    _buildInfoTile("Ad", name),
                    _buildInfoTile("Soyad", surname),
                    _buildInfoTile("E-posta", email),
                    _buildInfoTile("Doğum Tarihi", birthDateRaw),
                    _buildInfoTile("Doğum Yeri", birthPlace),
                    _buildInfoTile("Yaşadığı İl", city),
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
}
