import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:yks_deneme_takip2/drawer.dart';

const Color lilacLight = Color(0xFFF3E5F5);

class GecmisSinavlar extends StatefulWidget {
  const GecmisSinavlar({super.key});

  @override
  State<GecmisSinavlar> createState() => GecmisSinavlarState();
}

class GecmisSinavlarState extends State<GecmisSinavlar> {
  List<Map<String, dynamic>> _examList = [];

  void _getExamInfoFromDevice() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> examList = prefs.getStringList('examList') ?? [];

    List<Map<String, dynamic>> tempList = examList.map((exam) {
      List<String> parts = exam.split('|');
      return {
        "examName": parts[0],
        "examNet": double.tryParse(parts[1]) ?? 0.0,
        "totalCorrect": int.tryParse(parts[2]) ?? 0,
        "totalWrong": int.tryParse(parts[3]) ?? 0,
      };
    }).toList();

    setState(() {
      _examList = tempList;
    });
  }

  @override
  void initState() {
    super.initState();
    _getExamInfoFromDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lilacLight,
      drawer: MenuDrawer(),
      appBar: AppBar(
        title: const Text("Çözülen Sınavlar"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: _examList.length,
            itemBuilder: (context, index) {
              int totalCorrect = _examList[index]["totalCorrect"];
              int totalWrong = _examList[index]["totalWrong"];
              double examNet = _examList[index]["examNet"];

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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _examList[index]["examName"]!,
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
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: PieChart(
                          dataMap: dataMap,
                          animationDuration: const Duration(milliseconds: 800),
                          chartRadius: MediaQuery.of(context).size.width / 5,
                          colorList: const [
                            Color(0xFF4CAF50),
                            Color(0xFFF44336)
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
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue.shade300,
        onPressed: () => Navigator.pushNamed(context, '/denemehesapla'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildInfoBox({required String text, required String value, required Color color}) {
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
