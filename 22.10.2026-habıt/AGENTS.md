# FreshTrack — AGENTS.md

## Ajanın görevi
Sen, FreshTrack Flutter projesinde çalışan kıdemli Flutter mühendisi, yazılım mimarı, UI uygulayıcısı ve test sorumlususun. `PROJECT.md` kapsamın tek kaynağı, `SKILLS.md` teknik standartların kaynağıdır. Kullanıcının en önemli isteği **hiçbir görünür butonun işlevsiz olmaması**, **Clean Architecture**, **GoRouter ile akıllı routing** ve **başarı/hata geri bildirimi**dir.

## Başlamadan önce
1. Mevcut proje dosyalarını incele (`pubspec.yaml`, `lib`, `test`, `analysis_options.yaml`); var olan kodu sebepsiz silme.
2. Flutter/Dart sürümünü ve bağımlılıkları kontrol et; çözülmeyen paket sürümünü uydurma.
3. `PROJECT.md`'yi okuyup o fazda kabul edilecek ekran ve işlemleri belirle.
4. Ajan davranışı: önce küçük, uygulanabilir plan; sonra dosyaları oluştur/değiştir; test et; gerçek sonuçları raporla.
5. Eksik tasarım detayı için minimalist, erişilebilir varsayılanlar kullan; araç kiralama veya ödeme işlevlerini gıda uygulamasına taşıma.

## Değiştirilemez kurallar
- Sahte sayfa, boş buton, inert `onPressed`, lorem ipsum, `Coming soon` / `Yakında` etiketi ve sahte başarılı işlem yasak.
- Henüz bağlanmayan bir özellik menüye eklenmez. Özellik tamamlanınca görünür yapılır.
- Her gösterilen eylem için success, failure, loading (uygun olduğunda) akışı vardır.
- Veri kalıcıdır; örnek veriler yalnız test/demo seed işlemine özeldir ve kullanıcı verisiymiş gibi sessizce gösterilmez.
- SQL/Drift/SQLite/Firebase/Supabase yoktur. SharedPreferencesAsync + tek sürümlü JSON snapshot yalnız data katmanında kullanılır. Domain, presentation ve data katmanları ayrıdır.
- Fonksiyonları sahip oldukları modül dosyasında tanımla ve import ederek kullan; business logic kopyalama.
- ID route parametresiyle ürünler arasında karışıklık olmayacak. Geçersiz ID için not-found ekranı.
- API key, sır, token, kullanıcı hassas bilgisi kaynak koda yazılmaz.
- Tehlikeli gıda tüketimini teşvik etme; tarihi geçmiş STT ürünü tariflerde önerme.
- Yönetici paneli için istemci tarafı görünürlük kontrolünü güvenlik sayma; gerçek sunucu doğrulaması yoksa panel ekleme.
- Ani hatada sadece 'eğlenceli' animasyon gösterip sorunu gizleme; açık mesaj ve tekrar dene eylemi ekle.

## İş yapma sırası
### Faz 1: Sağlam altyapı
- `flutter create` ile proje yoksa oluştur.
- Theme, responsive düzen, ortak UI state bileşenleri.
- FoodItem/ConsumptionEvent entity, JSON models (`toJson/fromJson`), SharedPreferencesAsync local datasource, repository interface + implementation, Riverpod providers, controller/notifier. JSON `schemaVersion` ve seri yazma güvenliği.
- Splash/bootstrap, onboarding tercihi, redirect, tab shell, deep link ve 404.
- Başlangıç testi.

### Faz 2: Tam çalışan envanter
- FoodItem ekleme/düzenleme/silme; doğrulama, geri dönüş ve refresh.
- Envanter kartı, ürün detayında UUID, filtre, arama, sıralama.
- Her kart, menü ve boş durum butonunu test et.

### Faz 3: Akıllı fayda
- Acil tüketim sınıflandırması, dashboard uyarıları.
- Yerel reçete kataloğu ve 'Bugün Pişir' eşleştirmesi.
- Tükettim/israf olayları ve doğrulanabilir tahmini tasarruf grafiği.
- Yerel bildirim ve izin/hata durumları.

### Faz 4: Final kalite
- Unit + widget + integration test; edge case ve timezone.
- Android cihaz/emülatör deneme; ekran boyutu ve erişilebilirlik.
- README, kurulum, demo komutları, ekran akışları, bilinen sınırlamalar.

## Her görevde çıktı formatı
1. **Hedef:** ne tamamlandı.
2. **Değiştirilen dosyalar:** yolları.
3. **Veri akışı:** UI → provider → use case → repository → datasource.
4. **Buton kontrolü:** hangi UI aksiyonu ne yapıyor.
5. **Doğrulama:** çalıştırılan komutlar ve gerçekte çıkan sonuç.
6. **Kalan sorunlar:** varsa dürüstçe belirt; kullanıcıya çalışıyor diye sunma.

## PR / kod inceleme kontrol listesi
- [ ] Her kullanıcı aksiyonunun handler'ı ve etkisi var.
- [ ] Navigasyon ID tabanlı ve fallback'li.
- [ ] Uygulama açılışı/onboarding redirect doğru.
- [ ] Başarı yalnız kalıcı işlem başarılı olduktan sonra gösteriliyor.
- [ ] Hata mesajı ve retry/geri dönüş mevcut.
- [ ] Filtreler AND/OR koşullarını ve sıfırlamayı uyguluyor.
- [ ] Ana ekran, liste, detay, tarifler, istatistik repository JSON state değişimini görüyor.
- [ ] Tarih sınırları ve STT/TETT farkı test edildi.
- [ ] Bildirim izinleri ve temizliği ele alındı.
- [ ] Testler gerçekten çalıştırıldı; sonuçlar raporlandı.

## AI coding aracı için ilk uygulanacak görev metni
> `PROJECT.md`, `SKILLS.md` ve `AGENTS.md` dosyalarını oku. Flutter stable kullanarak FreshTrack adında Android öncelikli uygulamanın Faz 1 ve Faz 2 çekirdeğini **derlenebilir ve çalışır** biçimde geliştir. Clean Architecture, Riverpod, SharedPreferencesAsync ile sürümlü tek JSON snapshot (veritabanı olmadan), go_router, onboarding redirect, ürün ID bazlı detay, envanter CRUD, arama/filtreleme, async loading/error/success geri bildirimi uygula. Boş buton, sahte ekran, Yakında etiketi veya dummy API kullanma. Kodu mantıksal Dart dosyalarına böl ve import et. Hata ayıklama ve test için `flutter analyze` ve `flutter test` çalıştır, sonra çalıştırılabilir ekranlar ile sonucu raporla. Eğer bir özellik tamamlanamıyorsa üretim navigasyonundan çıkar ve sınırlamayı açıkça raporla.

## Stitch AI için kısa iş emri
> Use the PROJECT.md design brief. Produce all FreshTrack screens with Turkish text, consistent Material 3 components, usable green/amber/red status presentation and realistic success, empty, loading and error states. Avoid unnecessary financial, vehicle, security, payments, admin or AI widgets. Keep UI minimalist, airy and implementable in Flutter.

## Veritabanısız mimari için ek zorunlu denetim
- `presentation/controllers`, `presentation/providers`, `presentation/screens` veya `pages`, `data/models`, `data/datasources`, `data/repositories`, `domain/entities`, `domain/usecases`, `domain/repositories`, `app/router` ayrımını koru; tüm widget callback'lerini controller/use case akışına bağla.
- Örneğin `FoodCard` yalnız `id` ile `context.pushNamed('foodDetail', pathParameters: {'id': food.id})` kullanır; detay sağlayıcısı ilgili ID'yi repository'den getirir.
- Senkron saf fonksiyonlar (filtreleme, SKT sınıflandırma, hesap) `domain` veya `core` içinde; asenkron JSON yazma, ilk yükleme ve bildirim planlama `data`/servis içinde. İlgili dosyalardan `import` et.
- SharedPreferences'ın kalıcı kritik kullanıcı verileri için ideal olmadığını saklama; ders projesi sınırlamasını belgele. Storage başarısızsa başarılı Snackbar verme.
- Dört fazın hiçbiri boş ekran, sahte AI, sahte admin veya 'Yakında' içeremez.


## Şef AI referans ekranı — ek ajan talimatı (2026-10-22)
1. Kullanıcının paylaştığı ekran referansını tasarım hedefi yap; statik ekran görüntüsü yerleştirme, gerçek Flutter widget'ları oluştur. Durum verilerini providers üzerinden bağla.
2. Önce **backend olmadan çalışan** `OfflineRecipeAssistantRepository` + katalog + malzeme eşleştirme + rezervasyon + bugün planı + kullanıcı geri bildirimi geliştir. Ekran adında "Akıllı Mutfak" yaz; AI sohbet gibi davranma.
3. Sonra **opsiyonel** `backend/` FastAPI adaptörünü oluştur; yalnız gerçek LLM yapılandırılınca Şef AI serbest sohbetini aç. Uygulamayı backend yokken de derlenebilir/çalışabilir bırak. Çevrimdışı modda "servise bağlanamadı" diye çalışan yerel önerileri bozma.
4. Önceki zorunluluklar KORUNACAK: Clean Architecture + modeller/controller/view/data/domain/use cases, Dart dosyalarından import, Riverpod, GoRouter smart redirect, ID ile route, native splash/onboarding, `shared_preferences` JSON, filtre/sıralama, kırmızı-sarı-yeşil, CRUD, bildirimler, istatistikler, başarı/başarısızlık/loading/error/empty, gerçek butonlar, responsive minimal Stitch tarzı.
5. Kapsam dışı araç kiralama (NFC/HGS/araç kilidi/depo/yol yardımı/3D Secure/kur/kredi kartı) eklenmeyecek. Yönetici paneli yalnız gerçek rol bazlı doğrulama ve sunucu kontrolü varsa mümkündür; bu projede YOK.
6. Her tarif için ingredient ID/miktar/birim/alternatif eşleşmesini doğrula. Son tarihi geçmiş STT veya şüpheli gıdaları önerme. "Malzemeleri Ayır" rezervasyon oluşturur, stok tüketmez; "Pişirdim" tüketir; "Bugün Pişir'e Ekle" kalıcı ve tekrar tıklamaya dayanıklı bir plan oluşturur.
7. Her butonu takip eden user journey test et; işlem gerçekten yazılmadıysa başarı gösterme. Kamera, mikrofon veya serbest metin AI entegre değilse kontrol hiç gösterilmez, "yakında" yazılmaz.
8. Backend eklendiğinde API anahtarı istemcide bulunamaz, server env'de tutulur. `POST /v1/chef/respond` için schema, timeout, hata yönetimi, rate limiting, veri minimizasyonu, sunucuda sohbet saklamama ve endpoint testleri zorunludur.
9. Uygulamaya scaffold ekleyip bırakma: envanterde ürün sayısını değiştir; tarih uyarısı güncellensin; tarif kartında malzeme eşleşsin; ayır ve bugün liste işlemleri uygulama yeniden başlatılınca kalsın. Bunları kanıtlayan testleri yaz/çalıştır.
10. Çıktıda gerçek tamamlanan işleri, yapılmayan işleri ve doğrulanan komutları ayrı belirt. Dosyaların bulunduğu yolları ve uygulamanın nasıl çalıştırılacağını ver.

### AI coding aracına yeni ilk görev
> Önce PROJECT.md, SKILLS.md, AGENTS.md'nin tamamını oku. Flutter uygulamasını daha önce belirlenen Clean Architecture ve veritabanısız kalıcı JSON mimarisiyle koru. Yüklenen Şef AI ekranını gerçek widget'larla implemente et. Başlangıçta offline Akıllı Mutfak öneri motorunu, gerçek tarif kataloğunu, malzeme eşleme, ayrılan malzeme, Bugün Pişir planı, ilgili ID route'ları ve başarılı/hatalı durumu bitir. Tüm buton ve navigasyonları uçtan uca çalıştır. Daha sonra backend/ FastAPI proxy'yi **opsiyonel entegrasyon** olarak tasarla; sahte LLM cevabı üretme ve istemciye secret koyma. `flutter analyze`, `flutter test` ve varsa `pytest` çalıştırıp doğru sonuçları bildir.


## Gıda Bağışı & Paylaşım ekranı — bağlayıcı ajan gereksinimleri (2026-10-22)
İkinci görseli FreshTrack bağış modülü için UI referansı kabul et. Önceki Şef AI ekranını, SKT envanterini, tasarruf istatistiklerini, router ve Clean Architecture gereklerini **silme veya bozma**.

### Önce backend sınırını doğrula
- Yerel ürün uygunluk listesi, paket taslağı, paket düzenleme/rezervasyon ve geçmiş taslaklar **SharedPreferences + JSON ile backend olmadan** yapılır.
- Mahalleye gerçek ilan yayımlamak, hesaplar arası eşitleme, doğrulanmış bağış noktaları yönetmek, gerçek kurye talebi, karşı taraf kabulü, sertifika doğrulaması ve topluluk istatistiği için **kimlik/yetki/doğrulama içeren backend ve veri kaynağı gerekir**. Önceki opsiyonel FastAPI AI backend'i bunları kendiliğinden sağlamaz; ayrı donation API yetenekleri tasarlamak gerekir. Öğretim projesinin backend olmayan MVP'sinde bu eylemleri görünür buton olarak sunma.
- Gerçek sağlayıcı/kurum verileri gelmeden ekrandaki '42 kg', '14 hane', Kadıköy Aşevi, mahalle dolabı, 'şu an açık', 1.2 km, 7/24 vb. yalnız tasarım placeholder'larıdır; gerçek bilgi gibi render etme.

### Uygulama sırası
1. `features/donations` için domain entity, model, local datasource, repository arayüzü/implementation ve usecase'leri ayrı Dart dosyalarında oluştur.
2. `DonationController` + Riverpod provider'ları oluştur; ürün repository'sini bağla, ID bazlı ilişkiyi ve stok rezervasyonunu kur.
3. GoRouter'a `/donations`, `/donations/eligible`, `/donations/drafts/new`, `/donations/drafts/:draftId`, `/donations/history` ekle; onboarding redirect ve tab shell kalsın.
4. Görseldeki kartları Flutter Material 3 ile oluştur. Yalnızca gerçekten çalışan aksiyonları ve doğrulanmış bilgileri göster. Taslak/teslim ayrımını görselde belirt.
5. Eligibility, quantity, persistence, navigation, error, retry, duplicate click ve inventory-sync testlerini yaz; mevcut testleri çalıştır. `flutter analyze` ve `flutter test` sonuçlarını doğru raporla.

### Kabul kriteri
Pakete ekle/sil/tamamla/yeni paket/geçmiş/Tümünü Gör/soru işareti çalışır; veri uygulama yeniden açıldığında korunur; ürün silinir veya STT geçerse yeniden doğrulanır; hiçbir işlem yalnızca buton animasyonu değildir. Bağış teslimi veya kurum onayı yoksa gerçek bağış sayacı artmaz. Hata, başarı, boş durumları erişilebilir mesajlarla gösterilir; bağış yetkisi yokken uzaktan yayın veya kurye talebi görünmez.

### AI ajana uygulanacak görev metni
"PROJECT.md, SKILLS.md, AGENTS.md dosyalarını güncel hâliyle eksiksiz oku. Veritabanı kullanmadan mevcut Clean Architecture/GoRouter/Riverpod/SharedPreferences tabanını koru. İkinci referans görüntüsündeki Gıda Bağışı & Paylaşım modülünü gerçek yerel paket taslağı, uygunluk doğrulaması, ürün ID referansı, envanter senkronizasyonu, durum mesajları ve çalışan butonlarla uygula. Ekrandaki uydurma merkezleri, mahalle sayılarını, kurye, sertifika ve doğrulama ifadelerini gerçek veri olmadan gösterme. Şef AI ve diğer modülleri bozma. Test edip sonuçlarını dürüstçe raporla."
