# Kan Bağı — Flutter Kan Bağışı Uygulaması

## 1. Amaç ve bu belgenin kullanımı

Bu belge, projeyi geliştirecek yapay zekâ ajanı için ürün ve mimari sözleşmesidir. Önce bu dosyayı, ardından aynı dizindeki `skills.md` dosyasını oku; sonra çalışan Flutter uygulamasını geliştir. Uygulama adı **Kan Bağı**, Dart paket adı `kan_bagi` olsun. Arayüz Türkçe, kod tanımlayıcıları İngilizce olsun.

Amaç: Kullanıcının kan grubunu ve kan değerlerini takip etmesi, yakınındaki kan ihtiyaçlarını ve bağış noktalarını görmesi, kendisi veya bir hasta için bağış planlaması ve bağış geçmişini görsel olarak izlemesi. Ders sunumunun ana görseli, **hortumdan akan kanın bir kan torbasını doldurduğu etkileşimli animasyon** olacak.

İlk sürüm: İnternet, hesap açma, API anahtarı veya backend gerektirmeyen, örnek verilerle çalışan bir ders prototipi. Gerçek hastane entegrasyonu, gerçek randevu veya gerçek tıbbi değerlendirme yapılmış gibi gösterme. Demo verilerini ilgili ekranlarda kısa bir “Örnek veri” etiketiyle belirt.

## 2. Dersteki örneklerden alınan mimari

İncelenen kaynaklar: `19ekim1.zip`, `19ekim-2.zip`, `19ekim3.zip` içindeki proje belgeleri, Flutter dosya yapıları, controller örnekleri ve animasyon kodu.

| Ders örneğindeki yaklaşım | Bu projedeki karşılığı |
| --- | --- |
| `lib/core` ve `lib/features` | Aynı özellik bazlı mimari |
| İlk örnekte ChangeNotifier, sonraki örneklerde ValueNotifier | Sonraki örnekler esas alınarak ValueNotifier |
| Model, controller, view, widget ayrımı | `models`, `controllers`, `views`, `widgets` |
| Su bardağında CustomPainter ve dalga animasyonu | Kan torbası, hortum akışı ve sıvı dolumu |
| Reaktif açık/koyu tema | Kan bağışına uygun açık/koyu Material 3 teması |
| Su/egzersiz kartları | Bağış, ihtiyaç, kan değeri ve rozet kartları |

Eski belgelerdeki SDK sürümleri ile `pubspec.yaml` gereksinimleri aynı değil. Sürümleri körlemesine kopyalama. Geliştirmeye başlamadan kurulu `flutter --version` ve `dart --version` çıktısını kontrol et; yeni projenin SDK aralığını kurulu araçlarla uyumlu kur. Mevcut çalışan projeyi gereksiz yere yükseltme.

## 3. Teknoloji ve kapsam

- Flutter + Dart; Android/iOS öncelikli, Chrome üzerinde ders demosu destekli.
- Material 3; `ValueNotifier<StateModel>` + `ValueListenableBuilder`.
- `Navigator`, `NavigationBar`, `IndexedStack`; controller'ları constructor ile aktar.
- Grafikler ve kan animasyonu için Flutter `CustomPainter`, `Canvas`, `Path`, `AnimationController`.
- İlk sürümde Flutter SDK, `cupertino_icons`, `flutter_test`, `flutter_lints` yeterli. Firebase, BLoC, Riverpod, GetX, Provider, harita veya grafik paketi ekleme.
- Veriler tek bir bellek içi demo deposunda tutulur; yeniden başlatınca sıfırlanır. Ekranlarda ayrı kopyalar üretme.
- Kalıcı kayıt, canlı harita, GPS, push bildirimleri ve kimlik doğrulama ikinci fazdır. İlk sürümde çalışıyor gibi sahte başarı verme.

## 4. Kullanıcı akışı ve ekranlar

Alt menü: **Ana Sayfa / İhtiyaçlar / Bağış Noktaları / Geçmişim / Profilim**.

### 4.1 Ana Sayfa

Kullanıcı adı, kan grubu, geçmiş bağış sayısı, sıradaki demo randevu ve hızlı işlemler göster. Ana kartta kan torbası animasyonu olsun. “Bağış Planla”, “Ön Bilgi Formu”, “Kan Değerlerim” ve “Kan Grupları” bağlantıları çalışsın. Aylara göre bağış sayısı grafiği, yakın ihtiyaç özeti ve son kazanılan rozet görülsün. Günlük kan verme hedefi veya bağış serisi oluşturma.

### 4.2 Kan grupları

A+, A−, B+, B−, AB+, AB−, 0+, 0− kartları; ayrıca profilde “Bilmiyorum” seçeneği. Gösterimde `0`, veri modelinde `O` kullan ve dönüşümü tek yerde tanımla. Kan grubu ve Rh ayrı açıklanabilsin. Kan grubu seçimi profili ve ihtiyaç filtresini güncellesin. İlk sürümde aynı grup filtresi kullan; bunu klinik uyumluluk veya transfüzyon onayı diye adlandırma. Uyumluluk tablosu ileride eklenirse kan bileşenine göre kapsamı belirtilmiş, resmi kaynaklı bilgilendirme olarak ekle.

### 4.3 Kan Değerlerim

Hemoglobin (g/dL), hematokrit (%), ferritin (ng/mL) için ölçüm tarihi, birimi ve kaynağı olan örnek kayıtlar. Gösterge seçimi, tarih sıralı çizgi grafiği, kayıt ekleme ve silme çalışsın. Farklı birimleri aynı eksende birleştirme. Tek ölçümde nokta, kayıtsız durumda açıklama göster. Tarih ve sayısal alanları doğrula; virgüllü ondalık girişini destekle.

Referans aralığı yalnızca kaydın laboratuvar raporunda varsa gösterilsin. Renkle “bağış yapabilir/yapamaz” kararı çıkarma. Bu ekran kişisel kayıt ve görselleştirme içindir; sonuç yorumlama veya uygunluk kararı değildir.

### 4.4 Yakınımdaki kan ihtiyaçları

Kartlar: örnek talep kodu, maskelenmiş alıcı etiketi, kan grubu, bağış merkezi/hastane, ilçe, ihtiyaç miktarı, son tarih, talep durumu ve demo mesafe. Kan grubu, ilçe ve aciliyet filtreleri; yakınlık ve tarih sıralaması; detay ekranı; “Bu talep için bağış planla” aksiyonu.

Konum ilk sürümde seçilen demo konumdan gelir; “Örnek mesafe” yaz. Gerçek GPS izni isteme. Tüm isim ve kurumlar açıkça kurgusal olsun; gerçek acil ihtiyaç uydurma. Süresi dolmuş, karşılanmış veya kapatılmış talepler için yeni planlama engellensin. Kamuya açık hasta adresi, teşhis, telefon veya tam kimlik gösterme.

### 4.5 Bağış noktaları

Kurgusal merkez adı, adres, ilçe, çalışma saatleri, bağış türleri ve örnek müsait saatler. Arama, ilçe filtresi ve detay sayfası. İlk sürümde kullanışlı liste yeterli; harita zorunlu değil. Adres kopyalama çalışsın. Gerçek harita/rota entegrasyonu yoksa yanıltıcı “Yol tarifi açıldı” mesajı gösterme.

### 4.6 Bağış planlama: nereye, kimin adına?

Sıralı form:
1. Genel bağış / belirli hasta veya talep için bağış seçimi.
2. Talep seçimi ya da hasta/başvuru referans kodu; isteğe bağlı maskelenmiş alıcı etiketi.
3. Bağış merkezi seçimi.
4. Gelecek tarih ve uygun demo saat seçimi.
5. Ön bilgi formuna erişim, bilgilerin kontrolü ve demo planı kaydetme.

Talep kartından gelindiyse talep ve ilgili merkez bilgileri önceden dolsun. Genel bağışta hasta alanları zorunlu olmasın. “Birinin adına” seçimi kanın kesin olarak o kişiye ulaşacağı anlamına gelmez; formda bunu kısa ve açık belirt. Merkez veya tarih değişince eski saat seçimini temizle. Çift tıklamayla iki kayıt üretme. Kaydedilen plan ana sayfada ve geçmişte görünsün, iptal edilebilsin. Plan oluşturmak tamamlanmış bağış sayısını artırmasın.

### 4.7 Ön bilgi / kan verememe nedenleri formu

Bu ekran bir tıbbi onay motoru değildir. Yaş ve kilo bilgisi, son bağış tarihi, mevcut rahatsızlık/ateş, kullanılan ilaç, yakın zamanda işlem veya ameliyat, gebelik/emzirme gibi konularda örnek sorular göster. Soru seçenekleri: Evet / Hayır / Emin değilim; yanıtsızlık ayrıca tutulur. Kesin kabul/ret eşikleri veya bağış aralığı uydurma.

Form sonunda “Yanıtlar kaydedildi; bağış uygunluğu merkezde değerlendirilir” özeti ve kullanıcı yanıtları göster. Evet veya Emin değilim işaretlenen ilgili alanları “Merkezle görüşülecek başlıklar” olarak listele; kalıcı/geçici ret tanısı verme. Bilgilendirme kartlarında kan verememe nedenlerinin değerlendirme gerektirebildiğini anlat; kesin süre/ölçüt eklenecekse güncel resmi kan hizmeti kaynağı ve inceleme tarihi zorunlu olsun. İlk demo gerçek sağlık bilgisi istemek yerine örnek profil üzerinden denenebilsin.

### 4.8 Geçmişim ve Hayat Zinciri

Planlanan, iptal edilen ve tamamlanan demo kayıtlarını ayır. Tamamlanan kaydın ayrıntısında aşama çizgisi: Bağış alındı → Kontrol süreci → Dağıtıma hazır → İlgili merkeze iletildi. Bunlar demo senaryosunun durumlarıdır. “Bir hastada kullanıldı” bildirimi gerçek doğrulanmış veri olmadan gösterilmez.

Bağış geçmişinden aylık sütun grafiği ve toplam sayılar hesaplanır. Manuel/demo tamamlamanın gerçek kurum onayı olmadığı görünür olsun. Simülasyonu yeniden oynatmak bağış geçmişine tekrar kayıt eklemesin.

### 4.9 Profilim ve Kan Kardeşliği

Ad/rumuz, kan grubu, ilçe, son bağış kaydı, tema seçimi ve rozetler. İlk Adım, Farkındalık Elçisi, Gönüllü Destekçi gibi rozetler kullan. Tamamlanmış ilk demo bağış, bilgilendirme içeriğini okuma veya kampanyaya katılım gibi koşullar açık olsun. Aynı rozet tekrar verilmesin. Sık kan verme, fazla hacim veya tıbbi aralıkları kısaltma üzerine puan verme. Paylaşım ilk sürümde kişisel sağlık verisi içermeyen metni panoya kopyalasın.

## 5. Kan gerçekten akıyormuş gibi görünen animasyon

Bu özellik zorunludur; statik PNG, sadece dönen ikon veya kırmızı progress bar yeterli değildir.

- Stilize şeffaf kan torbası, üst bağlantı ve kıvrımlı hortum çiz.
- Hortum boyunca yönü belli kırmızı akış segmentleri/damlalar hareket etsin.
- Torbanın sıvı seviyesi alttan yukarı yükselsin; yüzeyde küçük dalga, kırmızı ton geçişi ve hafif yansıma olsun.
- `AnimationController`, `CustomPainter`, `Path`, `clipPath`, gerekirse `PathMetric` kullan. Gerçekçi sıvı hissi hedefle; fiziksel sıvı simülasyonu gerekmez.
- “Simülasyonu Başlat / Duraklat / Devam Et / Sıfırla” kontrolleri ve yüzde değeri olsun.
- Durumlar: idle → running ↔ paused → completed; reset ile idle. İlerleme 0–1 aralığında kalır.
- Yaklaşık 12 saniyelik görsel demo; bu süre gerçek bağış süresi değildir. Ölçüm cihazı bağlıymış gibi mL üretme. İlerleme yalnızca animasyonu ifade eder.
- Tamamlandığında akış dursun. Sıfırlama yalnızca simülasyonu etkilesin.
- Sekme görünmezken, uygulama arka plandayken veya azaltılmış hareket tercihinde animasyonu durdur; statik yüzde görünümü sun. Yeniden görünmede otomatik ilerleme yerine kontrollü devam et.
- Dar ekran ve tema değişiminde çizim taşmasın. Animasyon her karede tüm sayfayı yeniden kurmasın; `RepaintBoundary` ve çizime sınırlı güncelleme kullan.
- Her iki temada etiketler okunur olsun; ekran okuyucuya ilerleme anlamını ver, her karede anons yapma.

## 6. Klasör yapısı

Aşağıdaki yapı hedef yapıdır. Boş, kullanılmayan dosyaları üretme; ilgili modülü geliştirirken ekle.

```text
kan_bagi/
  project.md
  skills.md
  pubspec.yaml
  analysis_options.yaml
  assets/images/
  lib/
    main.dart
    app.dart
    core/
      constants/app_colors.dart
      constants/app_strings.dart
      extensions/theme_extensions.dart
      theme/app_theme.dart
      theme/theme_controller.dart
      models/blood_group.dart
      models/donor_profile.dart
      models/blood_request.dart
      models/donation_center.dart
      models/donation_record.dart
      models/blood_measurement.dart
      models/eligibility_answer.dart
      models/donor_badge.dart
      data/demo_seed.dart
      data/demo_store.dart
      widgets/empty_state.dart
      widgets/error_state.dart
      widgets/blood_group_chip.dart
      widgets/demo_label.dart
    features/
      navigation/
        controllers/navigation_controller.dart
        views/main_navigation_shell.dart
      dashboard/
        controllers/dashboard_controller.dart
        models/dashboard_state.dart
        views/dashboard_view.dart
        widgets/donation_summary_card.dart
      blood_animation/
        controllers/blood_animation_controller.dart
        models/blood_animation_state.dart
        views/blood_animation_view.dart
        widgets/animated_blood_bag.dart
        widgets/blood_bag_painter.dart
        widgets/blood_flow_painter.dart
      blood_groups/
        controllers/blood_groups_controller.dart
        models/blood_groups_state.dart
        views/blood_groups_view.dart
        widgets/blood_group_card.dart
      blood_values/
        controllers/blood_values_controller.dart
        models/blood_values_state.dart
        views/blood_values_view.dart
        widgets/measurement_form.dart
        widgets/blood_value_chart.dart
      blood_requests/
        controllers/blood_requests_controller.dart
        models/blood_requests_state.dart
        views/blood_requests_view.dart
        views/blood_request_detail_view.dart
        widgets/blood_request_card.dart
      donation_centers/
        controllers/donation_centers_controller.dart
        models/donation_centers_state.dart
        views/donation_centers_view.dart
        views/donation_center_detail_view.dart
        widgets/donation_center_card.dart
      donation_booking/
        controllers/donation_booking_controller.dart
        models/donation_booking_state.dart
        views/donation_booking_view.dart
        widgets/recipient_form.dart
        widgets/appointment_summary.dart
      eligibility/
        controllers/eligibility_controller.dart
        models/eligibility_state.dart
        views/eligibility_view.dart
        widgets/eligibility_question_card.dart
        widgets/eligibility_summary.dart
      donation_history/
        controllers/donation_history_controller.dart
        models/donation_history_state.dart
        views/donation_history_view.dart
        widgets/donation_bar_chart.dart
        widgets/life_chain_timeline.dart
      profile/
        controllers/profile_controller.dart
        models/profile_state.dart
        views/profile_view.dart
        widgets/donor_badge_card.dart
  test/
    controllers/
    models/
    widgets/
```

`core/models` yalnızca birden çok özellik tarafından kullanılan varlıkları içerir. Feature içindeki `models` ise o ekranın filtre, seçim, yüklenme/hata ve gösterim durumunu içerir. Bu ayrım, bir feature'ın diğerinin özel dosyalarına bağımlı olmasını önler. `main.dart` yalnızca başlatır; `app.dart` tema ve bağımlılıkların ömrünü yönetir. Navigasyon ayrı feature'dadır.

## 7. Veri sözleşmesi ve tutarlılık

| Model | Temel alanlar |
| --- | --- |
| DonorProfile | id, displayName, bloodGroup (bilinmiyor olabilir), district |
| BloodRequest | id, recipientAlias, bloodGroup, centerId, district, requiredUnits, expiresAt, urgency, status, demoDistanceKm |
| DonationCenter | id, name, district, address, workingHours, availableSlots |
| DonationRecord | id, centerId, requestId?, recipientReference?, scheduledAt, completedAt?, status, source, trackingEvents |
| BloodMeasurement | id, type, value, unit, measuredAt, source, referenceMin?, referenceMax? |
| EligibilityAnswer | questionId, answer (yes/no/unsure/unanswered) |
| DonorBadge | id, title, description, earnedAt? |

Kimlikler değişmez; ilişkiler kimlik üzerinden kurulur. Tarihler `DateTime`, JSON'da ISO 8601; tipler enum; koleksiyonlar dışarıya değiştirilemez görünümle sunulur. Sayısal birim ve gösterge türü eşleşmesi doğrulanır. Kullanıcının hatalı ölçümünü sessizce sınır değere yuvarlama; alan hatası göster.

`DemoStore` ortak varlıkların tek kaynağıdır. Controller'lar ilgili veriyi dinler, filtreler ve store üzerinden değişiklik yapar. UI doğrudan store'u değiştirmez. Store'a eklenen randevu, geçmiş ve dashboard'a aynı kimlikle yansır. Store'u yalnızca sahibi dispose eder; controller kendi dinleyicisini kaldırır.

Örnek veri: 1 demo profil, 6 kurgusal merkez, farklı gruplarda 10 ihtiyaç (aktif, süresi dolmuş ve karşılanmış dahil), 6 aya yayılmış 4 tamamlanmış demo bağış, 1 gelecek randevu, her kan göstergesi için 4 ölçüm ve 3 rozet. Bunlar klinik öneri veya önerilen bağış sıklığı değildir. Zamanlı örnekler sabit test saati/enjekte edilen saatten üretilebilir olmalı.

## 8. Görsel tasarım

Açık tema: kırık beyaz zemin, beyaz kartlar, bordo/kırmızı ana vurgu. Koyu tema: koyu füme zemin, koyu kartlar, okunaklı açık kırmızı vurgular. Renkler `app_colors.dart`, metin stilleri `app_theme.dart`, özel anlamlı renkler tema uzantısında tutulur. Tasarım kan bağışı odaklı olsun; spor/su uygulamasının metin ve simgeleri kalmasın.

Kartlarda 16–20 px iç boşluk, tutarlı köşeler, belirgin başlıklar, kan grubu çipleri kullan. Grafiklerde eksen, tarih, birim, seçilen noktanın değeri ve erişilebilir metinsel özet bulunsun. Renk tek bilgi taşıyıcısı olmasın. 360 px telefon genişliğinde ve büyütülmüş metinde taşma olmamalı; geniş ekranda içerik kontrollü iki sütuna geçebilsin.

## 9. İkinci faz fikirleri

İlk sürüm bitmeden bunları kurma:
- Konum izni ve gerçek veri kaynağıyla yakın ihtiyaç bildirimi; izin reddinde ilçe seçimi.
- Kurum doğrulamasıyla gerçek Hayat Zinciri olayları ve talep moderasyonu.
- Üniversite/kurum takımları; farkındalık ve katılım odaklı topluluk ligi.
- Gizlilik tercihlerine bağlı paylaşım ve kampanya davetleri.
- Yerel esnaf teşekkür kuponu: kurum iş birliği ve uygunluk değerlendirmesi sonrası; ilk sürümde ekonomik teşvik sistemi kurma.
- Gerçek hesap, güvenli backend, kontrollü sağlık verisi saklama ve kalıcı veri.

## 10. Uygulama sırası ve tamamlanma ölçütü

1. Çalışan proje, tema, store, ortak modeller ve navigasyon.
2. Ana sayfa ve kontrol edilebilir kan akış animasyonu.
3. İhtiyaçlar → merkez → bağış planlama → geçmiş uçtan uca akışı.
4. Ön bilgi formu, kan grupları, kan değerleri ve grafikler.
5. Rozetler, Hayat Zinciri, boş/hatalı durumlar ve erişilebilirlik.
6. Analiz, kritik testler ve cihaz/Chrome demosu.

Tamamlanmış sayılması için bütün ana menüler ve belirtilen aksiyonlar çalışmalı; planlama gerçek bağış sayısını değiştirmemeli; animasyon duraklatılabilmeli; filtreler ve grafikler gerçek demo state'ten türemeli; tema değişiminde veriler korunmalı; aynı kayıt/rozet iki kez oluşmamalı. “Yakında” kartlarıyla zorunlu ekranları geçiştirme.

Doğrulama: `dart format lib test`, `flutter analyze`, `flutter test`, ardından mevcut cihazda `flutter run` veya Chrome mevcutsa `flutter run -d chrome`. Çalıştırılmayan komutu başarılı diye raporlama.
