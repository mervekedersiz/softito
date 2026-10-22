ROJECT.md — Akıllı Araç Kiralama ve Paylaşım
1. Proje tanımı
Flutter ile geliştirilen, öncelikle araba kiralama üzerine odaklanan, sonradan farklı ulaşım ve paylaşım hizmetlerine genişleyebilen mobil uygulama.

İlk teslim: kullanıcı çalışır bir Flutter arayüzünde araçları inceleyebilmeli, filtreleyebilmeli, detayları görebilmeli ve doğrulanan bir rezervasyon talebi oluşturabilmeli. Gerçek ödeme, canlı GPS, kimlik doğrulaması veya filo entegrasyonu ilk sürümün parçası değildir. Demo verileri gerçek hizmet gibi sunulmaz.
2. Kaynak fikirler ve kapsam kararı
- İlk sürüm (MVP): araba kirala, Tesla/elektrikli seçenek, manuel/otomatik filtre, araç galerisi, fiyat, müsaitlik gösterimi (demo), rezervasyon formu, favoriler, profil, açık/koyu tema.
- İkinci aşama: "Arabanın Ortağı" (güzergâh paylaşımı), "Bagajı Kullan" (eşya taşıma), "Acemiyim" (sürüş mentorlugu).
- Gelecek fikirleri: tekne kiralama (yemek/organizasyon/katılım), uçak/helikopter kiralama, acemi pilot eşleşmesi, evcil hayvan taşıma, sesli destek, çeviri.
- Fotoğraf notlarından yorumlanan ek fikirler: "Amacın ne?", "Ne kiralamak istiyorsun?", "Nereden–Nereye?", araç kategorileri, "Bağış?" değil "Bagajı Kullan", "Bagajım/Hayvanım nerede?" ve "Galeri". Belirsiz el yazısı terimleri kesin gereksinim sayılmaz.
- Kapsam dışı özellikleri bu aşamada çalışan gerçek entegrasyon gibi göstermeyin. Kullanıcıya "Yakında" etiketi verilebilir.
3. Ders kazanımları
1. Temel UI, butonlar ve etkileşimler: Scaffold, AppBar, Card, ListView, GridView, NavigationBar, FilledButton, InkWell, filtre çipleri.
2. Form ve doğrulama: Form, GlobalKey<FormState>, TextFormField, DropdownButtonFormField, tarih seçimi, uygun hata metinleri.
3. Material Design 3 ve tema: useMaterial3, ColorScheme, ThemeMode.system/light/dark, kalıcı tema tercihi (ikinci iterasyon).
4. Dialog ve SnackBar: rezervasyon özeti AlertDialog, geçerli talep sonrası SnackBar, hata durumlarında açıklayıcı geri bildirim.
5. Ekstra: Hero, AnimatedSwitcher, Semantics; bunlar temel akışı bozmayacak şekilde uygulanır.
4. Kullanıcı senaryosu (MVP)
1. Açılışta "Amacın ne?" ana ekranı; "Araba Kirala" etkin, sonraki modüller "Yakında".
2. Kullanıcı araç listesinden araç seçer; şanzıman, yakıt türü ve günlük fiyat filtreleyebilir.
3. Araç kartında resim, marka/model, vites, yakıt, koltuk, günlük fiyat görünür.
4. Detay ekranında açıklama, fotoğraf, özellikler, örnek müsaitlik ve "Kirala" butonu bulunur.
5. Kiralama formunda alış/teslim konumu, başlangıç ve bitiş tarihi/saat bilgisi istenir.
6. Geçerli tarih aralığında toplam tutar örnek fiyat hesabı ile gösterilir.
7. Onay diyalogundan sonra demo rezervasyon talebi oluşturulur; rezervasyonlar sekmesinde görünür.
8. Profil sekmesinden tema değiştirilebilir; favori araçlar listelenebilir.
5. Form ve iş kuralları
- Boş zorunlu alanları reddet; anlamlı Türkçe hata mesajı göster.
- Bitiş tarihi/saat başlangıçtan sonra olmalı; geçmişe dönük başlangıç engellenmeli.
- Alış ve teslim konumları açıkça seçilmeli. Aynı konum seçilmesine izin verilebilir.
- Fiyat pozitif olmalı; filtrelerde min <= max.
- MVP fiyat kuralı: başlanan her 24 saatlik blok bir kiralama günü olarak ücretlenir; 25 saat = 2 gün. Kural arayüzde açıklanır.
- total = ceil(duration.inMinutes / 1440) * dailyPrice; süre pozitif olmak zorunda.
- Bir araç demo listesinde müsait değilse Kirala devre dışı.
- Kimlik, ehliyet, ödeme kartı gibi hassas bilgileri mock veriye koyma veya isteme.
- Gerçek rezervasyon/ödeme varmış gibi bir başarı mesajı gösterme.
6. Teknik yaklaşım
- Framework: Flutter / Dart (kurulu stabil SDK ile uyumlu sürüm).
- İlk hedef: Android emülatörü/telefon ve Chrome üzerinde çalışan responsive demo.
- Design: Material Design 3, Türkçe arayüz, light/dark mode.
- Navigation: MVP'de Navigator veya basit go_router; bağımlılık eklemeyi ihtiyaç belirler.
- State: MVP'de ChangeNotifier + ListenableBuilder / AnimatedBuilder; karmaşık provider paketleri zorunlu değil.
- Veri: MockVehicleRepository, MockBookingRepository; daha sonra gerçek API ile değiştirilebilen soyut repository sözleşmeleri.
- Demo rezervasyonlar başlangıçta yalnızca çalışma oturumu boyunca tutulabilir; kalıcı depolama ayrı görev.
- Görseller: assets/images/ içindeki lisanslı yerel örnek araç görselleri; bulunmuyorsa Icon temelli placeholder (kırık URL yok).
- İlk aşamada backend, giriş sistemi, ödeme, GPS, kamera, canlı yayın ve üçüncü taraf API anahtarı yok.
7. Önerilen klasör yapısı
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── app_navigation.dart
│   └── app_theme.dart
├── core/
│   ├── constants/
│   ├── utils/
│   └── widgets/
│       ├── app_button.dart
│       ├── app_empty_state.dart
│       └── app_vehicle_image.dart
└── features/
    ├── home/
    │   └── presentation/pages/home_page.dart
    ├── vehicles/
    │   ├── domain/entities/vehicle.dart
    │   ├── domain/repositories/vehicle_repository.dart
    │   ├── data/repositories/mock_vehicle_repository.dart
    │   └── presentation/
    │       ├── pages/vehicle_list_page.dart
    │       ├── pages/vehicle_detail_page.dart
    │       ├── widgets/vehicle_card.dart
    │       └── controllers/vehicle_controller.dart
    ├── bookings/
    │   ├── domain/entities/booking.dart
    │   ├── domain/repositories/booking_repository.dart
    │   ├── data/repositories/mock_booking_repository.dart
    │   └── presentation/
    │       ├── pages/booking_form_page.dart
    │       ├── pages/my_bookings_page.dart
    │       └── controllers/booking_controller.dart
    ├── favorites/
    │   └── presentation/pages/favorites_page.dart
    └── profile/
        └── presentation/pages/profile_page.dart
assets/images/
test/
PROJECT.md
SKILLS.md
Gelecekte features/carpool, features/trunk_pet, features/mentorship, features/watercraft ve features/aircraft eklenecek. Şimdilik boş klasör ve çalışmayan ekran üretme.

8. Örnek veri modeli
Vehicle: id, brand, model, category(car), transmission(manual/automatic), fuelType(gasoline/diesel/electric/hybrid), seatCount, dailyPrice, imageAsset?, description, isAvailable.

Booking: id, vehicleId, pickupLocation, returnLocation, startAt, endAt, billableDays, estimatedTotal, status(demoPending), createdAt.

Demo araçlar: Tesla Model 3 (elektrik/otomatik), Toyota Corolla (otomatik), Renault Clio (manuel), Fiat Egea (manuel). Fiyatlar temsili ve açıkça demo olarak belirtilmiş olmalı.
9. Ekranlar ve navigasyon
- HomePage: karşılama, kategoriler, popüler araçlar.
- VehicleListPage: filtre, liste/galeri, boş sonuç durumu.
- VehicleDetailPage: araç ayrıntısı, favori, kirala.
- BookingFormPage: lokasyon/tarih alanları, toplam hesaplama, onay dialogu.
- MyBookingsPage: demo talepleri ve boş durum.
- FavoritesPage: favori araçlar.
- ProfilePage: tema, uygulama hakkında, demo uyarısı.
- Alt gezinme: Ana Sayfa / Araçlar / Rezervasyonlar / Favoriler / Profil (dar ekranlarda uygun desen kullan).
10. Tasarım sistemi
- Ana renk: koyu lacivert #1E3A8A; ikincil: yeşil #10B981; uyarı: amber #F59E0B.
- Bu hex değerleri yalnızca tema kurulumunda tanımla; ekranlarda colorScheme kullan.
- Açık ve koyu tema kontrastlarını denetle; sistem yazı ölçeğine saygı göster.
- Kartlarda yuvarlatılmış köşeler, okunaklı fiyatlar, düzenli boşluklar, erişilebilir dokunma alanları.
- Animasyon kısa, ölçülü ve hareket azaltma tercihlerine duyarlı olmalı.
11. Teslim sırası
- Faz 0: flutter doctor, proje yapısını inceleme, mevcut proje varsa silmeden uyarlama, flutter pub get.
- Faz 1: main.dart, app.dart, Material 3 light/dark tema, ana sayfa ve navigasyon.
- Faz 2: Vehicle modeli, mock repository, galeri, filtre ve araç detay ekranı.
- Faz 3: Rezervasyon formu, validasyonlar, fiyat fonksiyonu, dialog, snackbar, rezervasyon listesi.
- Faz 4: Favoriler, profil, tema kontrolü, responsive ve erişilebilirlik.
- Faz 5: Unit/widget testleri, flutter analyze, flutter test, Chrome/Android smoke test, README.
- Faz 6 (sonra): araba paylaşımı, bagaj, mentorluk; platform/izin/güvenlik gereksinimlerini ayrıca tasarla.
12. Tamamlama ölçütleri
- [ ] flutter run -d chrome kullanılabilir SDK/cihaz koşullarında açılıyor.
- [ ] En az 4 demo araba listeleniyor ve filtreler gerçekten çalışıyor.
- [ ] Araç detayı ve kiralama formuna ulaşılabiliyor.
- [ ] Geçersiz tarih/girdi kaydedilemiyor, hata mesajları açık.
- [ ] 25 saatlik örnek rezervasyon 2 gün ücretlendiriliyor.
- [ ] Onay diyaloğu ve başarılı demo kayıt sonrası SnackBar çalışıyor.
- [ ] Rezervasyon listesi oturum boyunca güncelleniyor.
- [ ] Dark/light temalar ve küçük ekran düzeni kullanılabiliyor.
- [ ] Testler ve analiz temiz; yapılandırılmamış özellikler gerçekmiş gibi gösterilmiyor.
13. AI geliştirme başlangıç talimatı
SKILLS.md kurallarını oku. Mevcut klasörü denetle; Flutter projesi yoksa yeni Flutter uygulaması oluştur. İlk etapta yalnız Faz 0 ve Faz 1'i kodla. Mevcut dosyaları silme, gereksiz paket ekleme. Her adım sonunda değişen dosyaları, çalıştırılan komutları ve sonuçları bildir. Sonraki faza geçmek için onay bekle.