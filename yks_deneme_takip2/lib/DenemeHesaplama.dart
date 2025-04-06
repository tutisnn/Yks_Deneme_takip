import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yks_deneme_takip2/drawer.dart';

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

  void _saveExamToDevice(
      double toplamNet,
      int toplamDogru,
      int toplamYanlis,
      ) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> examList = prefs.getStringList('examList') ?? [];

    String newExam =
        '${examNameController.text}|$toplamNet|$toplamDogru|$toplamYanlis|';
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

  double calculateNet(
      TextEditingController correct,
      TextEditingController wrong,
      ) {
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
    double toplamNet =
        turkceNet +
            matematikNet +
            tarihNet +
            cografyaNet +
            felsefeNet +
            dinNet +
            fizikNet +
            kimyaNet +
            biyolojiNet;

    int toplamDogru =
        (int.tryParse(turkceCorrect.text) ?? 0) +
            (int.tryParse(matematikCorrect.text) ?? 0) +
            (int.tryParse(tarihCorrect.text) ?? 0) +
            (int.tryParse(cografyaCorrect.text) ?? 0) +
            (int.tryParse(felsefeCorrect.text) ?? 0) +
            (int.tryParse(dinCorrect.text) ?? 0) +
            (int.tryParse(fizikCorrect.text) ?? 0) +
            (int.tryParse(kimyaCorrect.text) ?? 0) +
            (int.tryParse(biyolojiCorrect.text) ?? 0);

    int toplamYanlis =
        (int.tryParse(turkceWrong.text) ?? 0) +
            (int.tryParse(matematikWrong.text) ?? 0) +
            (int.tryParse(tarihWrong.text) ?? 0) +
            (int.tryParse(cografyaWrong.text) ?? 0) +
            (int.tryParse(felsefeWrong.text) ?? 0) +
            (int.tryParse(dinWrong.text) ?? 0) +
            (int.tryParse(fizikWrong.text) ?? 0) +
            (int.tryParse(kimyaWrong.text) ?? 0) +
            (int.tryParse(biyolojiWrong.text) ?? 0);

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
    return Scaffold(backgroundColor:  const Color(0xFFF5F5F5),
      drawer: MenuDrawer(),
      appBar: AppBar(title: Text("Deneme Sınavı Hesaplama")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: examNameController,
              decoration: InputDecoration(
                labelText: "Sınav Adını Giriniz",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 100, child: Text("")),
                Text("Doğru", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Yanlış", style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            buildSubjectRow(
              "Türkçe",
              Icons.auto_stories,
              turkceCorrect,
              turkceWrong,
            ),
            SizedBox(height: 20),
            buildSubjectRow(
              "Matematik",
              Icons.functions,
              matematikCorrect,
              matematikWrong,
            ),
            SizedBox(height: 20),
            buildSubjectRow("Tarih", Icons.lens, tarihCorrect, tarihWrong),
            SizedBox(height: 20),
            buildSubjectRow(
              "Felsefe",
              Icons.nature_people,
              felsefeCorrect,
              felsefeWrong,
            ),
            SizedBox(height: 20),
            buildSubjectRow("Din", Icons.church, dinCorrect, dinWrong),
            SizedBox(height: 20),
            buildSubjectRow("Fizik", Icons.flash_on, fizikCorrect, fizikWrong),
            SizedBox(height: 20),
            buildSubjectRow("Kimya", Icons.science, kimyaCorrect, kimyaWrong),
            SizedBox(height: 20),
            buildSubjectRow(
              "Biyoloji",
              Icons.local_florist,
              biyolojiCorrect,
              biyolojiWrong,
            ),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius
                  .zero, // Köşeleri kaldırarak tam ekran görünümü sağladık
            ),
            backgroundColor: Colors.black, // Buton rengini ayarla
          ),
          onPressed: calculateExamResults,
          child: Text(
            "HESAPLA",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubjectRow(
      String name,
      IconData icon,
      TextEditingController correctController,
      TextEditingController wrongController,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: 100,
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              SizedBox(width: 5),
              Text(name),
            ],
          ),
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: correctController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),

        SizedBox(
          width: 60,
          child: TextField(
            controller: wrongController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textAlign: TextAlign.center,
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }
}