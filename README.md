# 📚 YKS Deneme Takip Uygulaması

Bu Flutter projesi, YKS’ye hazırlanan öğrencilerin deneme sınavlarını takip etmelerini sağlamak amacıyla geliştirilmiştir. Kullanıcılar deneme sonuçlarını sisteme girerek başarılarını takip edebilir, grafiklerle gelişimlerini gözlemleyebilir ve motivasyonlarını koruyabilirler.  

---

## 📁 Proje Şeması

```
lib/ 
├── main.dart
├── pages/
│   ├── login_page.dart
│   ├── home_page.dart
│   ├── deneme_hesaplama_page.dart
│   ├── gecmis_sinavlar_page.dart
│   ├── konu_takip_page.dart
├── widgets/
│   ├── drawer.dart
│   └── logo_saglayici.dart
assets/ 
├── fonts/
│   ├── BungeeSpice-Regular
├── images/
│   ├── background.png
    ├── clock.png
    ├── light-1.png
    └── light-2.png
```
## 📱 Proje Sayfaları ve Görevleri
- **home_page**: Uygulama menüsü ve sayaç içerir.
- **login_page**: Kullanıcının giriş yapmasını sağlar. 
- **deneme_hesaplama_page**: Kullanıcı deneme sonucu netini hesaplar, görüntüler ve isterse kaydeder.
- **gecmis_sinavlar_page**: Önceden kaydedilen denemelerin listelenmesi ve grafiksel sunumu
- **drawer**: Sayfalar arası geçişi sağlar ve kullanıcı bilgilerine erişim sunar.
- **logo_saglayici**:Drawer menüsünde gösterilen logoyu sağlar
- **main**:routing işlemleri için

---

## 🎨 Drawer Menüdeki Logo ve API Bilgisi

Drawer menüsünde gösterilen logo, `LogoSaglayici` adlı özel bir sınıf tarafından sağlanmaktadır. Bu sınıf, logoları **MockAPI** üzerinden kendi oluşturuduğumuz apiden dinamik olarak çeker. Kendi apimizi oluşturmamızın sebebi kendi logo fotograflarımızı kullanmak istememizdi.Kendi oluşturduğumuz Kullanılan API adresi:https://67f24369ec56ec1a36d295de.mockapi.io/api/YksDenemeTakip/logos


---

## 🔐 Login Bilgileri Nasıl Saklanıyor?

Kullanıcı adı ve şifre gibi bilgiler `shared_preferences` paketi kullanılarak lokal cihazda güvenli bir şekilde saklanmaktadır.

Kullanılan paket:
```yaml
shared_preferences: ^2.2.2
```

---

## 👥 Grup Üyelerinin Katkıları

Görev dağılımını, proje sayfalarını aramızda paylaşarak gerçekleştirdik.

| Grup Üyesi           | Görevleri                                                                 |
|----------------------|---------------------------------------------------------------------------|
| Tuhana Sinan         | `drawer`, `logo_saglayici`, `deneme_hesaplama_page`, `gecmis_denemeler_page` |
| Fatma Eslem Özsalih | `login_page`, `home_page`, `konu_takip_page`, `deneme_hesaplama_page`     |

> Ortak çalıştığımız sayfalarda, **fonksiyonel kısımlar** Tuhana tarafından, **tasarım (UI)** kısımları ise Eslem tarafından geliştirildi.  
> Kod geliştirme süreci Git üzerinden yürütüldü ve düzenli commit mesajları ile takip edildi.
---

## 📂 Kullanılan Paketler

- `shared_preferences`: Lokal veri kaydı
- `http`: API bağlantıları için 
- `pie_chart`: Grafiklerle analiz
- `provider`: State management
- `animate_do`: Animasyon efektleri
- `google_fonts`: Font özelleştirmeleri

---
## 🌟 Projenin Öne Çıkan Özellikleri

- Kullanıcıya özel skor takibi (doğru/yanlış sayısı)
- Deneme sonuçlarını grafikle izleme
- Giriş çıkış sisteminde shared_preferences ile kullanıcıya özel veriler
- Soft pastel renklerde sade ve çocuklara uygun arayüz tasarımı

---

## 💡 Yaratıcı ve Özgün Yaklaşım

- Uygulama, sadece sonuç girişi değil, kullanıcıya görsel gelişim takibi sunarak fark yaratmaktadır.
- Özellikle soft renk tasarımı ile stresi azaltıcı bir arayüz hedeflenmiştir.
- Kullanıcıya özel skorlar kaydedilerek çok kullanıcılı destek sağlanmıştır.

---



## 🧠 Diğer Notlar

- Proje Flutter 3.7.0 SDK ile geliştirilmiştir.
- UI/UX testleri yapılmış, kullanıcı deneyimi odaklı sade bir yapı benimsenmiştir.
- `pubspec.yaml`, `analysis_options.yaml` ve asset yapısı düzenlenmiştir.

---

## 🚀 Başlamak İçin

```bash
flutter pub get
flutter run
```

---

> Proje geliştiricileri olarak umarız ki bu uygulama, YKS’ye hazırlanan öğrenciler için faydalı bir araç olur. 🧠📈
