import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yks_deneme_takip/widgets/drawer.dart';
import 'package:yks_deneme_takip/widgets/custom_app_bar.dart';
import 'package:yks_deneme_takip/services/supabase_service.dart';

// Geçmiş Sınavlar ekranı Stateful Widget
class GecmisSinavlar extends StatefulWidget {
  const GecmisSinavlar({super.key});

  @override
  State<GecmisSinavlar> createState() => _GecmisSinavlarState();
}

class _GecmisSinavlarState extends State<GecmisSinavlar> {
  List<Map<String, dynamic>> _examList = [];// Sınav listesini tutacak dizi
  String _selectedFilter = 'Varsayılan';// Filtre seçimi için değişken

  @override
  void initState() {
    super.initState();
    _getExamInfo();// Sayfa açıldığında sınavları çek
  }
  // Supabase üzerinden sınav bilgilerini getiren fonksiyon

  Future<void> _getExamInfo() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;// Mevcut kullanıcı ID'si
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
        _examList = tempList;// Listeyi güncelle
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // blacktheme ekledim
      drawer: MenuDrawer(), // Drawer menüsü
      appBar: CustomAppBar(title: "Çözülen Sınavlar"),// Özel AppBar başlık
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Sıralama: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filtre dropdown'ı

                  DropdownButton<String>(
                    value: _selectedFilter,
                    dropdownColor: Theme.of(context).cardColor,
                    items: [
                      'Varsayılan',
                      'Net (Azalan)',
                      'Net (Artan)',
                    ].map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _applyFilter(value);// Filtreyi uygula
                      }
                    },
                  ),
                ],
              ),
              // Sınavlar listesi veya boş mesaj
              const SizedBox(height: 10),
              Expanded(
                child: _examList.isEmpty
                    ? Center(
                  child: Text(
                    "Henüz sınav eklenmemiş.",
                    style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                  ),
                )
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
          color: Theme.of(context).cardColor, // blacktheme ekledim
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).dividerColor.withOpacity(0.3), // blacktheme ekledim
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  examName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyLarge!.color, // blacktheme ekledim
                  ),
                ),
                // Sınav bilgileri kısmı (isim, doğru, yanlış, net)
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoBox(text: "Doğru", value: totalCorrect.toString(), color: const Color(0xFF4CAF50)),
                    const SizedBox(width: 8),
                    _buildInfoBox(text: "Yanlış", value: totalWrong.toString(), color: const Color(0xFFF44336)),
                    const SizedBox(width: 8),
                    _buildInfoBox(text: "Net", value: examNet.toStringAsFixed(1), color: const Color(0xFF9C27B0)),
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
                colorList: const [Color(0xFF4CAF50), Color(0xFFF44336)],
                chartType: ChartType.ring,
                baseChartColor: Theme.of(context).dividerColor.withOpacity(0.3), // blacktheme ekledim
                legendOptions: const LegendOptions(showLegends: false),
                chartValuesOptions: ChartValuesOptions(
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  chartValueStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall!.color, // blacktheme ekledim
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
