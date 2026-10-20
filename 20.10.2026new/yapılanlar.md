# Kan Bağı — Yapılanlar ve İlerleme Raporu (yapılanlar.md)

Bu belge, `project.md` ve `skills.md` sözleşmelerine göre geliştirilen **Kan Bağı** Flutter ders projesindeki tüm adımları, teknik kararları, tamamlanan özellikleri ve doğrulama süreçlerini adım adım kayıt altına alır.

---

## 1. Ortam ve Başlangıç Kontrolü
- [x] **Ortam İncelemesi**:
  - `flutter --version`: Flutter 3.35.5 (Channel stable)
  - `dart --version`: Dart 3.9.2
  - `flutter devices`: Windows Desktop, Google Chrome, Microsoft Edge
- [x] **Proje İskeleti Oluşturma**:
  - Proje kökünde `flutter create --project-name kan_bagi .` komutu çalıştırıldı.
  - Bağımlılıklar Flutter çekirdeği + `cupertino_icons`, `flutter_test`, `flutter_lints` ile sınırlandırıldı (ekstra ağır paketler kullanılmadı).

---

## 2. Mimari ve Temel Katman (Core)
- [x] **Core Sabitleri ve Yardımcıları**:
  - `lib/core/constants/app_colors.dart`: Bordo/kırmızı vurgular, açık/koyu mod nötr tonları oluşturuldu.
  - `lib/core/constants/app_strings.dart`: Türkçe UI metinleri ve etiketler tanımlandı.
  - `lib/core/extensions/theme_extensions.dart`: `KanBagiColors` ThemeExtension ile semantik renkler entegre edildi.
  - `lib/core/theme/app_theme.dart`: Material 3 uyumlu Açık ve Koyu tema tanımlandı.
  - `lib/core/theme/theme_controller.dart`: `ValueNotifier<ThemeMode>` ile dinamik tema yöneticisi oluşturuldu.
- [x] **Core Veri Modelleri**:
  - `BloodGroup` (0/O dönüşümü, Rh faktörü, Türkçe etiketler ve güvenli JSON parse)
  - `DonorProfile` (id, displayName, bloodGroup, district)
  - `BloodRequest` (urgency, status, demoDistanceKm, son tarih kontrolü)
  - `DonationCenter` (6 merkez, çalışma saatleri, randevu saat dilimleri)
  - `DonationRecord` (trackingEvents, status, source, nullable temizleme destekli copyWith)
  - `BloodMeasurement` (hemoglobin, hematokrit, ferritin tipleri, referans aralığı)
  - `EligibilityAnswer` (evet, hayır, emin değilim, yanıtsız)
  - `DonorBadge` (id, title, description, criteria, earnedAt)
- [x] **Core Demo Deposu ve Tohum Verileri (DemoStore & DemoSeed)**:
  - Tek bellek içi kaynak (Single Source of Truth), immutable erişim ve idempotent rozet/güncelleme mekanizması kuruldu.
  - 1 profil, 6 kurgusal merkez, 10 ihtiyaç talebi, 4 tamamlanan + 1 planlanan bağış, 12 kan ölçümü ve 3 rozet eklendi.
- [x] **Core Ortak Bileşenler**:
  - `empty_state.dart`, `error_state.dart`, `blood_group_chip.dart`, `demo_label.dart` hazırlandı.

---

## 3. Özellikler (Features)
- [x] **Navigasyon Kabuğu (`navigation`)**:
  - `NavigationBar`, `IndexedStack` ve `TickerMode` ile 5 sekme: Ana Sayfa, İhtiyaçlar, Bağış Noktaları, Geçmişim, Profilim.
  - Sayfa geçişlerinde controller'lar ve alt ekran yaşam döngüleri güvenle bağlandı.
- [x] **Ana Sayfa (`dashboard`)**:
  - Kullanıcı karşılama ve bölge özeti, kan grubu çipi, sıradaki demo randevu kartı, hızlı işlem butonları, son 6 aylık bağış özeti, yakın acil ihtiyaçlar ve son kazanılan rozet vitrini.
- [x] **Kan Akış Animasyonu (`blood_animation`)**:
  - `CustomPainter`, `Path`, `clipPath` ve `computeMetrics` kullanılarak kıvrımlı hortum boyunca yönlü akan kırmızı kan damlacıkları, şeffaf kan torbası, medikal mezür çizgileri, sinüs dalgası ve yükselen sıvı seviyesi canlandırıldı.
  - Başlat / Duraklat / Devam Et / Sıfırla kontrolleri ve yüzde etiketi eklendi.
  - Uygulama arka plana geçtiğinde veya sekme değiştiğinde TickerMode ile otomatik duraklatma sağlandı.
- [x] **Kan Grupları Ekranı (`blood_groups`)**:
  - 8 kan grubu kartı + "Bilmiyorum" seçeneği, Rh faktörü açıklamaları, transfüzyon uyarısı ve profille reaktif filtre güncellemesi sağlandı.
- [x] **Kan Değerlerim (`blood_values`)**:
  - Hemoglobin, Hematokrit, Ferritin göstergeleri arasında geçiş.
  - `CustomPainter` ile tarih sıralı reaktif çizgi grafiği, nokta seçimi ve detay paneli.
  - Türkçe virgüllü ondalık sayı desteği, negatif/geçersiz giriş doğrulaması olan ölçüm ekleme formu ve silme işlemi.
- [x] **Yakınımdaki Kan İhtiyaçları (`blood_requests`)**:
  - Kurgusal 10 talep, kan grubu / ilçe / aciliyet filtreleri, mesafeye ve tarihe göre sıralama.
  - Talep detay ekranı (`blood_request_detail_view.dart`) ve süresi geçmiş taleplerde bağış planlamayı kilitleme mantığı.
- [x] **Bağış Noktaları (`donation_centers`)**:
  - Kurgusal 6 merkez, anlık arama (arama çubuğu) ve ilçe filtre çipleri.
  - Pano adres kopyalama özelliği, çalışma saatleri, uygun slotlar ve merkez detay ekranı.
- [x] **Bağış Planlama (`donation_booking`)**:
  - Sıralı randevu formu (Genel bağış / Belirli talep / Hasta adına seçimleri).
  - Şeffaflık bilgilendirmesi (kanın doğrudan kişiye verilmeyip ulusal havuzdan test edilerek yönlendirildiği uyarısı).
  - Gelecek tarih ve müsait saat seçimi, merkez/tarih değiştiğinde eski saati temizleme.
  - Çift tıklama ve mükerrer randevu engelleme kilidi; randevu oluşturmanın tamamlanan bağış sayısını artırmaması kuralı.
- [x] **Ön Bilgi Formu (`eligibility`)**:
  - Yaş, kilo, bağış aralığı, akut hastalık, ilaç, cerrahi işlem, dövme/piercing ve seyahat soruları.
  - Evet / Hayır / Emin Değilim seçenekleri; form sonunda "Merkezde Doktorla Görüşülecek Başlıklar" özeti.
- [x] **Geçmişim ve Hayat Zinciri (`donation_history`)**:
  - Planlanan, iptal edilen ve tamamlanan bağışların listesi ve durum filtreleri.
  - `CustomPainter` ile son 6 ayın tamamlanan bağışlarını gösteren aylık sütun grafiği.
  - Aşama çizgisi (`LifeChainTimeline`): Bağış alındı → Kontrol süreci → Dağıtıma hazır → İlgili merkeze iletildi.
  - Demo bağışı tamamlama aksiyonu (tek kaynak üzerinden store ve rozet günceller).
- [x] **Profilim ve Kan Kardeşliği (`profile`)**:
  - Bağışçı profil bilgileri düzenleme, dinamik açık/koyu tema seçimi.
  - Kazanılan ve kilitli rozet kartları (İlk Adım, Farkındalık Elçisi, Gönüllü Destekçi).
  - Kişisel sağlık verisi içermeyen farkındalık metnini panoya kopyalama aksiyonu.

---

## 4. Testler ve Doğrulama
- [x] `dart format lib test`: 72 dosya başarıyla formatlandı.
- [x] `flutter analyze`: **0 hata, 0 uyarı, 0 bilgi** (`No issues found!`).
- [x] `flutter test`: **10/10 birim ve widget testi başarıyla geçti** (`All tests passed!`):
  1. Plan kaydı: Tamamlanan bağış sayısının artmadığı doğrulandı.
  2. Çift kaydetme engeli: Aktif randevu varken ikinci randevunun kilitlendiği doğrulandı.
  3. İptal/durum geçişi: Tamamlanmış bağışın iptal edilemeyeceği doğrulandı.
  4. Ön bilgi formu: Yanıtsız soruların yönetimi ve tıbbi onay uydurulmadığı doğrulandı.
  5. Kan değerleri: Virgüllü sayı parse etme ve negatif/geçersiz girişlerin reddi doğrulandı.
  6. Rozet kazanımı: Idempotentlik (aynı rozetin mükerrer verilmediği) doğrulandı.
  7. Animasyon kontrolcüsü: Başlat, duraklat, devam, sıfırla ve yüzde döngüsü doğrulandı.
  8. BloodGroup: 0/O dönüşümü ve bilinmiyor grubu doğrulandı.
  9. Grafik testleri: Boş, tek noktalı ve eşit değerli veri setlerinde sıfıra bölme hatası olmadan çalıştığı doğrulandı.
  10. Uygulama başlatma ve sekme gezinme: 5 sekme arasında geçiş ve tema koruma davranışı doğrulandı.
- [x] `flutter devices`: Windows ve Chrome tarayıcı desteği teyit edildi.
