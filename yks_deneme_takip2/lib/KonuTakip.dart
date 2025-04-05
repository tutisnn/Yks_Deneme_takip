import 'package:flutter/material.dart';
import 'drawer.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> with TickerProviderStateMixin {
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

  Widget buildChecklist(Map<String, List<String>> topics) {
    return ListView(
      children: topics.entries.map((entry) {
        String category = entry.key;
        return ExpansionTile(
          title: Text(category, style: const TextStyle(fontWeight: FontWeight.bold)),
          children: entry.value.map((topic) {
            bool isChecked = completedTopics[category]?.contains(topic) ?? false;
            return CheckboxListTile(
              title: Text(topic),
              value: isChecked,
              onChanged: (_) => toggleTopic(category, topic),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Konu Takibi"),
          backgroundColor: const Color.fromRGBO(143, 148, 251, 1),
          bottom: TabBar(
            controller: _tabController,
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
}
