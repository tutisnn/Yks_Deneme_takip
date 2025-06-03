import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yks_deneme_takip/widgets/base_page.dart'; // BasePage import

class Konutakip extends StatefulWidget {
  const Konutakip({super.key});

  @override
  State<Konutakip> createState() => _KonutakipState();
}

class _KonutakipState extends State<Konutakip> with TickerProviderStateMixin {
  late TabController _tabController;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BasePage(
      title: "Konu Takibi",
      content: Column(
        children: [
          Material(
            color: theme.appBarTheme.backgroundColor, // Tema renginden alır!
            child: TabBar(
              controller: _tabController,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              indicatorColor: theme.colorScheme.secondary,
              tabs: const [
                Tab(text: "TYT"),
                Tab(text: "AYT"),
                Tab(text: "EA"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildChecklist(context, tytTopics),
                buildChecklist(context, aytTopics),
                buildChecklist(context, eaTopics),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChecklist(BuildContext context, Map<String, List<String>> topics) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor, // Tema rengi
      child: ListView(
        padding: EdgeInsets.all(12),
        children: topics.entries.map((entry) {
          String category = entry.key;
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.cardColor, // Tema uyumlu kart rengi
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.2),
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
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              children: entry.value.map((topic) {
                bool isChecked = completedTopics[category]?.contains(topic) ?? false;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.canvasColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: CheckboxListTile(
                      activeColor: theme.colorScheme.secondary,
                      title: Text(
                        topic,
                        style: GoogleFonts.quicksand(
                          decoration: isChecked ? TextDecoration.lineThrough : null,
                          color: isChecked ? Colors.grey : theme.textTheme.bodyLarge?.color,
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
