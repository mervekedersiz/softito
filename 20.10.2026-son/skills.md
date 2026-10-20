ILLS.md — Flutter Geliştirici ve AI Ajan Rehberi
1. Görev
PROJECT.md belgesindeki araba kiralama Flutter MVP'sini kontrollü aşamalarla üret. Bu belge geliştirme davranışını tanımlar; ürün gereksinimleri için PROJECT.md geçerlidir.
2. Zorunlu kurallar
1. Önce PROJECT.md, sonra ilgili kod dosyalarını oku. Tüm repository'yi her adımda yeniden tarama.
2. Var olan kullanıcı kodunu izinsiz silme, baştan yazma veya büyük ölçekte yeniden düzenleme.
3. Her .dart ve .md dosyası en fazla 250 satır; uzun dosyaları ayrı, anlamlı sınıf/widget dosyalarına böl.
4. SOLID, DRY, KISS, YAGNI prensipleri; soyutlama yalnızca somut ihtiyacı çözdüğünde eklenir.
5. Feature-first yapı kullan; domain Flutter UI bağımlılıklarından arınmış olsun.
6. UI'dan doğrudan fake HTTP çağrısı yapma. Veri erişimi repository'de tutulur.
7. Kod ve değişken isimleri İngilizce; kullanıcı metinleri Türkçe; sınıflar PascalCase, değişken/dosyalar camelCase/snake_case Dart team conventions'a uygun.
8. Her ana görev sonrası dart format ., flutter analyze, ilgili flutter test çalıştır; hataları açıkça bildir.
9. İşlenmeyen özellikleri gerçek hizmet veya gerçek zamanlı takip olarak göstermeyin. Mock durumlar görünür biçimde etiketlensin.
10. Sırları, kişisel verileri veya ödeme bilgilerini kaynak koda ekleme.
3. Çalışma modları / mikro-ajan yetenekleri
- Architect: dosya ağacı, bağımlılık yönleri, 250 satır sınırı, minimum paket.
- Flutter UI: Material 3, responsive layout, navigasyon, Hero ve küçük animasyonlar.
- Forms & Logic: Form, GlobalKey<FormState>, validasyon, tarih/fiyat mantığı, hata durumları.
- Data: typed Dart modelleri, test edilebilir mock repository, deterministik örnek veri.
- Quality: widget/unit testleri, erişilebilirlik, format/analyze/test.
- Accessibility: Semantics, Tooltip, metin ölçekleme, yeterli dokunma boyutları.Bunlar ayrı çalışan ajanların varlığı iddiası değil; AI'nın görevleri bölmek için izleyeceği uzmanlık başlıklarıdır.
4. Teknoloji tercihleri
- MaterialApp, Material Design 3, ThemeData, ColorScheme.fromSeed ve ThemeMode.
- İhtiyaç dışı paket kurma. Google Fonts şart değil; paket/İnternet yoksa varsayılan sistem fontu kullanılabilir.
- Durum için önce ChangeNotifier; görünümde ListenableBuilder veya uygun AnimatedBuilder.
- Stateless/StatefulWidget seçimini ihtiyaca göre yap; business logic'i büyük build metoduna koyma.
- Harici servis yoksa repo arayüzü + mock implementasyonu kullan.
- Görsel yüklenmezse kırık resim bırakma: local placeholder göster.
5. UI ve tema standardı
- Tema lib/app/app_theme.dart içinde.
- Widget içinde doğrudan Color(0x...), Colors.blue vb. sabit renkler kullanma; Theme.of(context).colorScheme değerlerini kullan.
- Sayfalarda Scaffold, liste/görsel kartlarında Card, eylemlerde FilledButton/OutlinedButton, seçimde FilterChip, tıklanabilir satırlarda InkWell.
- NavigationBar ile alt gezinme; sayfa geçişleri tutarlı olsun.
- Fiyatları Türkçe biçimde ₺ ve okunur sayı formatıyla göster; paket kullanılıyorsa sürüm uyumunu kontrol et.
- Hero yalnızca uygun liste-detay görsellerinde; animasyon yoksa işlev bozulmasın.
- Ekranlarda loading/empty/error durumlarını gerektiğinde tanımla.
6. Form ve iş mantığı standardı
- Tüm kiralama formlarında Form + GlobalKey<FormState>.
- TextFormField / seçicilerde okunur etiket ve Türkçe hata mesajı.
- DateTime ile tarihleri karşılaştır; sadece ekranda gösterilen metni doğrulama.
- Form doğrulanmadığında rezervasyon repository'sine kayıt gönderme.
- Gün hesabı: ceil(duration.inMinutes / 1440), yalnızca duration > 0 için.
- Birim testleri: sıfır/negatif süre reddi, 24 saat=1 gün, 25 saat=2 gün, pozitif fiyat kontrolü.
- Formdan başarılı gönderim: önce AlertDialog ile özeti onaylat; onaydan sonra demo kaydı ve SnackBar.
- Dialog iptalinde kayıt oluşturma; kullanıcıya sahte başarı mesajı verme.
7. Test stratejisi
- test/features/bookings/booking_price_test.dart: ücret hesabı ve sınırlar.
- test/features/bookings/booking_validation_test.dart: geçersiz tarih ve boş alanlar.
- test/features/vehicles/vehicle_filter_test.dart: manuel/otomatik, elektrikli ve fiyat filtreleri.
- test/widget_test.dart: açılış ekranı, tema veya temel navigasyon smoke testi.
- Testler offline çalışmalı, ağ/GPS/ödeme servisi istememeli.
8. Erişilebilirlik ve güven
- Butonların anlamlı metni/Tooltip'u ve resimlerin açıklayıcı Semantics etiketi olsun.
- Renge tek başına güvenerek müsaitlik veya hata bildirme.
- Kullanıcı girdilerinde veri minimizasyonu; gerçek kimlik/ehliyet/ödeme isteme.
- Gerçek hizmete geçilirse ehliyet uygunluğu, sigorta, lisans, gizlilik, izinler ve ödeme güvenliği ayrıca değerlendirilir.
- Gelecekteki kadın/erkek tercihi, eşleştirme ve izleme gibi fikirler için ayrımcılık, kullanıcı rızası ve mahremiyet tasarımı yapılmadan üretim özelliği geliştirme.
- Canlı takip/evcil hayvan sıcaklığı gibi uydurma sensör değerlerini gerçek veri olarak sunma.
9. Paket ve komut politikası
flutter --version
flutter doctor
flutter pub get
dart format .
flutter analyze
flutter test
flutter run -d chrome
- Komut çalışmadıysa çalışmış gibi raporlama.
- flutter create yalnızca proje gerçekten yoksa ve kullanıcı mevcut projeyi korumak istediğinde uygun klasörde.
- Paket eklemeden önce gerekçesini açıkla ve mevcut Flutter/Dart SDK sürümüyle uyumluluğu doğrula.
- Chrome cihazı yoksa flutter devices çıktılarını kontrol et, uygun çalıştırma hedefi öner.
10. AI ajanı adım adım çalışma protokolü
1. Mevcut klasör, pubspec.yaml, lib/main.dart ve belgeleri denetle.
2. Yapılacak fazı ve en fazla 5 kısa alt görevi bildir.
3. Yalnızca o fazın gerekli dosyalarını oluştur veya düzenle.
4. İlgili testleri ekle; format/analyze/test çalıştır.
5. Çıktıda Oluşturulan/Değiştirilen Dosyalar, Test Sonuçları, Bilinen Eksikler, Sonraki Faz ver.
6. Kullanıcı onayı olmadan bir sonraki faza ve özellikle canlı API/ödeme entegrasyonuna geçme.
11. Kabul kontrol listesi
- [ ] PROJECT.md kapsamına uyum
- [ ] Flutter uygulaması en az bir hedefte çalışıyor
- [ ] Dosyalar 250 satırı geçmiyor
- [ ] Gereksiz paket veya boş gelecek özellik klasörleri yok
- [ ] Tema semantik renklerle uygulanıyor
- [ ] Filtreler ve rezervasyon validasyonları gerçekten çalışıyor
- [ ] Dialog, SnackBar ve empty/error durumları uygun
- [ ] Demo/mock uyarıları açık
- [ ] flutter analyze ve flutter test sonuçları dürüstçe raporlandı
12. AI aracına ilk komut
"PROJECT.md ve SKILLS.md dosyalarını oku. Klasörde halihazırda bir Flutter projesi varsa koru. Yoksa Flutter projesini oluştur. Sadece Faz 0 ve Faz 1'i uygula: uygulama girişi, Material Design 3 açık/koyu tema, ana sayfa, temel alt navigasyon ve 'Yakında' gösterimleri. Demo araç listesi, rezervasyon formu ve ek servisler için sonraki fazı bekle. Gerekli test ve analizleri çalıştırıp sonucu raporla."