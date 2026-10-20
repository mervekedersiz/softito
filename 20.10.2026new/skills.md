---
name: kan-bagi-flutter-feature-scaffold
description: Kan Bağı Flutter ders projesinde özellik bazlı model-controller-view-widget ayrımı, ValueNotifier durumu, kan akış animasyonu, formlar ve grafikler için geliştirme rehberi.
---

# Kan Bağı — Yapay Zekâ Geliştirme Talimatları

## 1. Kullanım ve öncelik

Bu dosya, `project.md` ile birlikte geliştirme ajanına verilecek proje içi talimat belgesidir. Önce `project.md` oku. Ürün kapsamı ve ekranlar orada, uygulama yöntemi buradadır. Kullanıcının son açık isteği önceliklidir. Bu dosyayı tek başına okuyarak kapsamı tahmin etme.

Dosyaları Flutter proje köküne koy. Ajanın `skills.md` dosyasını otomatik okuyacağını varsayma; başlangıç mesajında iki dosyanın da okunmasını açıkça iste. Kullanılan IDE ayrıca standart SKILL.md yolu istiyorsa kendi belgelerindeki yolu kullan; burada otomatik keşif garantisi yoktur. Bu teslim iki Markdown belgesidir, kurulu bir IDE eklentisi değildir.

## 2. Başlamadan önce

1. Çalışma dizininde `pubspec.yaml` var mı kontrol et. Mevcut Flutter projesini silme veya üzerine yeniden oluşturma.
2. `flutter --version`, `dart --version`, `flutter devices` ile ortamı öğren. SDK uyuşmazlığını gerçek çıktı üzerinden çöz; örneklerde yazılı sürümü zorla kurma.
3. Yeni, boş proje gerekiyorsa `flutter create --project-name kan_bagi .` kullan. Var olan uygulamadaysan paket adını değiştirmeden önce importları incele.
4. `project.md` içindeki sırayla uygulamaya başla. Sadece plan veya boş ekran iskeleti sunup bırakma; ilk önce derlenebilir bir dikey akış kur.
5. Dersteki düzeni koru: `core`, `features`, `controllers`, `models`, `views`, `widgets`. Tekil/çoğul klasör adlarını karıştırma.

## 3. Her feature için uygulama yöntemi

- Ekranın veri modelini, state'ini, aksiyonlarını ve boş/hata durumunu tanımla.
- Paylaşılan varlık `core/models`; ekrana özel state ilgili `features/<name>/models` altına gider.
- Model alanları `final`; uygun kurucular `const`; veri modellerinde `copyWith`, `fromJson`, `toJson` bulunur.
- Listeyi yerinde değiştirme. Yeni liste ve yeni state üret. Dışarıya değiştirilebilir store listesi sızdırma.
- `copyWith` içindeki nullable alanları temizlemek için açık bir yöntem kullan; `newValue ?? oldValue` ile alanın null yapılmasını imkânsızlaştırma.
- JSON dönüşümünde sayıları `num` üzerinden oku, tarihleri kontrollü parse et, bilinmeyen enum değerlerini yönet. Kan grubunu tahmin etme; eksikse unknown kullan.
- Controller `ValueNotifier<FeatureState>` taşır. Arayüz sadece `ValueListenable<FeatureState>` okuyabilir; değişiklikler controller metotlarından geçer.
- Controller içine `BuildContext`, `Navigator`, `ScaffoldMessenger`, widget veya renk ekleme. UI yönlendirmeyi ve mesajı sonuç üzerinden yapar.
- Controller Flutter foundation kullanabilir; bunun UI bağımsızlığı anlamına geldiğini, Flutter'dan tamamen bağımsız saf Dart olmadığı gerçeğini koru.
- View mümkün olduğunca `StatelessWidget`; controller constructor ile gelir. Form ve animasyon ömrünü yöneten küçük StatefulWidget'lar uygundur.
- `ValueListenableBuilder` yalnızca değişen bölümü sarsın. 40 satırı aşan `build` metotlarını anlamlı alt widget sınıflarına ayır.
- Sabit widget'larda uygun yerde `const` kullan. Renkleri ve tipografiyi temadan al.

## 4. State akışı ve sahiplik

Akış: kullanıcı aksiyonu → controller metodu → doğrulama → DemoStore güncellemesi → yeni feature state → ValueListenableBuilder → UI.

`app.dart` tek `DemoStore` ve tema controller'ının sahibidir. Navigasyon kabuğu sekme controller'larını bir kere oluşturur, bağımlılıkları aktarır ve kapanırken temizler. Detay/form sayfasına özel controller o sayfanın yaşam döngüsünde oluşturulur. `build()` içinde controller oluşturma. Bir alt ekran kendisine verilen ortak controller'ı dispose etmez.

Controller'da notifier, store listener ve varsa timer için cleanup uygula. Animasyon widget'ı ticker ve AnimationController'ın sahibidir. Business controller animasyonun running/paused/completed durumunu taşır; her karede store'a yazmaz. Async işlemlerden dönerken yaşam döngüsünü kontrol et, kapatılmış notifier'a yazma.

Tema ve sekme değişiminde form/filtre durumunu koru. `IndexedStack` görünmeyen ekranların ticker'ını kendiliğinden durdurmuş varsayılmamalı; görünürlük ve `TickerMode` açıkça yönetilsin.

## 5. Form geliştirme kuralları

- `Form`, `GlobalKey<FormState>`, alan validator'ları ve anlaşılır Türkçe hata mesajları kullan.
- `TextEditingController` ve `FocusNode` oluşturan widget bunları dispose eder.
- Kaydetmeden önce gerekli alanları kontrol et; sadece Snackbar gösterip veriyi kaydetmeden başarılı sayma.
- Tarih geçmişte olamaz; merkez/tarih değişirse seçilen saat temizlenir; aynı slot/aktif plan için mükerrer kayıt kontrol edilir.
- Kaydetme sürerken butonu kapat; controller seviyesinde de çift gönderimi engelle.
- Genel bağışta hasta kodu istenmez. Belirli talepte seçili talep kimliği veya geçerli referans gerekir.
- Ön bilgi formunda yanıtsız alanı Hayır kabul etme; sonucu tıbbi uygunluk onayına dönüştürme.
- Ondalık sayı girişinde Türkçe virgülü normalize et. Boş, negatif, sonlu olmayan ve yanlış birimli ölçümleri reddet. Tıbbi eşik uydurma.
- Demo sağlık verisini loglara, paylaşım metnine veya genel ihtiyaç kartlarına taşıma.

## 6. Kan akış animasyonunu uygulama tarifi

1. Torba dış hatları, hortum yolu ve iç dolum alanını boyuta göre oranlı çiz; sabit ekran koordinatlarına bağlı kalma.
2. Torbanın iç alanını `Path` ile oluştur; sıvı çizimini `canvas.save`, `clipPath`, `restore` arasında tut.
3. Doluluk için 0–1 ilerleme kullan. Sıfırda boş, birde tam dolu görünüm üret; dalga genliğini kenarlarda azalt.
4. Hortumun yolu boyunca ilerleyen segmentleri animasyon fazıyla konumlandır. Akış torba girişine doğru olsun.
5. Yüzeyde düşük genlikli sinüs dalgası ve tema uyumlu kırmızı gradient kullan. Ağır animasyon paketine ihtiyaç yoktur.
6. Başlat/duraklat/devam/sıfırla aksiyonlarını state'e bağla. Duraklatınca hem dolum hem akış fazı durur; devam aynı seviyeden sürer.
7. Tamamlanma olayını bir kez üret. Animasyon tamamlanması gerçek veya demo bağış kaydını kendiliğinden oluşturmaz.
8. State ilerlemesi ile painter'ın çizdiği ilerleme aynı kaynaktan gelsin; bağımsız iki timer kullanma.
9. Yeniden boyutlandırmada ve tema değişiminde doğru çiz. `shouldRepaint` renk, boyutsal parametreler ve ilerlemeyi dikkate alsın; gerekiyorsa painter'ın repaint dinleyicisini kullan.
10. Arka plan, görünmez sekme ve azaltılmış hareket durumunda durdur. Semantics ile “Bağış simülasyonu, yüzde …” bilgisini kontrollü güncelle.

## 7. Grafik uygulama tarifi

- `CustomPainter` ile aylık bağış sütun grafiği ve seçili kan göstergesi için çizgi grafiği oluştur.
- Veriyi controller'da tarih sırasına koy; painter iş kuralı hesaplamasın.
- Bağış grafiği yalnızca completed kayıtları sayar; canceled ve planned kayıtları saymaz.
- Kan değeri grafiğinde yalnızca aynı gösterge ve birim birlikte görünür. Eksen aralığı sıfır veya bütün değerler eşitse bölme hatasını önle.
- Veri yok, tek nokta ve çok nokta durumlarını ayrı ele al. Eksen başlığı, tarih ve birim göster.
- Noktaya/sütuna dokununca değer açıklaması; altında erişilebilir metinsel özet veya küçük liste olsun.
- Tıbbi normal/anormal sınıflandırması veya kaynaklanmamış referans çizgisi ekleme.

## 8. Demo verisi ve iş kuralları

- Kurgusal kurumları “Örnek Bağış Merkezi — Bahçelievler” gibi adlandır; gerçek kurumun canlı ihtiyacı varmış izlenimi verme.
- Demo mesafeleri sabit örnek veri olabilir; GPS'ten hesaplanmış gibi sunma.
- İhtiyaç filtresi aynı kan grubu ve seçilen bölgeyi arar; bu filtre transfüzyon eşleştirme algoritması değildir.
- Süresi dolmuş talep yeni randevuya bağlanmaz. Talebin kapanması mevcut planı sessizce silmez; kullanıcıya durumunu göster.
- Randevu oluşturma, simülasyonu oynatma ve gerçek doğrulanmış bağış üç farklı olaydır.
- Sunum için “Demo bağışı tamamla” aksiyonu geçmişteki plan detayında bulunabilir; belirgin demo etiketiyle tek seferlik kayıt günceller. Sadece planlanmış, iptal edilmemiş kayıtta çalışır.
- Demo tamamlama geçmişi, özetleri ve uygun rozeti tek kaynak üzerinden günceller; gerçekte hasta veya stok verisi değiştirmez.
- Rozet kazanımını kimlik/koşul üzerinden idempotent yap; sık bağış veya ml yarışına dayandırma.
- Kan bağışı yaş, kilo, süre, tahlil eşiği gibi gerçek kurallar gerekirse önce güncel resmi kaynağı doğrula ve kapsam/tarih kaydet. Doğrulama yoksa kesin karar üretme.

## 9. Test ve doğrulama

Öncelik anlamlı davranış testleridir:

| Test | Beklenen |
| --- | --- |
| Plan kaydı | Aynı kayıt ana sayfa ve geçmişte görünür; tamamlanan sayısı artmaz |
| Çift kaydetme | Tek kayıt oluşur |
| İptal/kapalı talep | Geçersiz durum geçişi reddedilir |
| Ön bilgi formu | Yanıtsız soru fark edilir; otomatik bağış onayı çıkmaz |
| Kan değerleri | Virgüllü sayı parse edilir; yanlış birim/negatif değer reddedilir |
| Grafik | Boş, tek noktalı ve eşit değerli veri hata üretmez |
| Rozet | Aynı koşul tekrar çalışınca ikinci rozet oluşmaz |
| Animasyon | Başlat, duraklat, devam, sıfırla ve tamamlanma doğru çalışır |
| Görünürlük | Gizli sekme/arka planda ilerleme durur |
| Tema | Geçiş veriyi ve seçili sekmeyi korur |

Animasyon widget testinde sonsuz döngü varken `pumpAndSettle()` kullanıp testin takılmasına yol açma; kontrollü `pump(Duration)` kullan. Ortak store dinleyicilerinin temizlenmesini ve dispose sonrası güncelleme yapılmamasını kontrol et.

Çalıştır:

```bash
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter devices
```

Kullanılabilir hedefte `flutter run`; Chrome listeleniyorsa `flutter run -d chrome`. 360 px ekran, açık/koyu tema, büyük metin, boş filtre sonucu, eksik form ve animasyon kontrollerini görsel olarak kontrol et. SDK/cihaz yoksa bunu açıkça raporla; başarı iddia etme. Proje analizinde sıfır hata/uyarı hedefle.

## 10. Ajandan beklenen teslim

Çalışan dosyaları oluştur; tüm kodu `main.dart` içine yazma. Sahte buton, sadece tasarım görseli veya TODO ile zorunlu özellik bırakma. Harici paket gerekiyorsa önce Flutter çekirdeğiyle çözümü dene; mevcut kapsam için ağır bağımlılık ekleme.

Son yanıt Türkçe ve kısa olsun: hangi ekranlar/akışlar çalışıyor, hangi doğrulamalar gerçekten yapıldı, çalıştırma komutu ve kalan somut engel. Gerçek backend, hastane bağlantısı, canlı konum veya kalıcı kayıt yoksa bunları tamamlanmış özellik gibi sunma.

## 11. Başlangıç mesajı

Aşağıdaki mesaj bu iki dosyayla birlikte geliştirme yapay zekâsına verilebilir:

> Proje kökündeki project.md ve skills.md dosyalarını tamamen oku. Kan Bağı uygulamasını bu belgelerdeki ders mimarisine göre Flutter ile geliştir. Özellik bazlı controllers/models/views/widgets ayrımını ve ValueNotifier kullanımını koru. Önce ortamı kontrol et, sonra çalışan proje, çift tema, demo veri deposu, ana navigasyon ve hortumdan akarak torbayı dolduran kan animasyonunu kur. Ardından ihtiyaçlar, bağış noktaları, kimin adına bağış yapılacağı formu, randevu, ön bilgi formu, kan grupları, kan değerleri grafikleri, geçmiş ve rozetleri birbirine bağla. İlk sürüm internet veya backend gerektirmeden çalışsın. Yalnızca plan yazma; dosyaları oluştur, uygulamayı geliştir ve analiz/test sonuçlarını dürüstçe bildir. Mevcut dosyaları incelemeden silme veya yeniden oluşturma.
