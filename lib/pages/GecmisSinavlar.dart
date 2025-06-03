import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart'; // Pie chart kütüphanesi
import 'package:firebase_auth/firebase_auth.dart'; // Firebase kimlik doğrulama
import 'package:yks_deneme_takip/widgets/drawer.dart'; // Özel Drawer widget'ı
import 'package:yks_deneme_takip/widgets/custom_app_bar.dart'; // Özel AppBar
import 'package:yks_deneme_takip/services/supabase_service.dart'; // Supabase servis bağlantısı

const Color lilacLight = Color(0xFFF3E5F5); // Açık lila renk tonu

// Geçmiş Sınavlar ekranı Stateful Widget
class GecmisSinavlar extends StatefulWidget {
  const GecmisSinavlar({super.key});

  @override
  State<GecmisSinavlar> createState() => _GecmisSinavlarState();
}

class _GecmisSinavlarState extends State<GecmisSinavlar> {
  List<Map<String, dynamic>> _examList = []; // Sınav listesini tutacak dizi
  String _selectedFilter = 'Varsayılan'; // Filtre seçimi için değişken

  @override
  void initState() {
    super.initState();
    _getExamInfo(); // Sayfa açıldığında sınavları çek
  }

  // Supabase üzerinden sınav bilgilerini getiren fonksiyon
  Future<void> _getExamInfo() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid; // Mevcut kullanıcı ID'si

      if (userId == null) {
        debugPrint("Kullanıcı oturumu yok.");
        return;
      }

      // SupabaseService aracılığıyla sınav verilerini çek
      final data = await SupabaseService.getExamList(userId);

      // Çekilen verileri düzenle
      List<Map<String, dynamic>> tempList = data.map((item) {
        return {
          "examName": item["sinav_adi"] ?? "",
          "examNet": (item["toplam_net"] ?? 0).toDouble(),
          "totalCorrect": item["toplam_dogru"] ?? 0,
          "totalWrong": item["toplam_yanlis"] ?? 0,
        };
      }).toList();

      setState(() {
        _examList = tempList; // Listeyi güncelle
      });
    } catch (e) {
      debugPrint("Veri çekme hatası: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veriler alınırken bir hata oluştu: $e")),
      );
    }
  }

  // Filtreleme işlemi (varsayılan, net artan, net azalan)
  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;

      if (filter == 'Net (Azalan)') {
        _examList.sort((a, b) => b['examNet'].compareTo(a['examNet']));
      } else if (filter == 'Net (Artan)') {
        _examList.sort((a, b) => a['examNet'].compareTo(b['examNet']));
      }
    });
  }

  // Ana sayfa build metodu
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lilacLight, // Açık lila arka plan
      drawer: MenuDrawer(), // Drawer menüsü
      appBar: CustomAppBar(title: "Çözülen Sınavlar"), // Özel AppBar başlık
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Filtre dropdown'ı
              Row(
                children: [
                  const Text(
                    "Sıralama: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: _selectedFilter,
                    items: [
                      'Varsayılan',
                      'Net (Azalan)',
                      'Net (Artan)',
                    ].map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text(filter),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _applyFilter(value); // Filtreyi uygula
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Sınavlar listesi veya boş mesaj
              Expanded(
                child: _examList.isEmpty
                    ? const Center(child: Text("Henüz sınav eklenmemiş."))
                    : ListView.builder(
                  itemCount: _examList.length,
                  itemBuilder: (context, index) {
                    return _buildExamCard(
                      examName: _examList[index]["examName"],
                      examNet: _examList[index]["examNet"],
                      totalCorrect: _examList[index]["totalCorrect"],
                      totalWrong: _examList[index]["totalWrong"],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // Yeni sınav eklemek için buton
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade300,
        onPressed: () => Navigator.pushNamed(context, '/denemehesapla'),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Her sınav kartını oluşturan fonksiyon
  Widget _buildExamCard({
    required String examName,
    required double examNet,
    required int totalCorrect,
    required int totalWrong,
  }) {

    Map<String, double> dataMap = {
      "Doğru": totalCorrect.toDouble(),
      "Yanlış": totalWrong.toDouble(),
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Sınav bilgileri kısmı (isim, doğru, yanlış, net)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  examName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoBox(
                      text: "Doğru",
                      value: totalCorrect.toString(),
                      color: const Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoBox(
                      text: "Yanlış",
                      value: totalWrong.toString(),
                      color: const Color(0xFFF44336),
                    ),
                    const SizedBox(width: 8),
                    _buildInfoBox(
                      text: "Net",
                      value: examNet.toStringAsFixed(1),
                      color: const Color(0xFF9C27B0),
                    ),
                  ],
                ),
              ],
            ),
            // Pie chart görseli
            SizedBox(
              width: 90,
              height: 90,
              child: PieChart(
                dataMap: dataMap,
                animationDuration: const Duration(milliseconds: 800),
                chartRadius: MediaQuery.of(context).size.width / 5,
                colorList: const [
                  Color(0xFF4CAF50),
                  Color(0xFFF44336),
                ],
                chartType: ChartType.ring,
                baseChartColor: Colors.grey.shade300,
                legendOptions: const LegendOptions(
                  showLegends: false,
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  chartValueStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bilgi kutusu (Doğru/Yanlış/Net) için widget
  Widget _buildInfoBox({
    required String text,
    required String value,
    required Color color,
  }) {
    return Container(
      width: 60,
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
