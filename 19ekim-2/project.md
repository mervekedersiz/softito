#Fitness su takip uygulaması
Bu doküman flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılım geliştiriciler için  bağlayıcı bir kılavuzdur. Projede üretilen bir kod satırı burdaki kurallara UYMAK ZORUNDADIR.


# Fitness Su takip Uygulaması

## 1.Proje Özeti ve Teknolojiler
- **Uygulama adı:** Susadım (akıllı su egzersiz ve kalori takibi uygulaması)

- **Hedef Platformlar:** İos ve android öncelikli ardından web ve masaüstü platformları.
- **Flutter SDK:** 3.29.0

- **Dart SDK:** 3.0.0
- **Tasarım dili:** Material 3, Çift Tema Desteği (Karanlık & Aydınlık):
  - **Koyu Tema:** Gece spor salonu paleti (Dark obsidian & neon cyan / lime);
  - **Aydınlık Tema:** Ferah atletik spor salonu paleti (Clean crisp white, buz mavisi & canlı cyan/lime vurgular);
- **Tema Yönetimi:** Sayfayı yeniden yüklemeden dinamik reaktif geçiş (`ValueNotifier<ThemeMode>`).

---

## Mimari Yapı : Özellik bazlı
kodlar kesinlikle tek bir yerde toplanmayacaktır.Her modül kendi feature klasöründe kodlanacaktır.

lib/
core/
   extensiton'lar
      constans/app_colors.dart
      theme/app_theme.dart
features/
   water_traker/
      controller/
      models/
      view/
      widget/
   workout/
      controller/
      models/
      view/
      widget/
main.dart

####sadece uygulama başlatma ve tema bölümleri

## 3.Kırmızı Çizgiler (Kesinlikle Uyulması Gerekenler)
1 - **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları vb.) StatefulWidget kabul edilir.

2 - **UI ve Performans kuralları:**
Statik tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır
Büyük build metodları yasaktır 40 satırı geçen build metotları özel widgetlara yazılacaktır.

3 - **Yasaklı Paketler:**
Projeye onay almadan harici ağır paketler EKLENMEMELİDİR.
Dart'ın ve Flutter'ın yerel çekirdek apilerini kullanmak esastır.


## 4.Geliştime analiz ve test komutları
Ajan yaptığı herhangi bir kod değişikliklerinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik kod analizi(0 uyarı ve 0 hata şart):**
```bash
flutter analyze
'''

* ** Birim ve widget testleri:
```bash
flutter test
'''

* **Projeyi çalıştırma:
```bash
flutter run
'''


## 5 Ajannın çıktı ve yanıt verme standartları

**Açıklama:** Türkçe teknik terimlerin özünü bozmadan net ve doğrudan olacaktır.
**Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sonra basma; hedef satırları ve diff yapısını göster.
**Dosya yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
**Doğrulama:** Kod yazdıktan sonra kullanıcıyı "Şimdi flutter analiz ile kontrol edebilirsin" şeklinde doğrulama yönergeleri ver.
```

