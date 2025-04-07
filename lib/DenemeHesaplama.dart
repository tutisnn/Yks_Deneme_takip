import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yks_deneme_takip/drawer.dart';
import 'package:google_fonts/google_fonts.dart';

const Color lilac = Color(0xFF9575CD);


class Denemehesaplama extends StatefulWidget {
  @override
  DenemehesaplamaState createState() => DenemehesaplamaState();
}

class DenemehesaplamaState extends State<Denemehesaplama> {
  TextEditingController examNameController = TextEditingController();

  TextEditingController turkceCorrect = TextEditingController();
  TextEditingController turkceWrong = TextEditingController();

  TextEditingController matematikCorrect = TextEditingController();
  TextEditingController matematikWrong = TextEditingController();

  TextEditingController tarihCorrect = TextEditingController();
  TextEditingController tarihWrong = TextEditingController();

  TextEditingController cografyaCorrect = TextEditingController();
  TextEditingController cografyaWrong = TextEditingController();

  TextEditingController felsefeCorrect = TextEditingController();
  TextEditingController felsefeWrong = TextEditingController();

  TextEditingController dinCorrect = TextEditingController();
  TextEditingController dinWrong = TextEditingController();

  TextEditingController fizikCorrect = TextEditingController();
  TextEditingController fizikWrong = TextEditingController();

  TextEditingController kimyaCorrect = TextEditingController();
  TextEditingController kimyaWrong = TextEditingController();

  TextEditingController biyolojiCorrect = TextEditingController();
  TextEditingController biyolojiWrong = TextEditingController();

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

  double calculateNet(TextEditingController correct, TextEditingController wrong) {
    int correctAnswers = int.tryParse(correct.text) ?? 0;
    int wrongAnswers = int.tryParse(wrong.text) ?? 0;
    return correctAnswers - (wrongAnswers / 4);
  }

  void calculateExamResults() {
    double turkceNet = calculateNet(turkceCorrect, turkceWrong);
    double matematikNet = calculateNet(matematikCorrect, matematikWrong);
    double tarihNet = calculateNet(tarihCorrect, tarihWrong);
    double cografyaNet = calculateNet(cografyaCorrect, cografyaWrong);
    double felsefeNet = calculateNet(felsefeCorrect, felsefeWrong);
    double dinNet = calculateNet(dinCorrect, dinWrong);
    double fizikNet = calculateNet(fizikCorrect, fizikWrong);
    double kimyaNet = calculateNet(kimyaCorrect, kimyaWrong);
    double biyolojiNet = calculateNet(biyolojiCorrect, biyolojiWrong);
    double toplamNet = turkceNet + matematikNet + tarihNet + cografyaNet + felsefeNet + dinNet + fizikNet + kimyaNet + biyolojiNet;

    int toplamDogru = (int.tryParse(turkceCorrect.text) ?? 0) + (int.tryParse(matematikCorrect.text) ?? 0) + (int.tryParse(tarihCorrect.text) ?? 0) + (int.tryParse(cografyaCorrect.text) ?? 0) + (int.tryParse(felsefeCorrect.text) ?? 0) + (int.tryParse(dinCorrect.text) ?? 0) + (int.tryParse(fizikCorrect.text) ?? 0) + (int.tryParse(kimyaCorrect.text) ?? 0) + (int.tryParse(biyolojiCorrect.text) ?? 0);

    int toplamYanlis = (int.tryParse(turkceWrong.text) ?? 0) + (int.tryParse(matematikWrong.text) ?? 0) + (int.tryParse(tarihWrong.text) ?? 0) + (int.tryParse(cografyaWrong.text) ?? 0) + (int.tryParse(felsefeWrong.text) ?? 0) + (int.tryParse(dinWrong.text) ?? 0) + (int.tryParse(fizikWrong.text) ?? 0) + (int.tryParse(kimyaWrong.text) ?? 0) + (int.tryParse(biyolojiWrong.text) ?? 0);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Net Sonuçları"),
          content: Text(
            "Sınav Adı: ${examNameController.text}\n"
                "Türkçe: ${turkceNet.toStringAsFixed(2)}\n"
                "Matematik: ${matematikNet.toStringAsFixed(2)}\n"
                "Tarih: ${tarihNet.toStringAsFixed(2)}\n"
                "Coğrafya: ${cografyaNet.toStringAsFixed(2)}\n"
                "Felsefe: ${felsefeNet.toStringAsFixed(2)}\n"
                "Din: ${dinNet.toStringAsFixed(2)}\n"
                "Fizik: ${fizikNet.toStringAsFixed(2)}\n"
                "Kimya: ${kimyaNet.toStringAsFixed(2)}\n"
                "Biyoloji: ${biyolojiNet.toStringAsFixed(2)}\n"
                "\nToplam Net: ${toplamNet.toStringAsFixed(2)}"
                "\nToplam Doğru: $toplamDogru\n"
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
            buildSubjectRow("Türkçe", Icons.auto_stories, turkceCorrect, turkceWrong),
            buildSubjectRow("Matematik", Icons.functions, matematikCorrect, matematikWrong),
            buildSubjectRow("Tarih", Icons.lens, tarihCorrect, tarihWrong),
            buildSubjectRow("Felsefe", Icons.nature_people, felsefeCorrect, felsefeWrong),
            buildSubjectRow("Din", Icons.church, dinCorrect, dinWrong),
            buildSubjectRow("Fizik", Icons.flash_on, fizikCorrect, fizikWrong),
            buildSubjectRow("Kimya", Icons.science, kimyaCorrect, kimyaWrong),
            buildSubjectRow("Biyoloji", Icons.local_florist, biyolojiCorrect, biyolojiWrong),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            backgroundColor: Colors.grey[200] ,
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