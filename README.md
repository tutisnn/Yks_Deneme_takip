# 📚 YKS Deneme Takip Uygulaması

Bu Flutter projesi, YKS’ye hazırlanan öğrencilerin deneme sınavlarını takip etmelerini sağlamak amacıyla geliştirilmiştir. Kullanıcılar deneme sonuçlarını sisteme girerek başarılarını takip edebilir, grafiklerle gelişimlerini gözlemleyebilir ve motivasyonlarını koruyabilirler.

---

## 📦 Proje Dosya Yapısı

lib/
├── main.dart
├── pages/
│ ├── login_page.dart
│ ├── register_page.dart
│ ├── home_page.dart
│ ├── deneme_hesaplama_page.dart
│ ├── gecmis_sinavlar_page.dart
│ ├── konu_takip_page.dart
│ ├── ProfilEkrani.dart
│ ├── ProfilDuzenle.dart
├── widgets/
│ ├── drawer.dart
│ ├── custom_app_bar.dart
│ └── base_page.dart
├── services/
│ ├── giris_servisi.dart
├── models/
│ ├── User.dart
assets/
├── images/
│ ├── background.png
│ ├── clock.png
│ ├── light-1.png
│ ├── light-2.png
│ ├── google_logo.png
├── fonts/
│ ├── BungeeSpice-Regular.ttf

---

## 📃 Sayfaların Görevleri

| Sayfa Adı                    | Görevleri                                                                                   |
|-----------------------------|---------------------------------------------------------------------------------------------|
| `login_page.dart`            | Kullanıcı giriş işlemleri (email, şifre, Google, GitHub)                                      |
| `register_page.dart`         | Kullanıcı kayıt işlemleri                                                                    |
| `home_page.dart`             | Ana sayfa ve sayaç                                                                          |
| `deneme_hesaplama_page.dart` | Deneme netlerini hesaplama ve kaydetme                                                       |
| `gecmis_sinavlar_page.dart`  | Önceki denemeleri görüntüleme ve analiz grafiği                                              |
| `konu_takip_page.dart`       | TYT-AYT konu takip sistemi                                                                  |
| `ProfilEkrani.dart`          | Kullanıcı bilgilerini görüntüleme (ad, soyad, doğum yeri, şehir, doğum tarihi)               |
| `ProfilDuzenle.dart`         | Profil bilgilerini düzenleme                                                                 |
| `drawer.dart`                | Menü ve sayfalar arası geçiş                                                                 |
| `custom_app_bar.dart`        | Özel AppBar yapısı                                                                          |

---

## 👩‍💻 Grup Üyelerinin Katkıları

| Grup Üyesi           | Katkıları                                                                                                                                                            |
|----------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Fatma Eslem Özsalih** | `login_page.dart`, `home_page.dart`, `ProfilEkrani.dart`, `ProfilDuzenle.dart` ve tasarım geliştirmeleri                                                             |
| **Tuhana Sinan**      | `drawer.dart`, `deneme_hesaplama_page.dart`, `gecmis_sinavlar_page.dart`, API entegrasyonu,konu_takip_page.dart`,veritabanı bağlantıları ve Firebase entegrasyonları |

---

## 🔐 Kullanıcı Bilgilerinin Saklanması

- Kullanıcı giriş bilgileri (email, şifre, UID) `FirebaseAuth` ve `SharedPreferences` ile saklanmaktadır.
- Kullanıcı detayları (`ad`, `soyad`, `doğum yeri`, `şehir`, `doğum tarihi`) `Cloud Firestore` üzerinden tutulur.
- Kullanıcı puanları ve skorları `Supabase` üzerinde saklanmaktadır.

---

## 🧩 Kullanılan Paketler

- `firebase_auth`
- `cloud_firestore`
- `supabase_flutter`
- `shared_preferences`
- `provider`
- `animate_do`
- `google_fonts`
- `http`

---

## 🎨 Özgünlük ve Tasarım

- Soft pastel renkler ile kullanıcı dostu bir arayüz
- Kullanıcıların rahat anlayabileceği basit ve sade bir tasarım
- Firebase ve Supabase entegrasyonları ile çok kullanıcılı sistem desteği
- Google ve GitHub ile kolay giriş
- Kullanıcı verilerini görüntüleme ve düzenleme imkanı
- Karanlık mod desteği (Tema değiştirme özelliği)

---

## 🏁 Proje Bağlantısı

📍 **GitHub Linki**: [YKS Deneme Takip Uygulaması](https://github.com/tutisnn/Yks_Deneme_takip.git)

---
