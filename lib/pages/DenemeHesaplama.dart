import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yks_deneme_takip/widgets/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yks_deneme_takip/widgets/custom_app_bar.dart';
import '../services/supabase_service.dart'; // SupabaseService importu

const Color lilac = Color(0xFF9575CD); // Tema rengi

// Denemehesaplama sayfası için StatefulWidget
class Denemehesaplama extends StatefulWidget {
  @override
  DenemehesaplamaState createState() => DenemehesaplamaState();
}

class DenemehesaplamaState extends State<Denemehesaplama> {
  final TextEditingController examNameController = TextEditingController(); // Sınav adı kontrolcüsü

  // Dersler için doğru/yanlış inputları ve ikonlar
  final Map<String, Map<String, dynamic>> controllers = {
    'Türkçe': {'correct': TextEditingController(), 'wrong': TextEditingController(), 'icon': Icons.menu_book},
    'Matematik': {'correct': TextEditingController(), 'wrong': TextEditingController(), 'icon': Icons.calculate},
    'Tarih': {'correct': TextEditingController(), 'wrong': TextEditingController(), 'icon': Icons.history_edu},
    'Coğrafya': {'correct': TextEditingController(), 'wrong': TextEditingController(), 'icon': Icons.public},
    'Felsefe': {'correct': TextEditingController(), 'wrong': TextEditingController(), 'icon': Icons.psychology},
    'Din': {'correct': TextEditingController(), 'wrong': TextEditingController(), 'icon': Icons.mosque},
    'Fizik': {'correct': TextEditingController(), 'wrong': TextEditingController(), 'icon': Icons.science},
    'Kimya': {'correct': TextEditingController(), 'wrong': TextEditingController(), 'icon': Icons.biotech},
    'Biyoloji': {'correct': TextEditingController(), 'wrong': TextEditingController(), 'icon': Icons.eco},
  };

  // Net hesaplama fonksiyonu: doğru - (yanlış / 4)
  double calculateNet(TextEditingController correct, TextEditingController wrong) {
    int correctAnswers = int.tryParse(correct.text) ?? 0;
    int wrongAnswers = int.tryParse(wrong.text) ?? 0;
    return correctAnswers - (wrongAnswers / 4);
  }

  // Sonuçları hesapla ve Supabase'e kaydet
  Future<void> calculateExamResults() async {
    final userId = FirebaseAuth.instance.currentUser?.uid; // Kullanıcı ID'si
    double toplamNet = 0;
    int toplamDogru = 0;
    int toplamYanlis = 0;

    // Her ders için net hesapla
    controllers.forEach((_, controller) {
      toplamNet += calculateNet(controller['correct']!, controller['wrong']!);
      toplamDogru += int.tryParse(controller['correct']!.text) ?? 0;
      toplamYanlis += int.tryParse(controller['wrong']!.text) ?? 0;
    });

    // Sonuçları dialog penceresinde göster
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Net Sonuçları"),
          content: Text(
            "Sınav Adı: ${examNameController.text}\n" +
                controllers.entries.map((e) {
                  final net = calculateNet(e.value['correct']!, e.value['wrong']!);
                  return "${e.key}: ${net.toStringAsFixed(2)}";
                }).join("\n") +
                "\n\nToplam Net: ${toplamNet.toStringAsFixed(2)}" +
                "\nToplam Doğru: $toplamDogru\n" +
                "Toplam Yanlış: $toplamYanlis\n",
          ),
          actions: [
            // Kapat butonu
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Kapat"),
            ),
            // Supabase'e kaydet butonu
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                try {
                  await SupabaseService.saveExam(
                    examName: examNameController.text,
                    toplamNet: toplamNet,
                    toplamDogru: toplamDogru,
                    toplamYanlis: toplamYanlis,
                    userId: userId!,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sınav başarıyla kaydedildi.")),
                  );
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Supabase kaydetme hatası: $error")),
                  );
                }
              },
              child: Text("Denemeyi Kaydet"),
            ),
          ],
        );
      },
    );
  }

  // Sayfa UI'si
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lilac.withOpacity(0.05), // Açık lilac arka plan
      drawer: MenuDrawer(), // Menü çekmecesi
      appBar: CustomAppBar(title: "Deneme Sınavı Hesaplama"), // Özel AppBar
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Sınav adı girişi
            TextField(
              controller: examNameController,
              decoration: InputDecoration(
                labelText: "Sınav Adını Giriniz",
                labelStyle: GoogleFonts.quicksand(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
            // Başlıklar: Doğru ve Yanlış
            Row(
              children: [
                Expanded(flex: 3, child: SizedBox()),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text("Doğru", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text("Yanlış", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            // Ders kartları
            ...controllers.entries.map((entry) => buildSubjectRow(
              entry.key,
              entry.value['icon'],
              entry.value['correct']!,
              entry.value['wrong']!,
            )),
          ],
        ),
      ),
      // Hesapla butonu
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: Colors.grey[200],
          ),
          onPressed: () async => await calculateExamResults(),
          child: Text(
            "HESAPLA",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // Ders satırı widget'ı
  Widget buildSubjectRow(String name, IconData icon, TextEditingController correctController, TextEditingController wrongController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Icon(icon, color: lilac),
                  SizedBox(width: 8),
                  Text(name, style: GoogleFonts.quicksand(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Expanded(flex: 2, child: buildNumberBox(correctController)), // Doğru sayısı kutusu
            SizedBox(width: 8),
            Expanded(flex: 2, child: buildNumberBox(wrongController)), // Yanlış sayısı kutusu
          ],
        ),
      ),
    );
  }

  // Sayı kutusu widget'ı (sadece rakam girişine izin verir)
  Widget buildNumberBox(TextEditingController controller) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          isDense: true,
          contentPadding: EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
