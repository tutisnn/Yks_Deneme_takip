
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import  'package:yks_deneme_takip/widgets/drawer.dart';
import 'package:google_fonts/google_fonts.dart';

const Color lilac = Color(0xFF9575CD);

class Denemehesaplama extends StatefulWidget {
  @override
  DenemehesaplamaState createState() => DenemehesaplamaState();
}

class DenemehesaplamaState extends State<Denemehesaplama> {
  final TextEditingController examNameController = TextEditingController();


  //Kullanıcıların Her ders için girdiği doğru yanlış için controllerlar
  final Map<String, Map<String, dynamic>> controllers = {
    'Türkçe': {
      'correct': TextEditingController(),
      'wrong': TextEditingController(),
      'icon': Icons.menu_book,
    },
    'Matematik': {
      'correct': TextEditingController(),
      'wrong': TextEditingController(),
      'icon': Icons.calculate,
    },
    'Tarih': {
      'correct': TextEditingController(),
      'wrong': TextEditingController(),
      'icon': Icons.history_edu,
    },
    'Coğrafya': {
      'correct': TextEditingController(),
      'wrong': TextEditingController(),
      'icon': Icons.public,
    },
    'Felsefe': {
      'correct': TextEditingController(),
      'wrong': TextEditingController(),
      'icon': Icons.psychology,
    },
    'Din': {
      'correct': TextEditingController(),
      'wrong': TextEditingController(),
      'icon': Icons.mosque,
    },
    'Fizik': {
      'correct': TextEditingController(),
      'wrong': TextEditingController(),
      'icon': Icons.science,
    },
    'Kimya': {
      'correct': TextEditingController(),
      'wrong': TextEditingController(),
      'icon': Icons.biotech,
    },
    'Biyoloji': {
      'correct': TextEditingController(),
      'wrong': TextEditingController(),
      'icon': Icons.eco,
    },
  };




  //Kullanıcının girdiği sınav adını, net sayısını, doğru ve yanlış toplamlarını SharedPreferences kullanarak cihazda kalıcı olarak saklamak için fonksiypnalt
  void _saveExamToDevice(double toplamNet, int toplamDogru, int toplamYanlis) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> examList = prefs.getStringList('examList') ?? [];
    String newExam = '${examNameController.text}|$toplamNet|$toplamDogru|$toplamYanlis|';
    examList.insert(0, newExam);
    await prefs.setStringList('examList', examList);
  }

  void _checkSavedExam() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedExamList = prefs.getStringList('examList');
    if (savedExamList != null && savedExamList.isNotEmpty) {
      print("Kayıtlı sınavlar bulundu: $savedExamList");
    } else {
      print("Kayıtlı sınav bulunamadı.");
    }
  }

  @override
  void initState() {
    _checkSavedExam();
    super.initState();
  }


  //Net Hesaplama,Gösterme Fonksiyonları
  double calculateNet(TextEditingController correct, TextEditingController wrong) {
    int correctAnswers = int.tryParse(correct.text) ?? 0;
    int wrongAnswers = int.tryParse(wrong.text) ?? 0;
    return correctAnswers - (wrongAnswers / 4);
  }

  void calculateExamResults() {
    double toplamNet = 0;
    int toplamDogru = 0;
    int toplamYanlis = 0;

    controllers.forEach((_, controller) {
      toplamNet += calculateNet(controller['correct']!, controller['wrong']!);
      toplamDogru += int.tryParse(controller['correct']!.text) ?? 0;
      toplamYanlis += int.tryParse(controller['wrong']!.text) ?? 0;
    });

    showDialog(
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Kapat"),
            ),
            ElevatedButton(
              onPressed: () {
                _saveExamToDevice(toplamNet, toplamDogru, toplamYanlis);
                Navigator.pop(context);
              },
              child: Text("Denemeyi Kaydet"),
            ),
          ],
        );
      },
    );
  }

  //Ana Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lilac.withOpacity(0.05),
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: Text("Deneme Sınavı Hesaplama", style: GoogleFonts.poppins()),
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: examNameController,
              decoration: InputDecoration(
                labelText: "Sınav Adını Giriniz",
                labelStyle: GoogleFonts.quicksand(),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),
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
            ...controllers.entries.map((entry) => buildSubjectRow(
              entry.key,

             entry.value['icon'],
              entry.value['correct']!,
              entry.value['wrong']!,
            )),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: Colors.grey[200],
          ),
          onPressed: calculateExamResults,
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

  // Her ders Satırı için genel widget
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
            Expanded(flex: 2, child: buildNumberBox(correctController)),
            SizedBox(width: 8),
            Expanded(flex: 2, child: buildNumberBox(wrongController)),
          ],
        ),
      ),
    );
  }

  //Her doğru/yanlış kutusu için genel widget
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
