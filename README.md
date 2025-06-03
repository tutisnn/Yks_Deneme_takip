#  YKS Deneme Takip Uygulaması

Bu Flutter projesi, YKS’ye hazırlanan öğrencilerin deneme sınavlarını takip etmelerini sağlamak amacıyla geliştirilmiştir. Kullanıcılar deneme sonuçlarını sisteme girerek başarılarını takip edebilir, grafiklerle gelişimlerini gözlemleyebilir ve motivasyonlarını koruyabilirler.  

---

##  Proje Şeması

```
lib/
├── main.dart
├── firebase_options.dart
├── pages/
│ ├── Anasayfa.dart
│ ├── DenemeHesaplama.dart
│ ├── GecmisSinavlar.dart
│ ├── GirisSayfasi.dart
│ ├── KayitSayfasi.dart
│ ├── KonuTakip.dart
│ ├── ProfilDüzenle.dart
│ └── ProfilEkrani.dart
├── services/
│ ├── firebase_service.dart
│ ├── shared_prefs_service.dart
│ ├── giris_servisi.dart
│ └── supabase_service.dart
├── models/
│ └── User.dart
├── widgets/
│ ├── base_page.dart
│ ├── custom_app_bar.dart
│ └── drawer.dart

assets/
├── fonts/
│ └── BungeeSpice-Regular.ttf
├── images/
│ ├── background.png
│ ├── clock.png
│ ├── github.png
│ ├── google_logo.png
│ ├── light-1.png
│ └── light-2.png
```

---

## 📄 Proje Sayfaları ve Görevleri

### 🏠 Anasayfa.dart

* Uygulamanın ana menüsü ve sayaç yapısını içerir.
* Kullanıcının kolayca diğer sayfalara erişimini sağlar.
* Menü butonları ve kullanıcı dostu bir tasarım sunar.

### 🔐 GirisSayfasi.dart

* Kullanıcı giriş işlemlerini yönetir.
* E-posta/şifre, Google ve GitHub ile giriş seçenekleri sunar.
* Firebase Authentication kullanılarak kimlik doğrulama işlemleri yapılır.
* Giriş başarılı olduğunda Anasayfa'ya yönlendirir.

### 📝 KayitSayfasi.dart

* Kullanıcı kayıt işlemlerini gerçekleştirir.
* E-posta/şifre, Google ve GitHub ile kayıt olma desteği sunar.
* Kayıt başarılı olduğunda Firebase Authentication ve Firestore'a kullanıcı bilgisi eklenir, ardından Giriş Sayfası'na yönlendirilir.

### ➕ DenemeHesaplama.dart

* Kullanıcının girdiği doğru/yanlış sayılarına göre net hesaplama yapar.
* Hesaplanan sonuçlar Firebase, Supabase ve SharedPreferences'a kaydedilir.
* Kullanıcının sınav performansını detaylı şekilde analiz eder.

### 📊 GecmisSinavlar.dart

* Daha önceki sınav sonuçlarını listeler.
* Listeleme, sıralama (artan/azalan) ve arama özellikleri sunar.
* Grafiksel sunumlar (pie chart vb.) içerir.
* Firebase ve Supabase'ten verileri çeker ve dinamik olarak görüntüler.

### 📚 KonuTakip.dart

* YKS konularını (TYT/AYT) listeleyen ve işaretleme yapılabilen bir sayfadır.
* Kullanıcılar, tamamladıkları konuları seçerek ilerlemelerini takip edebilir.
* Konu takibi Firebase ve SharedPreferences'a kaydedilir.

### 👤 ProfilEkrani.dart

* Kullanıcının adı, soyadı, e-posta adresi, doğum yeri, doğum tarihi, yaşadığı şehir bilgilerini görüntüler.
* Kullanıcının **Profil Düzenle** sayfasına erişmesini sağlar.
* Firebase, Supabase ve SharedPreferences'tan verileri çeker ve gösterir.

### 🖊️ ProfilDüzenle.dart

* Kullanıcının profil bilgilerini (isim, soyisim, doğum yeri, doğum tarihi, şehir) eklemesini ve güncellemesini sağlar.
* Güncellenen bilgiler Firebase, Supabase ve SharedPreferences'a kaydedilir.
* Kullanıcı deneyimini kolaylaştırmak için form alanları ve butonlar içerir.

---

## 📡 Services (Servis Dosyaları)

### firebase\_service.dart

* Firestore ve Storage işlemlerini yönetir.
* Kullanıcıyı kaydetme, güncelleme işlemlerini sağlar.
* Kullanıcının **Ad**, **Soyad**, **E-posta**, **Doğum Tarihi**, **Doğum Yeri** ve **Yaşadığı İl**  kullanicilar tablosunda bilgileri saklanır.

### supabase\_service.dart

* Kullanıcının **Ad**, **Soyad**, **E-posta**, **Doğum Tarihi**, **Doğum Yeri** ve **Yaşadığı İl**  gibi profil bilgileri  kullanicilar tablosunda saklanır.
* Ekstra olarak Kullanıcının deneme net sonucları netler tablosunda saklanır. Listelenir.

### shared\_prefs\_service.dart

* Kullanıcı bilgilerini SharedPreferences ile lokal olarak cihazda saklar.

### giris\_servisi.dart

* Google, GitHub ve e-posta ile giriş ve kayıt işlemlerini yönetir.
* Firebase Authentication ile entegre çalışır ve kullanıcı kimlik doğrulamasını sağlar.

---

## 🔧 Widgets (Bileşen Dosyaları)

### drawer.dart

* Sayfalar arası geçişi sağlar.
* Her sayfada kullanılmak üzere ayrı bir widget olarak tasarlanmıştır.
* Firebase Authentication ile giriş yapan kullanıcının bilgilerini dinamik olarak çeker ve gösterir.
* Çıkış yap butonu içerir.

### base\_page.dart

* Uygulamanın temel iskelet yapısını sağlar.
* Sayfalarda ortak bir yapı sunarak tasarım ve kod bütünlüğü sağlar.
* ProfilEkrani ve diğer sayfalar BasePage üzerinden yüklenir.

### custom\_app\_bar.dart

* Özel tasarlanmış bir AppBar bileşenidir.
* Her sayfada kullanılarak tutarlı bir üst menü (AppBar) sunar.
* Başlıklar, renkler ve ikonlar özelleştirilebilir.

---

## 👥 Models (Veri Modelleri)

### User.dart

- Kullanıcı bilgilerini temsil eden veri modelidir.
- İsim, soyisim, e-posta, doğum yeri, doğum tarihi ve şehir gibi alanları içerir.
- Firebase, Supabase ve SharedPreferences ile veri alışverişinde kullanılır.

---

## 🚀 main.dart

* Uygulamanın başlangıç noktasıdır.
* Routing işlemleri (sayfalar arası geçişler) burada tanımlanır.
* Firebase ve Supabase başlangıç ayarları burada yapılır.

---

## 🧱 Modülerlik Yaklaşımı

Bu projede, **modüler bir yapı** benimsenmiştir.  
Her özellik ve işlev için ayrı bir dosya ve klasör oluşturularak, **temiz**, **anlaşılır** ve **bakımı kolay** bir yapı hedeflenmiştir.

🔹 **Sayfalar (Pages)** klasörü, kullanıcı arayüzüne ait ekranları içerir.  
🔹 **Services** klasörü, Firebase, Supabase ve diğer servislerin bağlantı ve işlemlerini yönetir.  
🔹 **Widgets** klasörü, tekrar kullanılabilir bileşenleri (Drawer, AppBar, vb.) barındırır.  
🔹 **Models** klasörü, uygulamadaki veri modellerini içerir (örneğin, User modeli).  
🔹 **Assets** klasörü, görseller ve fontlar gibi statik dosyaları içerir.

---

## 📝 Kayıt İşlemleri Kullanım Senaryosu

- Kullanıcı ilk olarak kayıt olur.
- Kayıt işlemi, **e-posta/şifre**, **Google** veya **GitHub** ile yapılabilir.
- Eğer kullanıcı **e-posta ile kayıt** olmuşsa, kayıt sonrası **Giriş Sayfası'na** yönlendirilir.
- **Google** ve **GitHub** ile kayıt olan kullanıcılar, diğer uygulamalardaki gibi **direkt giriş yapar**.
- Kayıt olan kullanıcı, **Firebase Authentication**'a düşer. Ayrıca **Firebase Firestore**'da kullanıcının **e-posta adresi** saklanır.
- Kullanıcı daha sonra **Profilim** sayfasından **Adı**, **Soyadı**, **Yaşadığı Şehir**, **Doğum Yeri** ve **Doğum Tarihi** bilgilerini ekleyebilir ve sonrasında güncelleyebilir.
- Bu bilgiler aynı anda:
  - **Firebase** (Firestore)
  - **Supabase**
  - **SharedPreferences**'a kayıt edilir.

---

## 🔑 Firebase Authenticationdaki Kayıtlı Kullanıcı Bilgileri

Firebase Authentication'da kayıtlı kullanıcı aşağıdaki gibidir.  
Siz de bu bilgilerle giriş sağlayabilirsiniz.

### 👤 Kayıtlı Kullanıcı

- **E-posta:** caglar@gmail.com
- **Şifre:** caglar123

---

## 👥 Grup Üyelerinin Projeye Katkısı / Sorumlu Olduğu Sayfalar

### 🧩 Tuhana Sinan

- **DenemeHesaplamaPage (DenemeHesaplama.dart)** geliştirilmesi ve veritabanı bağlantıları
- **GecmisSinavlarPage (GecmisSinavlar.dart)** için listeleme, sıralama ve grafiksel sunum
- **SupabaseService (supabase_service.dart)** geliştirilmesi. Supabase bağlantısının kurulması, Supabase servislerinin yazılması.
- **FirebaseService (firebase_service.dart)** geliştirilmesi. Firebase bağlantıların kurulması. Firestore ve Depolama işlemleri için Firebase servislerinin yazılması.
- **SharedPrefsService (shared_prefs_service.dart)** hocanın
- **GirisServisi (giris_servisi.dart)** geliştirilmesi (Google, GitHub, e-posta giriş işlemleri)
- **User (user.dart)** User modelinin geliştirilmesi.
- **custom_app_bar** Custom app bar widgetinin geliştirilmesi.
- **Profil Düzenle** ve **Profil Ekrani** servislerle uyumlu olacak şekilde geliştirilmesi.

### 🎨 Fatma Eslem Özsalih

- **Drawer (drawer.dart)** geliştirilmesi
- **GirisSayfasi (GirisSayfasi.dart)** ve **KayitSayfasi** tasarım geliştirilmesi.
- **HomePage (Anasayfa.dart)** tasarım geliştirilmesi.
- **KonuTakipPage (KonuTakip.dart)** tasarımı ve geliştirilmesi
- **base_page** widgetinin geliştirilmesi

## Sayfaların Ekran Görüntüsü
<img src="https://github.com/user-attachments/assets/d66690ab-6dcb-4f31-9fd9-53c4c8377944" width="400" />

<img src="https://github.com/user-attachments/assets/783539a8-0466-446c-8eef-f44ddb2f3420" width="400" />

<img src="https://github.com/user-attachments/assets/06d7ccbe-63a7-4d7f-beb8-6ceb22391371" width="400" />

<img src="https://github.com/user-attachments/assets/7bc20b61-a45b-41e3-b852-a43957dd1d05" width="400" />

<img src="https://github.com/user-attachments/assets/8af2f939-301d-454c-8a48-59f1e4507165" width="400" />

<img src="https://github.com/user-attachments/assets/c92fa7f8-f68c-44b5-85e1-fbcf715274de" width="400" />

<img src="https://github.com/user-attachments/assets/fe4e43de-23bb-4eec-8310-f48fdf81ff33" width="400" />

<img src="https://github.com/user-attachments/assets/d1d614cc-11d1-40bf-9a1b-0480d648c205" width="400" />
<img src="https://github.com/user-attachments/assets/e05ca289-2d8c-4588-b9ab-dbb31195ddbc" width="400" />



<img src="https://github.com/user-attachments/assets/0309240f-bb82-433e-9a21-8d9ab7db47bb" width="400" />

---
