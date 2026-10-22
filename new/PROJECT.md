# FreshTrack — PROJECT.md

## 1. Proje tanımı
FreshTrack, evdeki buzdolabı ve kiler ürünlerini son tüketim tarihi (STT/SKT) ve tavsiye edilen tüketim tarihi (TETT) bakımından takip eden, öncelikli tüketim listesi, tarif önerileri, yerel bildirimler ve ölçülebilir israf/tasarruf istatistikleri sunan Flutter uygulamasıdır.

**Hedef:** İşlevsel, offline-first, minimalist, Türkçe arayüzlü, test edilebilir Android öncelikli MVP. iOS desteği mimari olarak açık tutulur.

## 2. Kesin kapsam ve kapsam dışı
### MVP'de mutlaka çalışan özellikler
1. İlk açılış onboarding; tamamlanma tercihini kalıcı sakla ve doğru route'a yönlendir.
2. Native splash ve uygulama açılışında yerel tercih ve JSON veri yükleme için ayrı loading durumu.
3. Ana sayfada toplam ürün, yaklaşan tarihler, geçmiş tarihler, bu ay kaydedilen tasarruf ve hızlı eylemler.
4. Ürün ekleme, görüntüleme, düzenleme, silme (onay penceresiyle).
5. Saklama yeri: buzdolabı, dondurucu, kiler; kategori: süt ürünleri, et/balık, sebze/meyve, kuru gıda, diğer.
6. Ürün alanları: benzersiz ID, ad, miktar, birim, kategori, yer, tarih tipi, tarih, satın alma fiyatı (isteğe bağlı), not, oluşturulma/güncellenme zamanı, tüketim durumu.
7. Ürün detay route'u ID'ye dayanır; olmayan ID için kullanıcı dostu bulunamadı ekranı ve geri dönüş.
8. Filtreleme: kategori, saklama yeri, tüketim durumu, tarih aciliyeti ve metin araması; çoklu filtreler birlikte uygulanır, sıfırlanır.
9. Sıralama: en yakın tarih, ürün adı, eklenme tarihi; arayüzde mevcut seçeneklerin hepsi çalışır.
10. Tarih durumları: tarihi geçmiş / bugün / 1-2 gün / 3-5 gün / 6+ gün. Renk + metin + ikonla göster (yalnız renge güvenme).
11. 'Bugün Pişir': yalnızca eldeki uygun malzemelerle eşleşebilen gerçek yerel tarif kataloğundan öneriler; sonuç yoksa açıklama ve alternatif eylem.
12. Tarif detayında malzeme, eksik malzeme, adımlar, süre ve ilgili ürün ID'leri.
13. 'Tükettim' ve 'İsraf oldu' işlemleri: stok azalt veya tüketim olayına kaydet; çift sayımı önle, onay/geri alma akışını tanımla.
14. Tasarruf istatistiği: gerçekten tüketildi olarak kaydedilen ürünler üzerinden **tahmini** maliyet; fiyatı olmayan ürünleri toplamdan hariç tut ve bunu açıkça belirt. İsraf edilen ürünler ayrı raporlansın.
15. Yerel bildirim: kullanıcı izni al, varsayılan olarak sadece izin verilirse planla, tarih değişince eski bildirimi iptal et ve yeniden planla, silince iptal et, bildirimden ürün detayına git. Bildirim engellenmişse ayarlardan nasıl açılacağını göster.
16. Loading / empty / success / validation error / permission denied / storage error / not-found / retry ekran ve durumları.
17. **Veritabanı olmadan yerel kalıcılık:** `shared_preferences` üzerinde sürümlü JSON kayıtları; uygulama kapatılıp açılsa bile envanter, tüketim olayları ve tercihler saklanır. Bu bir SQL veritabanı değildir.
18. Tüm görünen butonlar, menüler, kartlar, filtreler, boş durum eylemleri ve yönlendirmeler gerçek fonksiyona bağlıdır.

### Sonraki faz (ancak gerçekten tamamlanırsa menüde göster)
- Yapay zekâ asistanı: güvenli backend ile tarif soru-cevap, ürün bazlı öneri; API anahtarı Flutter istemcisine gömülmez. Backend yoksa AI düğmesi/menüsü hiç gösterilmez; kural tabanlı tarif modülü çalışır.
- Yönetici paneli: yalnızca gerçek kimlik doğrulama ve sunucu tarafı rol denetimi varsa; kullanıcı hesabı ve merkezi veri yokken sahte admin ekranı yapılmaz.
- Barkod tanıma ve bulut senkronizasyonu; yalnız uçtan uca uygulanırsa açılır.

**Kesinlikle kapsam dışı:** Araç kiralama, araç kilidi, HGS, ceza, NFC sürüş hakkı, acil yol yardımı, depo, kur sorgulama, kredi kartı görünümleri, 3D Secure ve ödeme. Başka proje notlarından yanlışlıkla eklenmeyecek.

## 3. Teknoloji kararları
- Flutter stable + Dart (sürüm uyumluluğunu kurulum anında doğrula).
- Navigasyon: `go_router` (named routes, pathParameters, redirect, listenable refresh).
- State / DI: `flutter_riverpod` (async notifier/provider aileleri gerektiğinde).
- Yerel veri: `shared_preferences` (tercihen güncel `SharedPreferencesAsync`) + `dart:convert` ile JSON serileştirme. **SQLite, Drift, Firebase, Supabase, SQL sunucusu yok.**
- Immutable model: `freezed` + `json_serializable` gerekli olduğunda; basit MVP'de aşırı codegen'den kaçın.
- Kimlik: `uuid`.
- Zaman ve biçimlendirme: `intl`, zaman için test edilebilir clock soyutlaması.
- Bildirim: `flutter_local_notifications`, `timezone`, izin yönetimi.
- Grafik: `fl_chart`.
- Native splash: `flutter_native_splash`.
- Yerel ayar: `shared_preferences` üzerinde onboarding, bildirim tercihleri ve bu ders projesine uygun küçük yerel envanter. Büyük/kritik veriler için uygun olmadığının bilincinde ol.
- Testler: `flutter_test`, uygun fake repository ve test double'ları.

Paket sürümlerini körlemesine sabitleme; `flutter pub add` ile güncel uyumlu sürümleri çöz.

## 4. Clean Architecture: bağımlılık kuralı
**Presentation → Domain ← Data**. Presentation data source'a direkt dokunamaz. Domain Flutter, SharedPreferences ve UI paketlerini import etmez. Data, Domain sözleşmelerini uygular.

Örnek klasör ağacı:
```text
lib/
  main.dart
  app/
    app.dart
    bootstrap.dart
    router/app_router.dart
    router/route_names.dart
    theme/app_theme.dart
  core/
    errors/app_failure.dart
    result/result.dart
    time/app_clock.dart
    widgets/{async_state_view,app_error_view,empty_state_view}.dart
    utils/date_status.dart
  features/
    onboarding/
      data/onboarding_preferences.dart
      presentation/{onboarding_screen,onboarding_controller}.dart
    inventory/
      domain/
        entities/food_item.dart
        repositories/food_repository.dart
        usecases/{add_food,update_food,delete_food,get_food,watch_foods}.dart
      data/
        datasources/local_food_datasource.dart
        models/food_item_model.dart
        models/consumption_event_model.dart
        repositories/food_repository_impl.dart
      presentation/
        controllers/inventory_controller.dart
        providers/inventory_providers.dart
        screens/{inventory_screen,food_form_screen,food_detail_screen}.dart
        widgets/{food_card,food_filters,food_status_chip}.dart
    dashboard/presentation/{dashboard_screen,dashboard_provider}.dart
    urgent/presentation/{urgent_screen,urgent_provider}.dart
    recipes/
      domain/{entities/recipe.dart,usecases/suggest_recipes.dart}
      data/local_recipe_catalog.dart
      presentation/{recipes_screen,recipe_detail_screen,recipes_provider}.dart
    statistics/
      domain/usecases/calculate_statistics.dart
      presentation/{statistics_screen,statistics_provider}.dart
    notifications/
      data/notification_scheduler.dart
      presentation/notification_settings_screen.dart
    settings/presentation/settings_screen.dart
  l10n/
test/
  unit/
  widget/
  integration_test/
```
Her klasörü boş dosyalarla doldurma; ihtiyaç oldukça oluştur, ancak katman sınırlarını koru. Ayrı Dart fonksiyonları ilgili dosyada tanımlansın ve gerekli yerlerde `import` ile kullanılsın; kopyala-yapıştır mantık olmasın.

## 5. Ekranlar ve route ağacı
```text
/splash                  -> bootstrap kontrolü (native splash'ten ayrı)
/onboarding              -> ilk kullanım
/                       -> dashboard (alt menü)
/inventory              -> ürün listesi (alt menü)
/products/new           -> ürün ekle
/products/:id           -> ürün detay
/products/:id/edit      -> ürün düzenle
/urgent                 -> öncelikli tüketim
/recipes                -> tarifler (alt menü)
/recipes/:id            -> tarif detay
/statistics             -> istatistikler (alt menü)
/settings               -> ayarlar
/settings/notifications -> bildirim tercihleri
```
- `/products/new`, `/products/:id`'den önce kayıtlı olmalı veya eşleşmeler doğru tanımlanmalı.
- `product.id` kalıcı UUID'dir, listede sıra numarası değildir.
- `context.goNamed('foodDetail', pathParameters: {'id': item.id})`; route, ID'yi okuyup repository'den veriyi yükler; listede daha önce gösterilen Dart nesnesine zorunlu bağımlılık yoktur.
- Onboarding bitişinde flag'i **önce sakla**, router'ı invalidate/refresh et, ardından `go('/')` uygula; back stack ile onboarding'e dönülmesin.
- Router `redirect`: bootstrap tamamlanmadıysa splash; onboarding tamamlanmadıysa onboarding; tamamlandıysa ana akış. Sonsuz redirect oluşturma.
- Uygulama açılışında `AsyncValue` loading/error/data ayrımı; hata halinde bir animasyon göstermek mümkün ama animasyon hatayı gizleyemez; erişilebilir mesaj ve 'Tekrar dene' sağlanır.
- Route değişimlerinde unsaved form verisi varsa çıkış onayı.
- İleri navigasyonda `push`, ana sekmeye geçişte `go`/`StatefulShellRoute.indexedStack` kullan.

## 6. Veri modeli ve kalıcılık (VERİTABANI YOK)
- `FoodItem` domain entity; `FoodItemModel` JSON dönüştürücü. Alanlar: `id` (UUID), `name`, `category`, `storageLocation`, `quantity` (>0), `unit`, `dateType` (`use_by` / `best_before`), `dateValue` (`YYYY-MM-DD`), `estimatedPurchasePriceMinor` (nullable kuruş), `currency` (`TRY`), `notes`, `createdAt`, `updatedAt`, `status` (`active`, `consumed`, `wasted`).
- `ConsumptionEvent` ve `ConsumptionEventModel`: `id`, `foodItemId`, `eventType`, `quantity`, `estimatedValueMinor`, `occurredAt`; yinelenen olay ID'si kabul edilmez.
- `AppLocalStateModel`: `schemaVersion`, `foodItems`, `consumptionEvents`, `onboardingCompleted`, `notificationPreferences` alanlarına sahip tek JSON snapshot. Tek bir anahtarda (`freshtrack_state_v1`) saklanır. **Birden fazla bağımsız key ile tutarsız tüketim/ürün kayıtları oluşturma.** JSON dönüşümünde bozuk/eski şema için anlaşılır kurtarma/hata akışı hazırla; kullanıcı verisini sessizce sıfırlama.
- Repository arayüzleri domain'de, `FoodLocalDataSource`/`FoodRepositoryImpl` data'da; sadece data katmanı `SharedPreferencesAsync` görür. Bütün operasyonlar `Future` döndürür; `FoodRepository` üzerinden okunur/yazılır.
- Yazmaları tek seri kuyruk/mutex ile sırala. Snapshot'ı bellekte doğrula, kopya üzerinde güncelle, JSON yazma `Future` sonucunu bekle, **ancak bundan sonra** Riverpod state ve başarı mesajını güncelle. Başarısız yazmada önceki bellekteki state'i koru. `shared_preferences` gerçek ACID transaction veya kritik/veri garantisi sağlamaz; bu sınırlamayı README'de belirt. Uygulama içi yarış durumlarını engellemek, işletim sistemi veya depolama çökmesi için mutlak dayanıklılık anlamına gelmez.
- Silme ve kısmi tüketim için aynı JSON snapshot içinde hem `foodItems` hem `consumptionEvents` güncelle; negatif stok/çift istatistik sayımını engelle. Yedek JSON dosyası gerekiyorsa ancak açıkça ek gereksinimle yapılır.
- Ürün ID'si liste indeksi değildir. Detail route `/products/:id` her zaman repository üzerinden ID sorgusu yapar.
- `notificationPreferences`: saat, gün eşiği ve kullanıcı tercihi; gerçek izin durumu işletim sisteminden ayrıca okunur.
- Başlangıçta seed/demo ürünlerini gerçek kullanıcı verisiymiş gibi ekleme. İlk envanter boş başlasın.


`recipes`: ilk sürümde asset ya da kod ile gelen gerçek, test edilebilir yerel tarif kataloğu; `id`, `title`, `ingredient_names`, `instructions`, `estimated_minutes`. Eksik malzemeler hesaplanmalı, tarif varmış gibi davranılmamalı.

## 7. Tarih iş kuralları ve gıda güvenliği
Tarih farkını gün bazında `DateUtils.dateOnly` / calendar-day normalizasyonuyla hesapla: `daysRemaining = expirationDateOnly.difference(todayDateOnly).inDays` (yerel takvim günleri; DST uç durumlarını test et).
- `<0`: tarihi geçmiş → **Geçmiş** (kırmızı, uyarı).
- `0`: bugün → **Bugün** (kırmızı).
- `1..2`: **Acil** (kırmızı).
- `3..5`: **Yaklaşıyor** (sarı/turuncu).
- `>=6`: **Zaman var** (yeşil).
- Süt, et vb. için sadece tarih üzerinden **kesin güvenli** iddiası yok. 'Yeşil = tarihine 6+ gün var' yaz. Özellikle STT geçmiş ürünlerde tarif önerisi verme; TETT kalite tarihi olup STT ile karıştırılmamalı. Uygun saklama koşulları ve gıda güvenliği uyarısı göster.
- Bugün ve geçmiş ürünler renk filtrelerinden kaybolmamalı. Tarih bulunamayan/veri hatalı kayıt sessizce atlanmamalı.

## 8. Filtreleme algoritması
Tek kaynak listeden türetilen state: `InventoryFilter(query, categories, storageLocations, urgencyStatuses, consumptionStatuses, sortOrder)`.
- Metin araması trim + case-insensitive (Türkçe İ/ı dönüşümünü göz önüne al).
- Farklı filtre boyutları arasında AND, aynı boyuttaki çoklu seçimlerde OR.
- Varsayılan listede yalnız `active`, geçmiş tarihli aktif ürünler de görünür.
- Her seçimde derived provider yeniden hesaplar; repository kaynak listesini mutasyona uğratmaz.
- Sıfır sonuç boş durumunda 'Filtreleri temizle' butonu çalışır.
- Tarih eşiği geçince (gün değişince / foreground'a gelince) durumlar yenilenir; sadece kayda basıldığında hesaplamaya bağımlı kalma.

## 9. Kullanıcı akışları ve başarı/hata geri bildirimi
**Ekle:** Form doğrula → JSON snapshot kaydını başarıyla tamamla → bildirimleri planla (başarısız olursa kayıt yine korunur ve bildirim hatası açıkça gösterilir) → `SnackBar: Ürün eklendi` → ilgili sayfaya dön ve liste güncellenir.
**Düzenle:** ID ile yükle → değiştir → kaydet → veriyi yenile → `Ürün güncellendi`; hata durumunda veri kaybolmaz.
**Sil:** onay iste → tek snapshot içinde sil/ilişkili olayları tutarlı biçimde ele al → bildirimi iptal et → `Ürün silindi`; hata olursa dialog.
**Tükettim:** miktarı sor → tek snapshot güncellemesiyle azalt veya tamamını consumed yap → istatistiği güncelle → `Tüketim kaydedildi`.
**İsraf oldu:** aynı mantıkla wasted olayına kaydet; tasarruf hesabına ekleme.
**Bugün Pişir:** geçerli ürünlerle eşleşen tarifleri göster; tarif yoksa boş durum açıklaması + tarif kataloğuna git.
**Bildirim izni:** reddedilmişse kalıcı butonla sistem ayarlarına yönlendirme; sahte 'Açıldı' yazısı yok.
**Hatalar:** `AppFailure` ile validation/storage/notFound/permission/unexpected ayrımı; kullanıcıya Türkçe açıklama, gerektiğinde tekrar dene ve erişilebilir animasyon.

## 10. Tasarım sistemi ve Stitch AI
Tasarım hedefi: modern, sade, beyaz/soft gri yüzeyler, koyu okunabilir metin, küçük yeşil aksan. Tehlike kırmızı, yaklaşan sarı, tarihine zaman olan yeşil; durum ikon ve metinlerle de anlatılır. Material 3, 8/16/24 spacing, 48dp etkileşim hedefi, 3-5 kartlık yoğun olmayan ana ekran. Boş durum, hata, izin ve loading ekranlarının tamamı tasarlanmalı. Sistem font ölçeklendirmesi/dark mode dikkate alınmalı.

**Stitch AI prompt:**
> Design a minimalist, production-ready Turkish Flutter Material 3 mobile application called FreshTrack for food expiry tracking and waste prevention. Show cohesive mobile screens for onboarding, dashboard, refrigerator/pantry inventory, add/edit food item, food detail, urgent expiry list, filter bottom sheet, recipe suggestions, recipe detail, savings statistics and settings. White and warm-neutral backgrounds, subtle green brand accent, clear warning red/amber/green status chips with icons and text, rounded 16px cards, highly legible typography, accessible contrast, no clutter. Include realistic empty/loading/error/success states, action labels in Turkish, bottom navigation with Dashboard, Inventory, Recipes, Statistics. Make all actions implementable, do not show fake AI features or placeholders.

## 11. Test kabul kriterleri
- `flutter analyze` kritik hata vermiyor, `flutter test` geçiyor.
- Ekle/düzenle/sil ve durum güncellemeleri uygulama yeniden açıldığında korunuyor.
- Tarih testleri: dün, bugün, +1, +2, +3, +5, +6 gün; ay/yıl değişimi.
- Filtre AND/OR, arama, sıralama, temizleme testleri.
- Route: geçerli/geçersiz ID, onboarding yeniden açılmaması, redirect loop olmaması, geri navigasyon.
- Her etkileşim için success/failure/loading/empty durumlarının widget veya integration test'i.
- Bildirim izin reddi, güncellemede reschedule, silmede cancel akışları.
- Tarif önerileri gerçekten envanterle eşleşiyor ve tarihi geçmiş STT ürün kullanmıyor.
- İstatistikler fiyatı olan tüketilen ürünleri bir kez sayıyor, kısmi miktar ve israfı doğru ele alıyor.
- 'Yakında', boş tıklama handler'ı, işlevsiz navigasyon, sahte API cevabı ve production'da mock veriler yasak.

## 12. Takvim / teslim
1. **Tasarım ve iskelet:** Stitch tasarımı, theme, router, onboarding, DI ve yerel JSON şema sürümü/geri uyumluluğu.
2. **İşlevsel temel:** CRUD, ID route, filtreleme, renk durumları, bildirim.
3. **Fayda modülleri:** Tarif kataloğu, tüketim/israf işlemleri, istatistik ve testler.
4. **Final:** Erişilebilirlik, empty/error senaryoları, test raporu, README, demo senaryosu, ekran görüntüleri ve Android build.

## 13. Demo senaryosu
İlk açılış → onboarding → süt ürünü +2 gün ekle → kırmızı uyarıyı gör → kategori filtrele → kartın ID detayına git → düzenle → 'Bugün Pişir' ile tarife git → 'Tükettim' işaretle → tasarruf istatistiğini doğrula → uygulamayı yeniden aç, verinin saklandığını gör → geçersiz ID ekranını test et.

## 14. Veritabanısız geliştirme notu ve denetim matrisi
- **Model:** `FoodItemModel`, `ConsumptionEventModel`, `AppLocalStateModel`; saf domain entity ile JSON modelini ayır.
- **Controller:** `InventoryController` (Riverpod AsyncNotifier), `OnboardingController`, gerekirse tarif ve istatistik için ayrı controller/provider.
- **Views / screens:** dashboard, inventory, add/edit, detail, urgent, recipes, statistics, onboarding, settings. Görünür ekrandaki her kontrol gerçek handler'a bağlı.
- **Services:** bildirim, saat, local JSON source. Servisler iş kurallarını widget içine taşımaz.
- **Router:** bootstrap durumu, onboarding tamamlanması ve hatalara göre redirect; değişen state'te yeniden hesaplanır, ID route ile açılır.
- **Filtreler:** kategori + konum + SKT renk/aciliyet + durum + arama; tüm seçimler birleşir, sıfırlama ve boş sonuç ekranları çalışır.
- **Tasarım:** Stitch AI sadece tasarım referansı; Material 3 minimalist UI, kırmızı/sarı/yeşil + ikon + yazı; yalnız gerçek fonksiyonlar görünür.
- **Önceki farklı proje notları:** yönetici paneli, araç kilidi, yol yardım, NFC, kur, depo, kart tasarımı, 3D Secure, HGS, ödeme ve sürüş hakkı bu gıda projesiyle ilgili değildir ve uygulanmayacaktır. Yapay zekâ asistanı yalnız gerçek, güvenli entegrasyonla sonra; MVP'deki 'Bugün Pişir' offline çalışan tarif eşleştirmesidir.


---
## 15. Şef AI — referans ekranına göre yeni kapsam ve backend kararı (2026-10-22)
**Ekran referansı:** Kullanıcının paylaştığı mobil sohbet tasarımı. Önceki maddeler geçerli; bu bölüm Şef AI özelliği için ek/öncelikli gereksinimlerdir.

### Karar: iki çalışma modu, gerçekte çalışan işlevler
1. **Offline Akıllı Mutfak (backend GEREKMEZ):** Yerel ve açıkça *kural tabanlı* tarif eşleştirmesi, ürün risk özetleri, sabit eylem çipleri, tarif kartı, malzeme ayırma ve bugün pişir listesi. Kullanıcıya LLM sohbeti gibi davranıyormuş izlenimi verme. Serbest metin sadece desteklenen komutlar için çalışıyorsa sınırlarını açıkça göster; serbest sohbet vaadi verme.
2. **Şef AI serbest sohbeti (backend ÖNERİLİR):** Flutter HTTP istemcisi -> küçük **FastAPI** servis -> seçilmiş LLM API'si. Sunucu, servis API anahtarını environment/secrets içinde tutar. **Veritabanı yoktur**; envanter ve sohbet geçmişi cihazda SharedPreferences JSON'dadır. Sunucuya yalnız kullanıcının ilgili soru için izin verdiği asgari ürün alanları gönderilir; sohbet geçmişi sunucuda saklanmaz (harici sağlayıcının veri işleme şartları ayrıca değerlendirilir). API anahtarı, bearer secret, admin yetkisi asla Flutter'a gömülmez. Ağ/anahtar yokken gerçek AI modunu gizle veya çevrimdışı tarif modunu doğru etiketle; hiçbir zaman uydurma AI cevap verme.
3. Backend devreye alınana kadar üstteki Şef AI alanı, sohbet balonlarını taklit eden statik bir demo DEĞİL; çalışan **Akıllı Mutfak/Çevrimdışı Öneriler** ekranı olmalıdır. Backend hazırsa **Şef AI** adı ve serbest soru kutusu açılabilir.

### Görselin ayrıntılı bileşenleri
- Üst bar: geri/özet erişimi, bildirim sayacı (gerçek pending bildirimlerden), profil/ayarlar, çevrimdışı veya bağlı durum etiketi.
- Yardımcı başlık: "Şef AI / Akıllı Mutfak", **N ürün bağlı** sayısı repository'deki etkin envanterden hesaplanır, hardcoded `18` yasak.
- Güvenlik bandı: tarih geçmiş veya şüpheli kokan ürünleri tüketme; ayrıca STT/TETT farkını açıkla.
- Hızlı eylemler: **Bugün ne pişirebilirim?** ve **... nasıl hazırlanır?** gerçekten çalışan route, local engine veya ağ isteğine bağlanır.
- Sohbet mesajları: `messageId`, `role`, `createdAt`, `text`, `status`, opsiyonel `recipeId`; gönderim sırası korunur, klavye ve kaydırma düzgün çalışır. Kamera/mikrofon ikonları yalnız gerçekten uygulandığında ekranda görünür; izin ve hata durumları bulunur.
- Tarif görseli: yalnız lisanslı, paketlenmiş yerel asset veya izinli URL; placeholder gerçek fotoğraf gibi sunulmaz. Alternatif anlamlı görsel/ikon.
- Tarif kartı: başlık, süre, porsiyon, zorluk, bağlı ürünlerin UUID'leri, malzeme eşleşme durumu, son kullanma aciliyeti, adımlar ve gıda güvenliği bandı.
- Malzeme eşleşmesi: **mevcut, eksik, rezervli, son kullanma tarihi geçmiş** ayrı. `productId`, gerçek miktar/birim ve konumundan türetilir; "Tümü Mevcut" yalnız gerçekten tamamı mevcutsa gösterilir. Reçetedeki süt/krema gibi alternatifler gereklilikleri karşılamadan tamamlanmış sayılmaz.
- **Malzemeleri Ayır:** envanterdeki yeterli miktarı transaction benzeri atomik repository değişikliğiyle rezervler; ürünün mevcut stokunu hemen tüketmez; ikinci kez tıklamak iki kere rezervasyon yaratmaz; yetersiz stokta açıklayıcı hata verir. Ayırma geri alınabilir.
- **Bugün Pişir'e Ekle:** `plannedMealId` ile bugün listesine bir kez ekler; gün ve tarif bazında tekrarları engeller; kayıt başarılıysa buton/durum güncellenir. Silme/geri alma eylemi vardır.
- **Pişirdim/Tükettim:** kullanıcı onayıyla rezerve miktarı stoktan düşer, tüketim olayı/istatistik güncellenir; sadece tarif önerilmesi veya malzemenin ayrılması tasarruf sayılmaz.
- **Kritik saklama uyarısı:** sabit saat/ısı tavsiyelerini evrensel bilgi olarak sunma. Ekran referansındaki "tavuk akşam pişmiyorsa -18°C dondur" gibi uyarılar, gerçek saklama koşulları ve güvenilir gıda güvenliği kurallarına göre gözden geçirilir. Son tarihi geçmiş STT, şüpheli koku veya bozulma için tarif üretme. Eşleşme zaman çizelgesi cihaz saati test edilebilir servisle hesaplanır.
- Bottom navigation: Özet, Envanter, Bugün Pişir, İstatistik; aynı kart ve durumlardaki state uygulama genelinde güncellenir.

### Yeni route'lar
- `/chef` : akıllı mutfak/gerçek AI sohbet ana ekranı (desteklenen moda göre)
- `/recipes/:recipeId` : eşleşen tarifin gerçek detay sayfası
- `/today` : bugün pişir listesi
- `/products/:productId` : malzeme kartından ilişkili ürüne detay
- `/settings/assistant` : yalnız gerçek AI modu açıksa ağ/gizlilik izinleri
- Başlangıç akışı: native splash -> bootstrap -> onboarding tamamlanma kontrolü -> `/home`; route refresh yalnız ilgili state değişince tetiklenir, sonsuz redirect yoktur.

### Yeni domain/data modelleri
- `FoodProduct {id, name, quantity, unit, category, storageLocation, expiryType, expiryDate, price?, status}`
- `Recipe {id, title, imageAsset?, durationMinutes, servings, difficulty, ingredients: List<RecipeIngredient>, steps, safetyNotes}`
- `RecipeIngredient {ingredientKey, quantity, unit, optional, substituteKeys}`
- `IngredientMatch {recipeIngredientId, matchedProductIds, availableQuantity, requiredQuantity, status}`
- `IngredientReservation {id, recipeId, productId, quantity, createdAt, status}`
- `PlannedMeal {id, recipeId, localDate, servings, status, reservationIds}`
- `ChatMessage {id, role, body, createdAt, sendState, relatedRecipeId?}`
- `AssistantRequest {prompt, productContext, conversationContext}`; `AssistantResponse {reply, suggestedRecipeIds, warnings}`
- Tüm yerel modeller `schemaVersion` içeren snapshot olarak saklanır; bozuk JSON hatasında sessiz veri sıfırlama YASAK, kurtarma/uyarı göster.

### Clean Architecture modül ağacı (mevcut products vb. klasörlerine EKLE)
```text
lib/
  app/router/app_router.dart
  core/network/api_client.dart                 # sadece backend modu
  core/errors/app_failure.dart
  features/
    products/{domain,data,presentation}/
    recipes/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,providers,pages,widgets}/
    meal_planner/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,providers,pages,widgets}/
    chef_assistant/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/{controllers,providers,pages,widgets}/
    statistics/{domain,data,presentation}/
    notifications/{domain,data,presentation}/
    onboarding/{domain,data,presentation}/
  shared/widgets/
backend/                                   # sadece gerçek sohbet istenirse
  app/main.py
  app/api/routes/chef.py
  app/schemas/chef.py
  app/services/llm_service.py
  app/core/config.py
  tests/test_chef.py
  requirements.txt
  .env.example                             # anahtar DEĞİL örnek değişken adları
```
**Katman bağımlılıkları:** Presentation -> Domain; Data -> Domain; dış servis adapter'ı Data'dadır; doğrudan Widget içinden HTTP veya SharedPreferences çağrısı yasak. Controllers Riverpod Notifier/AsyncNotifier'dır. Domain saf Dart'tır.

### API sözleşmesi (yalnız backend modu)
`POST /v1/chef/respond`: istek `{message, inventory:[{id,name,quantity,unit,expiryType,expiryDate,storageLocation}], history:[{role,content}]}`; yanıt `{reply, recipeSuggestions:[{recipeId,reason}], safetyWarnings:[]}`. Sunucu şema doğrular, boyut sınırı uygular, timeout ve rate limiting yapar, hassas veriyi loglamaz, hata kodlarını düzenli döndürür. **LLM çıktılarını direkt envantere yazma.** RecipeId'ler ve ingredient match uygulamada yerel katalogla doğrulanır. Gerçek AI işlevi açılırsa sunucunun kötüye kullanımı sınırlanmalı (kimlik doğrulama veya başka uygun koruma) ve TLS kullanılmalıdır. Sağlık/gıda güvenliği kararları için deterministik doğrulama LLM'den bağımsızdır.

### Durumlar, testler ve tamamlanma tanımı
- `initial/loading/success/empty/error/offline/permissionDenied/retry`, mesaj gönderimi için `sending/sent/failed`.
- API kapalı, ağ kesik, kota, timeout, hatalı JSON, ürüne ait ID silinmiş, tarih değişmiş, iki kez tıklama, rezervasyon çakışması, geri alma, miktar yetersiz, eksik malzeme, expired STT testleri.
- Kullanıcı ürün eklediğinde bağlı sayı değişir; rezervasyon/planlama ekranı kapatılıp açıldığında korunur; başka ekranda silinen ürüne dönüşte not-found görünür; bugün listesi istatistikleri tüketim gerçekleşmeden artırmaz.
- Her buton gerçek işlem yapar; işlevsiz mikrofon/kamera, hayali admin ve yakın zamanda gibi yer tutucular görünmez. Backend yokken AI adı altında sabit yanıt akışı gösterilmez.

### Stitch AI arayüz brief'i
Referans görseldeki açık kırık beyaz arka plan, koyu yeşil ana CTA, yumuşak gri malzeme satırları, sarı uyarı alanı, yuvarlatılmış chat balonları, fotoğraflı tarif kartı, küçük aciliyet rozetleri ve dört sekmeli alt menü örnek alınır. Renk yanında açık etiket/ikon kullan; erişilebilir kontrast ve text scaling. Kartlardaki dinamik metrikler uydurulmaz. Türkçe tipografi ve yükleme/boş/hata sahneleri tasarlanır.


## 16. Gıda Bağışı & Paylaşım — ikinci referans ekran (2026-10-22)

### Ürün/ekran kararı
Ekrandaki “Gıda Bağışı & Paylaşım” FreshTrack’in ayrı bir feature'ıdır (`features/donations`). Mevcut SKT, tarif, Şef AI, ürün CRUD, onboarding ve istatistik fonksiyonları korunur. Veritabanı yok; SharedPreferences/JSON ile cihaz içinde taslak paket, ayrılan ürünler, yerel teslim geçmişi ve izinler saklanır. **Yerel kayıt, gerçek kuruluşa bağış gönderildiği veya mahallede ilan yayımlandığı anlamına gelmez.** Böyle eylemler yalnızca gerçek bir API/servis entegrasyonu ve doğrulama mekanizması kurulduktan sonra aktifleştirilir.

### Görseldeki alanların gereksinimleri
- Üstte FreshTrack başlığı, profil, bildirim; “Yerel Dayanışma” vurgusu ve bilgilendirme kutusu.
- Mahalle istatistiği yalnızca gerçek servis verisi varsa gösterilir. “42 kg / 14 hane” gibi sahte sayılar sabit metin olarak sunulamaz; aksi hâlde bu kart kaldırılır veya gerçek **kişisel yerel** istatistikler açıkça etiketlenerek kullanılır.
- “Bağışa Uygun Ürünlerin” listesi envanterden türetilir; “Tümünü Gör” ürünleri filtrelenmiş sayfada açar, her ürün benzersiz ID taşır.
- Güvenlik alanındaki 'yalnızca ambalajı açılmamış, soğuk zinciri bozulmamış ve STT süresi dolmamış' ifadesi **bu uygulamanın ihtiyatlı MVP kabul kuralıdır**; mevzuata veya tüm kurumların kabul kriterlerine dair garanti değildir.
- Ürün kartında ad, miktar/birim, konum, raf ömrü, paket durumu ve uyarı; “Pakete Ekle” gerçek bir donation draft'ına yazar, eklenmişse “Paketten Çıkar”a döner, stok miktarından fazla seçim engellenir.
- “Kış Dayanışması Erzak Paketi” özeti yalnızca seçilen gerçek ürünleri listeler; “Tamamla” doğrulama ekranına gider, gönderim varmış gibi göstermez.
- “Yakındaki Doğrulanmış Noktalar” için kurumsal kaynak veya kullanıcı tarafından doğrulanmış yönetilen katalog gerekir. Kaynak yoksa doğrulanmış nokta, ‘şu an açık’, kapanış saati, 1.2 km, 7/24 veya harita pini uydurulmaz. 'Konuma Git' ancak geçerli koordinat/adres bulunuyorsa harita uygulamasını açar; 'Kurye Teslimi' yalnızca gerçek sağlayıcı varsa çalışır, yoksa UI'da yer almaz.
- “Gıda Kurtarma Ağı / Talep Et” yalnızca gerçek yetkili kuruluş entegrasyonu varsa gösterilir.
- Alt ‘Yeni Bağış Paketi / İlanı Oluştur’ butonu tam çalışan yerel taslak oluşturma formunu açar. ‘İlanı yayımla’ aksiyonu ancak gerçek backend varsa görünür.
- “Geçmiş Bağışlarım ve Etki Sertifikalarım” yalnızca kullanıcının kanıtlı teslimlerini gösterir; yerel taslakları gerçek bağış veya sertifika diye saymaz. Sertifikalar sadece doğrulayan sistemden gelir. Taslak geçmişi ayrı gösterilebilir.
- Alt sekmeler (Özet, Envanter, Bugün Pişir, İstatistik) GoRouter ShellRoute ile korunur. Bağış ekranına Özet içindeki görünür çalışan bir kart/aksiyon ya da bağlama uygun bir sekme-altı rota ile erişilir.

### Domain modelleri
- `DonationDraft(id, createdAt, updatedAt, status, lines, optionalNote)`
- `DonationLine(productId, quantity, unit)`; fiziksel uygunluk `Product` verisinden yeniden hesaplanır; ürün adı/son tarih eski kopya üzerinden karar verilmez.
- `DonationStatus { draft, reserved, submitted, accepted, handedOver, cancelled }` — `submitted`, `accepted`, `handedOver` durumlarına **gerçek servis onayı veya doğrulanmış manuel kanıt olmadan** geçilemez; ilk aşamada yalnızca `draft`, `reserved`, `cancelled` desteklenir.
- `DonationEligibility(isEligible, reasons)` saf use case sonucudur. Açık ambalaj, güvenilmeyen sıcaklık geçmişi, tarihi geçen STT, belirsiz ürün güvenliği, hasar/sızıntı gibi durumlarda `false`. TETT geçmiş ürün otomatik uygun sayılmaz; kurum politikasına göre ayrıca doğrulama gerekir.
- `DonationPoint(id, name, address, coordinates, acceptedCategories, verificationSource, lastVerifiedAt, openingHours, contact)` — boş veya doğrulanmamış nokta kullanıcıya doğrulanmış olarak sunulmaz.
- `DonationReceipt(id, draftId, organizationId, deliveredAt, proofRef, confirmed)`; etki tahmini ve sertifika ile karıştırılmaz.
- Para/kg tasarrufu ile bağış miktarı istatistikleri farklı kategorilerdir; aynı ürün iki kere tasarrufa eklenmez.

### Modül yapısı
```text
lib/features/donations/
  data/
    models/{donation_draft_model,donation_point_model}.dart
    datasources/donation_local_datasource.dart
    repositories/donation_repository_impl.dart
  domain/
    entities/{donation_draft,donation_line,donation_eligibility,donation_point,donation_receipt}.dart
    repositories/donation_repository.dart
    usecases/{get_eligible_products,create_donation_draft,add_donation_line,remove_donation_line,validate_donation_draft,reserve_donation_items,load_donation_history}.dart
  presentation/
    controllers/donation_controller.dart
    providers/donation_providers.dart
    pages/{donation_hub_page,eligible_products_page,donation_draft_page,donation_history_page}.dart
    widgets/{donation_product_card,donation_package_card,donation_point_card,donation_safety_banner}.dart
```
Gerçek paylaşım/partner API'si eklenirse ayrı `remote_datasource` ve backend sözleşmesi tanımlanır; yerel taslak repository'si korunur. Yetki bazlı sorgular/sahiplik doğrulamaları sunucuda yapılır. Gerçek eşler arası paylaşım için auth, moderasyon, görünürlük izinleri, kötüye kullanım önlemleri, konum gizliliği ve operasyonel kurum doğrulaması gerekir; yalnızca SharedPreferences bunları yapamaz.

### Routing ve akışlar
```text
/donations                         -> donation_hub_page
/donations/eligible                -> eligible_products_page
/donations/drafts/new              -> donation_draft_page (yeni)
/donations/drafts/:draftId         -> donation_draft_page (kalıcı ID)
/donations/history                 -> donation_history_page
/donations/points/:pointId         -> yalnız doğrulanmış katalog/entegrasyon hazırsa
```
GoRouter `pathParameters` ile `draftId`, `pointId` okunur; controller repository'den ID ile bulur. Bulunamayan ID -> özel bulunamadı durumu ve geri dön butonu. Route üzerindeki ID ürünün değil bağış taslağının ID'sidir; `DonationLine.productId` ürün kimliğini tutar. Onboarding redirect ve auth/servis hazır olma durumu geriye dönük bozulmayacak.

### İş kuralları / atomiklik
1. Seçilebilir stok = fiziksel miktar - diğer aktif rezervasyonlar; negatif olamaz.
2. 'Pakete Ekle' öncesinde ürünün en güncel kaydı yeniden okunur, gıda uygunluğu ve miktar doğrulanır.
3. Paket düzenleme / silme / ürün tüketme yarışında birleştirilmiş tek controller işlemi ile stok rezervasyonu tutarlı kalır; kalıcı JSON yazma hatasında UI başarı demez.
4. Bağış taslağı oluşturmak stoktan ürünü **kalıcı olarak düşmez**. Gerçek teslim doğrulanınca uygun stok hareketi yazılır. Rezervasyon stok hesaplamasında dikkate alınır.
5. Teslim edilmemiş ürünler 'bağışlandı' istatistiğine girmez. Kullanıcı yalnızca yaptığı manuel kaydı görür; gerçek teyit gerektiren etki/sertifika sunulmaz.
6. STT geçmiş, bozulmuş veya güvenliği şüpheli ürün tarifte de bağışta da önerilmez. Uyarı gösterilir.
7. Gizlilik: kesin konum izni isteğe bağlı ve amaca uygun; izin reddinde uygulama çalışmaya devam eder, konum veya kimlik bilgisi paylaşılmaz.

### Buton / durum kabul matrisi
| Kontrol | Gerçek eylem | Geri bildirim |
|---|---|---|
| Tümünü Gör | uygun ürün filtreli listesi | boş liste + neden |
| Pakete Ekle | eligibility + stok kontrolü + kalıcı yazma | loading/success/error, buton durumu değişir |
| Paketten Çıkar | taslaktan çıkar, rezervasyon çöz | success/error |
| Tamamla | taslağı doğrula, yerel rezervasyon kaydet | eksik/güvensiz ürün gerekçeleri |
| Yeni Bağış Paketi | taslak oluştur ve ID ile route et | success/error |
| Geçmiş | gerçek kayıt ve taslakları farklı göster | empty/retry |
| Konuma Git | yalnız gerçek adres ve kullanıcı eylemi ile maps aç | izin/app bulunamadı açıklaması |
| Kurye Teslimi / Talep Et | yalnız entegre servis varsa görünür | servis onayı veya hata |
| Soru işareti | bağış kuralları bilgi diyaloğu | aç/kapat erişilebilir |

### Testler
`DonationEligibility` STT, TETT, açılmış ambalaj, soğuk zincir belirsizliği, miktar ve kategori durumları; aynı ürünü iki pakete fazla ekleme; ID ile route; taslak JSON round-trip; rezervasyon ve envanter senkronizasyonu; ürün silinince bağış satırı için hata; empty/loading/error/success; gerçek nokta veya servis yokken yanıltıcı kartların görünmemesi; yerel taslağın “teslim edildi” sayılmaması test edilir.

### Stitch AI tasarım talimatı
Ekli ikinci referanstaki pastel yeşil/nötr beyaz kartları, rounded köşeleri, kırmızı-turuncu-yeşil durumlarını, liste ve eylem hiyerarşisini temel al. Ancak görseldeki örnek gerçek olmayan mahalle istatistiklerini, merkezleri, teslimat haklarını, sertifikaları, tarih/saat/mesafe bilgilerini ürün verisi gibi kopyalama. Erişilebilir kontrast, Türkçe metin, tüm ekran boyutlarında taşma kontrolü ve tek dokunuşla anlaşılır sonuç şarttır.
