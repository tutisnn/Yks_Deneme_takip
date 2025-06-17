import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yks_deneme_takip/widgets/base_page.dart'; // BasePage import

class Konutakip extends StatefulWidget {
  const Konutakip({super.key});

  @override
  State<Konutakip> createState() => _KonutakipState();
}

class _KonutakipState extends State<Konutakip> with TickerProviderStateMixin {
  late TabController _tabController; // TabController, sekmeler arası geçiş için

  // TYT konuları kategoriye göre listeleniyor
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

  // EA konuları kategoriye göre listeleniyor
  Map<String, List<String>> eaTopics = {
    "Edebiyat": ["Şiir Türleri", "Roman - Hikaye"],
    "Coğrafya": ["Türkiye’nin Yer Şekilleri", "Nüfus"],
    "Tarih": ["Osmanlı Kültürü", "Kurtuluş Savaşı"],
    "Geometri": ["Çokgenler", "Dörtgenler"],
    "Matematik": ["Türev", "İntegral"],
  };

  // AYT konuları kategoriye göre listeleniyor
  Map<String, List<String>> aytTopics = {
    "Fizik": ["Hareket", "Kuvvet ve Newton", "Enerji"],
    "Kimya": ["Atom ve Periyodik Sistem", "Kimyasal Türler"],
    "Biyoloji": ["Canlıların Yapısı", "Hücre"],
    "Geometri": ["Çokgenler", "Dörtgenler"],
    "Matematik": ["Türev", "İntegral"],
  };

  Map<String, Set<String>> completedTopics = {}; // İşaretlenen tamamlanmış konular

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // 3 sekme için controller
  }

  // Checkbox tıklanınca çağrılır, konuyu tamamlanmış olarak işaretler/kaldırır
  void toggleTopic(String category, String topic) {
    setState(() {
      completedTopics.putIfAbsent(category, () => {});
      if (completedTopics[category]!.contains(topic)) {
        completedTopics[category]!.remove(topic); // İşaret kaldırılır
      } else {
        completedTopics[category]!.add(topic); // İşaret eklenir
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Tema bilgisini alıyoruz

    return BasePage(
      title: "Konu Takibi", // Sayfa başlığı
      content: Column(
        children: [
          Material(
            color: theme.appBarTheme.backgroundColor, // AppBar arkaplanı tema uyumlu
            child: TabBar(
              controller: _tabController, // Sekmeler arası geçiş kontrolü
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600), // Sekme yazı stili
              indicatorColor: theme.colorScheme.secondary, // Seçili sekme alt çizgi rengi
              tabs: const [
                Tab(text: "TYT"), // İlk sekme
                Tab(text: "AYT"), // İkinci sekme
                Tab(text: "EA"),  // Üçüncü sekme
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildChecklist(context, tytTopics), // TYT konusu listesi
                buildChecklist(context, aytTopics), // AYT konusu listesi
                buildChecklist(context, eaTopics),  // EA konusu listesi
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Konu listesini kategori ve konu başlıklarıyla oluşturur
  Widget buildChecklist(BuildContext context, Map<String, List<String>> topics) {
    final theme = Theme.of(context);

    return Container(
      color: theme.scaffoldBackgroundColor, // Temaya uygun arkaplan rengi
      child: ListView(
        padding: EdgeInsets.all(12),
        children: topics.entries.map((entry) {
          String category = entry.key; // Kategori adı
          return Container(
            margin: EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.cardColor, // Kart arkaplanı tema uyumlu
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.2), // Hafif gölge
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ExpansionTile(
              collapsedBackgroundColor: Colors.transparent, // Açılmamış arkaplan
              backgroundColor: Colors.transparent, // Açılmış arkaplan
              title: Text(
                category, // Kategori başlığı
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              children: entry.value.map((topic) {
                bool isChecked = completedTopics[category]?.contains(topic) ?? false; // Checkbox durumu
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.canvasColor, // İçerik arkaplanı
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.dividerColor), // Çerçeve rengi
                    ),
                    child: CheckboxListTile(
                      activeColor: theme.colorScheme.secondary, // İşaret rengi
                      title: Text(
                        topic, // Konu başlığı
                        style: GoogleFonts.quicksand(
                          decoration: isChecked ? TextDecoration.lineThrough : null, // Tamamlandı ise üstü çizili
                          color: isChecked
                              ? theme.disabledColor.withOpacity(0.7) // Tamamlanmış renk tonu
                              : theme.textTheme.bodyLarge?.color, // Normal renk
                        ),
                      ),
                      value: isChecked, // Checkbox durumu
                      onChanged: (_) => toggleTopic(category, topic), // Checkbox tıklanınca tetiklenir
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
