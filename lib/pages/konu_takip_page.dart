import 'package:flutter/material.dart';
import 'package:yks_deneme_takip/widgets/drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yks_deneme_takip/widgets/custom_app_bar.dart';
const Color lilacBackground = Color(0xFFF3E5F5);
const Color lilacAccent = Color(0xFFB39DDB);
const Color lilacDeep = Color(0xFF9575CD);

class Konutakip extends StatefulWidget {
  const Konutakip({super.key});

  @override
  State<Konutakip> createState() => _KonutakipState();
}

class _KonutakipState extends State<Konutakip> with TickerProviderStateMixin {
  late TabController _tabController;

  //Her alana ait dersler ve bu derslerin konusu konular
  Map<String, List<String>> tytTopics = {
    "Matematik": ["Temel Kavramlar", "Sayılar", "Rasyonel Sayılar"],
    "Türkçe": ["Sözcükte Anlam", "Cümlede Anlam", "Paragraf"],
    "Coğrafya": ["Doğa ve İnsan", "Harita Bilgisi"],
    "Din": ["İslam ve Bilim", "Kur’an"],
    "Tarih": ["Atatürk", "Lale devri"],
    "Biyoloji": ["Bölünme", "Anatomi"],
    "Kimya": ["Bileşenler", "Asit Bazlar ve Tuzlar"],
    "Felsefe": ["İslam ve Bilim", "Kur’an"],
    "Geometri": ["Açılar", "Hesaplamalar"],
  };

  Map<String, List<String>> eaTopics = {
    "Edebiyat": ["Şiir Türleri", "Roman - Hikaye"],
    "Coğrafya": ["Türkiye’nin Yer Şekilleri", "Nüfus"],
    "Tarih": ["Osmanlı Kültürü", "Kurtuluş Savaşı"],
    "Geometri": ["Çokgenler", "Dörtgenler"],
    "Matematik": ["Türev", "İntegral"],
  };

  Map<String, List<String>> aytTopics = {
    "Fizik": ["Hareket", "Kuvvet ve Newton", "Enerji"],
    "Kimya": ["Atom ve Periyodik Sistem", "Kimyasal Türler"],
    "Biyoloji": ["Canlıların Yapısı", "Hücre"],
    "Geometri": ["Çokgenler", "Dörtgenler"],
    "Matematik": ["Türev", "İntegral"],
  };

  //// Biten dersleri işaretleyip takip etmek için oluşturulan yapı

  Map<String, Set<String>> completedTopics = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  void toggleTopic(String category, String topic) {
    setState(() {
      completedTopics.putIfAbsent(category, () => {});
      if (completedTopics[category]!.contains(topic)) {
        completedTopics[category]!.remove(topic);
      } else {
        completedTopics[category]!.add(topic);
      }
    });
  }

  //Ana widget
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(242, 242, 242, 1),
        appBar: CustomAppBar(
          title: "Konu Takibi",
          bottom: TabBar(
            controller: _tabController,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: "TYT"),
              Tab(text: "AYT"),
              Tab(text: "EA"),
            ],
          ),
        ),

        drawer: MenuDrawer(),
        body: TabBarView(
          controller: _tabController,
          children: [
            buildChecklist(tytTopics),
            buildChecklist(aytTopics),
            buildChecklist(eaTopics),
          ],
        ),
      ),
    );
  }

  //Dersleri ve konuları içeren checklist widgeti
  Widget buildChecklist(Map<String, List<String>> topics) {
    return Container(
      color: lilacBackground,
      child: ListView(
        padding: EdgeInsets.all(12),
        children: topics.entries.map((entry) {
          String category = entry.key;
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: lilacAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(242, 242, 242, 1),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ExpansionTile(
              collapsedBackgroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              title: Text(
                category,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              children: entry.value.map((topic) {
                bool isChecked = completedTopics[category]?.contains(topic) ?? false;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: lilacAccent.withOpacity(0.5)),
                    ),
                    child: CheckboxListTile(
                      activeColor: lilacDeep,
                      title: Text(
                        topic,
                        style: GoogleFonts.quicksand(
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                          color: isChecked ? Colors.grey : Colors.black,
                        ),
                      ),
                      value: isChecked,
                      onChanged: (_) => toggleTopic(category, topic),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}
