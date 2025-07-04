#  YKS Deneme Takip Uygulaması

Bu Flutter projesi, YKS’ye hazırlanan öğrencilerin deneme sınavlarını takip etmelerini sağlamak amacıyla geliştirilmiştir. Kullanıcılar deneme sonuçlarını sisteme girerek başarılarını takip edebilir, grafiklerle gelişimlerini gözlemleyebilir ve motivasyonlarını koruyabilirler.  
---
DİKKAT:Eğer emulatörde  sürümden kaynakli sdk ve ya kotlin hatası alırsanız lütfen web (chromeda) deneyin sorunsuz çalışacaktır.
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
│ ├── ProfilEkrani.dart
│ └── BizeUlasin.dart   
├── services/
│ ├── firebase_service.dart
│ ├── shared_prefs_service.dart
│ ├── giris_servisi.dart
│ └── supabase_service.dart
├── themes/
│ └── Themes.dart
├── models/
│   ├── User.dart
│   └── ThemeNotifier.dart 
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
<div style="display: flex; justify-content: space-between; align-items: center;">
  <div>

* Uygulamanın ana menüsü ve sayaç yapısını içerir.
* Kullanıcının kolayca diğer sayfalara erişimini sağlar.
* Menü butonları ve kullanıcı dostu bir tasarım sunar.

  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/eae74102-e9fe-4a8b-8ec6-e1d90dedc0a4" width="200" />
    <img src="https://github.com/user-attachments/assets/d10b0016-4fe8-4dae-a3cd-5d14b5e1c771" width="200" />
  </div>
</div>

### 🔐 GirisSayfasi.dart
<div style="display: flex; justify-content: space-between; align-items: center;">
  <div>

* Kullanıcı giriş işlemlerini yönetir.
* E-posta/şifre, Google ve GitHub ile giriş seçenekleri sunar.
* Firebase Authentication kullanılarak kimlik doğrulama işlemleri yapılır.
* Giriş başarılı olduğunda Anasayfa'ya yönlendirilir.

  </div>
  <img src="https://github.com/user-attachments/assets/7c56d16d-27b6-44cd-86b4-0a0805a60a1d" width="200" />
</div>

### 📝 KayitSayfasi.dart
<div style="display: flex; justify-content: space-between; align-items: center;">
  <div>

* Kullanıcı kayıt işlemlerini gerçekleştirir.
* E-posta/şifre, Google ve GitHub ile kayıt olma desteği sunar.
* Kayıt başarılı olduğunda Firebase Authentication ve Firestore'a kullanıcı bilgisi eklenir, ardından Giriş Sayfası'na yönlendirilir.

  </div>
  <img src="https://github.com/user-attachments/assets/f585b142-fd84-4039-9665-0c26b501568c" width="200" />
</div>

### ➕ DenemeHesaplama.dart
<div style="display: flex; justify-content: space-between; align-items: center;">
  <div>

* Kullanıcının girdiği doğru/yanlış sayılarına göre net hesaplama yapar.
* Hesaplanan sonuçlar Firebase, Supabase ve SharedPreferences'a kaydedilir.
* Kullanıcının sınav performansını detaylı şekilde analiz eder.

  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/69181771-990c-4e24-b63a-c311f0d5196d" width="200" />
    <img src="https://github.com/user-attachments/assets/30c2740c-3727-415e-8fd2-a2acfb689d0a" width="200" />
  </div>
</div>

### 📊 GecmisSinavlar.dart
<div style="display: flex; justify-content: space-between; align-items: center;">
  <div>

* Daha önceki sınav sonuçlarını listeler.
* Listeleme, sıralama (artan/azalan) ve arama özellikleri sunar.
* Grafiksel sunumlar (pie chart vb.) içerir.
* Supabase'ten verileri çeker ve dinamik olarak görüntüler.

  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/a624cc3f-c435-400a-a289-378d9c356060" width="200" />
    <img src="https://github.com/user-attachments/assets/ada96fe3-4e60-4399-aad3-187dfe1abe92" width="200" />
  </div>
</div>

### 📚 KonuTakip.dart
<div style="display: flex; justify-content: space-between; align-items: center;">
  <div>

* YKS konularını (TYT/AYT) listeleyen ve işaretleme yapılabilen bir sayfadır.
* Kullanıcılar, tamamladıkları konuları seçerek ilerlemelerini takip edebilir.
* Konu takibi Firebase ve SharedPreferences'a kaydedilir.

  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/cc5118db-ef1e-4de5-be26-be07e9d143c0" width="200" />
    <img src="https://github.com/user-attachments/assets/2b8fcb65-1642-4688-a25b-55a4954d5061" width="200" />
  </div>
</div>

### 👤 ProfilEkrani.dart
<div style="display: flex; justify-content: space-between; align-items: center;">
  <div>

* Kullanıcının adı, soyadı, e-posta adresi, doğum yeri, doğum tarihi, yaşadığı şehir bilgilerini görüntüler.
* Kullanıcının **Profil Düzenle** sayfasına erişmesini sağlar.
* Firebase'den verileri çeker ve gösterir.
* 
  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/5c1cac4a-b170-445c-b195-61e3bca03013" width="200" />
    <img src="https://github.com/user-attachments/assets/d7825da1-0962-4c51-9e46-4750e3855d96" width="200" />
  </div>
</div>

### 🖊️ ProfilDüzenle.dart
<div style="display: flex; justify-content: space-between; align-items: center;">
  <div>

* Kullanıcının profil bilgilerini (isim, soyisim, doğum yeri, doğum tarihi, şehir) eklemesini ve güncellemesini sağlar.
* Güncellenen bilgiler Firebase, Supabase ve SharedPreferences'a kaydedilir.
* Kullanıcı deneyimini kolaylaştırmak için form alanları ve butonlar içerir.

  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/37859dfa-27c6-46a4-be3e-3da2136239ff" width="200" />
    <img src="https://github.com/user-attachments/assets/05cfacce-35c6-4601-9b3b-f528f3660ff5" width="200" />
  </div>
</div>

### 📬 BizeUlasin.dart
<div style="display: flex; justify-content: space-between; align-items: center;">
  <div>

- Kullanıcının geliştiriciyle iletişim kurmasını sağlar.
- Form alanlarında e-posta, konu ve mesaj bilgileri yer alır.
- Gönder butonu ile yazılan mesaj doğrulanır ve işlem yapılabilir hale gelir.
- Kullanıcı dostu ve sade bir iletişim arayüzü sunar.

  </div>
  <div>
    <img src="https://github.com/user-attachments/assets/18ab0b5b-7f54-4d3a-8b37-32dc6b3efc24" width="200" />
    <img src="https://github.com/user-attachments/assets/f0f92be7-e4d5-44e3-9c40-0b242f079262" width="200" />
  </div>
</div>

---

## 📡 Services (Servis Dosyaları)

### firebase\_service.dart

* Firestore ve Storage işlemlerini yönetir.
* Kullanıcıyı kaydetme, güncelleme işlemlerini sağlar.
* Kullanıcının **Ad**, **Soyad**, **E-posta**, **Doğum Tarihi**, **Doğum Yeri** ve **Yaşadığı İl**  kullanicilar tablosunda bilgileri saklanır.
<img src="https://github.com/user-attachments/assets/ca8f45a2-6ba5-440a-8804-fbb2900698b9"  height="200" />


### supabase\_service.dart

* Kullanıcının **Ad**, **Soyad**, **E-posta**, **Doğum Tarihi**, **Doğum Yeri** ve **Yaşadığı İl**  gibi profil bilgileri  kullanicilar tablosunda saklanır.
    <img src="https://github.com/user-attachments/assets/ff1ea92a-44ba-4d20-b5d8-80bdbd71fcec" height="200" />
* Ekstra olarak Kullanıcının deneme net sonucları netler tablosunda saklanır. Listelenir.

  <img src="https://github.com/user-attachments/assets/22b0c4c7-f80f-4570-ae9d-7051c99d9ebc" height="200" />

### shared\_prefs\_service.dart

* Kullanıcı bilgilerini SharedPreferences ile lokal olarak cihazda saklar.

### giris\_servisi.dart

* Google, GitHub ve e-posta ile giriş ve kayıt işlemlerini yönetir.
* Firebase Authentication ile entegre çalışır ve kullanıcı kimlik doğrulamasını sağlar.
<img src="https://github.com/user-attachments/assets/83f9a307-eb6e-4801-9ec5-4953b3291b19"  height="200"/>




---
## 🎨 themes

### Themes.dart
- Uygulamanın renk temalarını (Light ve Dark Mode) tanımlar.
- lightTheme: Beyaz arka plan, siyah yazı ile klasik açık mod tasarımı sunar.
- darkTheme: Koyu gri arka plan, beyaz yazı ile gece kullanımı için uygundur.
- ThemeData yapısıyla brightness, scaffoldBackgroundColor, canvasColor ve textTheme gibi özellikler özelleştirilmiştir.
- ThemeProvider sınıfı tarafından kullanılarak kullanıcı tercihine göre dinamik tema değişimi sağlanır.

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

### ThemeNotifier.dart
- Uygulamanın tema yönetimini (Light/Dark Mode) sağlar.
- Kullanıcının seçtiği tema tercihini SharedPreferences kullanarak cihazda saklar.
- Uygulama açıldığında önceden seçilen tema otomatik olarak uygulanır.
- ChangeNotifier yapısıyla notifyListeners() kullanılarak tema değişimi tüm arayüzde anında yansıtılır.
- Themes.dart dosyasındaki lightTheme ve darkTheme verileriyle çalışır.
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
🔹 **Themes** klasörü, uygulamanın genel tema ayarlarını barındırır. İçinde Themes.dart dosyası bulunur ve light/dark mod renklerini tanımlar.
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
- **GirisSayfasi (GirisSayfasi.dart)** ve **KayitSayfasi** kod ve tasarım geliştirilmesi.
- **HomePage (Anasayfa.dart)** yazımı ve tasarım geliştirilmesi.
- **KonuTakipPage (KonuTakip.dart)** tasarımı ve geliştirilmesi
- **base_page** widgetinin yazımı ve geliştirilmesi
- **Dark Mode Theme(Theme.dart)** yazımı ve geliştirmesi
- **ThemeNotifier.dart**tasarımı ve geliştirmesi, shared preferences ile modu kaydetme
- **Profil Ekranı** tasarımı
- **Bize Ulaşın (BizeUlasın.dart)** Bize ulaşın sayfanın geliştirmesi


---






