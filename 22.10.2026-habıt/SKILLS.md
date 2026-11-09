# FreshTrack — SKILLS.md

Bu dosya FreshTrack üzerinde çalışan geliştirici veya AI coding agent için zorunlu yetkinlikleri ve uygulama örüntülerini açıklar. `PROJECT.md` ürün gereksinimlerini, `AGENTS.md` iş yapma prosedürünü belirler.

## Skill 1 — Flutter / Dart temel disiplini
- Dart null safety, `final` / `const`, enum, `Future`, `Stream`, `async` / `await`, exception yönetimi.
- Widget'ları UI odaklı, küçük, yeniden kullanılabilir kur; domain iş kurallarını `build()` içine yazma.
- Fonksiyonları ayrı Dart dosyalarında tut, kullanan dosyada `import` et; UI'ye kalıcı veri erişimi veya JSON serileştirmesi gömme.
- Async işlemlerden sonra `context.mounted` kontrolü; iki kere tıklamayı loading sırasında engelle.
- Controller, subscription ve kaynakları doğru dispose et.

## Skill 2 — Clean Architecture uygulaması
- Presentation: Screen + Riverpod notifier/provider + UI state.
- Domain: Entity, abstract repository contract, use case, filtre ve SKT kuralları; Flutter'a bağımlı değil.
- Data: SharedPreferencesAsync tabanlı JSON datasource, model/mapper, repository implementation, exception dönüşümü.
- Bağımlılık yönü `presentation -> domain <- data`; implementation DI üzerinden sunulur.
- Bir yerde değişen veri, ilgili provider'ları invalidate ederek veya repository kaynaklı state bildirimi ile tüm ekranlara yansır.

## Skill 3 — GoRouter / akıllı navigasyon
- Tek `app_router.dart`, `route_names.dart`; nested tab route için uygun shell route.
- Native splash yalnız OS açılış görseli; async initialization için Flutter bootstrap/loading durumunu ayrı yönet.
- İlk yönlendirmede onboarding tercihi okunmadan karara varma.
- Onboarding tamamlandığında veri kalıcı kaydedilir, redirect tekrar değerlendirilir.
- Ürün route parametresi ID olmalı: `/products/:id`, `/products/:id/edit`.
- `go` kalıcı bölüm değiştirme, `push` detay akışı için; geri yığınını düşün.
- Geçersiz ID → not found; init başarısız → hatayı açıklayan retry; loading animasyonu hatayı saklamaz.

### Route örneği (uyarlama iskeleti)
```dart
GoRoute(
  name: 'foodDetail',
  path: '/products/:id',
  builder: (context, state) => FoodDetailScreen(
    foodId: state.pathParameters['id']!,
  ),
);

// Kart içinde:
context.pushNamed(
  'foodDetail',
  pathParameters: {'id': item.id},
);
```
Bu kod ürünün bulunduğunu varsaymaz; detay provider'ı ID ile yerel repository kaydını ID ile sorgulamalıdır.

## Skill 4 — Riverpod ve reaktif state
- Tek doğru veri kaynağı repository / JSON snapshot.
- `AsyncValue` ile loading/error/data; `AsyncValue.guard()` uygun işlemlerde.
- Çoklu filtre için immutable `InventoryFilter` state'i ve derived provider kullan.
- Ürün değişiminde liste, dashboard ve istatistik state'leri reaktif yenilensin.
- Başarı gösterimi yalnız kalıcı JSON yazımı tamamlandıktan sonra yapılır.

## Skill 5 — Filtreleme ve SKT statüsü
- Durum hesaplama saf fonksiyon: `DateStatus classifyDate(DateTime today, DateTime target)`.
- Tarihi geçmiş, bugün, 1-2, 3-5, 6+ gün sınıfları için sınır testleri.
- Farklı kriterler AND, aynı kriterin seçili seçenekleri OR.
- Normalizasyonla arama, aralıkla filtre, deterministic sıralama.
- 'Güvenli' kelimesini tarih sınıfı için kesin iddia olarak kullanma; ürünü saklama ve görünüş/koku vb. gıda güvenliği kurallarıyla ayrı düşün.

### Örnek saf filtre işlevi
```dart
List<FoodItem> filterItems(
  List<FoodItem> items,
  InventoryFilter filter,
  DateTime today,
) {
  final query = filter.query.trim().toLowerCase();
  final matches = items.where((item) {
    final byName = query.isEmpty || item.name.toLowerCase().contains(query);
    final byCategory = filter.categories.isEmpty ||
        filter.categories.contains(item.category);
    final byLocation = filter.locations.isEmpty ||
        filter.locations.contains(item.storageLocation);
    final byUrgency = filter.urgencies.isEmpty ||
        filter.urgencies.contains(classifyDate(today, item.expiryDate));
    final byStatus = filter.statuses.isEmpty ||
        filter.statuses.contains(item.status);
    return byName && byCategory && byLocation && byUrgency && byStatus;
  }).toList();
  // Burada seçili sortOrder'a göre deterministic sıralama yap.
  return matches;
}
```
Not: Bu algoritma kılavuz iskelettir, `FoodItem` ve `InventoryFilter` tipleri domain'de tanımlanıp üretim için tamamlanacaktır. Türkçe büyük/küçük harf normalizasyonu ayrıca uygulanacaktır.

## Skill 6 — Veritabanısız JSON kalıcılık ve veri tutarlılığı
- `shared_preferences` paketindeki `SharedPreferencesAsync` (uyumlu sürüm) ile tek `freshtrack_state_v1` JSON snapshot anahtarı kullan. `dart:convert` JSON encode/decode, modellerde `toJson/fromJson`, null-safe mapping ve `schemaVersion` zorunlu.
- CRUD yazmalarını seri sıraya koy: güncel state'i oku → kopya üret → giriş doğrula → tüm ürün ve tüketim olaylarını tek snapshot'ta değiştir → `await setString(...)` → başarılıysa state'i yayınla. Bu **gerçek veritabanı transaction'ı değildir**; kritik veriler için SharedPreferences garanti vermez.
- Yanlış JSON, eski sürüm, yazma hatası ve birden fazla hızlı tıklamada çakışma senaryolarını ele al; veriyi sessizce silme veya sahte başarı gösterme.
- UUID benzersizdir; tüketim/israf olayları tek sefer sayılır, stok eksiye düşemez. Fiyat kuruş integer, istatistikler olaylardan hesaplanır.
- Küçük eğitim projesi için uygundur; veri hacmi/önemi artarsa ayrı bir veritabanına geçiş planlanır. SQL/SQLite/Drift/Firebase kullanma.

## Skill 7 — Tarif önerisi / yapay zekâ sınırları
- MVP öneri algoritması deterministik, offline çalışır: aktif, tarihi geçmemiş STT ürünleri normalize et; tarif malzemeleriyle eşleştir; eşleşme oranına göre sırala; eksikleri yaz.
- Tarifi gerçekten aç, adımlarını göster; uygunsuz ürünü önerme.
- AI özelliği ancak gerçek backend ve güvenli kimlik/doğrulama ile açılır; cihaz uygulamasına LLM servis anahtarı koyma.
- Model önerilerini gıda güvenliği kararı olarak sunma.

## Skill 8 — Bildirimler ve platform özellikleri
- Kullanıcının bildirim iznini doğrula, izin yoksa açıkça anlat.
- Planlanan bildirimleri benzersiz kimlikle eşleştir; ürün güncellenince değiştir, silinince iptal et.
- Platform saat dilimi/izin ve yeniden başlatma durumları test edilmeli.
- Native splash konfigürasyonu gerçek cihazda doğrulanmalı.

## Skill 9 — Hata, başarı ve erişilebilirlik
- Validation error: form alanına özel hata.
- Storage error: işlem başarısız, eski veri korunur, tekrar deneme.
- Not found: kullanıcının listesine dönme eylemi.
- Empty state: 'Ürün ekle' / 'Filtreleri temizle' eylemleri.
- Success: yalnız `await` ile başarılı kalıcı JSON yazımı sonrasında snackbar, gerekirse undo.
- Renk tek gösterge olamaz: kırmızı/sarı/yeşil durumlarda ikon + açıklama.
- Animasyon destekleyici olabilir, hatayı gizleyemez.

## Skill 10 — Test, kalite ve teslim
- Her use case için unit test; JSON datasource/repository için integration/fake test; etkileşimli ekranlar için widget test.
- Minimum kritik uçtan uca demo akışını otomatik veya manuel kanıtla.
- `dart format .`, `flutter analyze`, `flutter test` ve mümkünse Android cihaz/emülatörde çalıştır.
- Testi çalıştırmadan 'test edildi' deme.
- Başarısız veya uygulanmamış özelliği gizleme; bunun yerine tamamla ya da üretim arayüzünden çıkar.

## UI Tasarım disiplini (Stitch)
- Ekranlar tutarlı spacing/renk/type token'ları kullanır.
- Önce wireframe, sonra bileşen haritası, sonra Flutter widget; Stitch çıktısı doğrudan çalışan kod varsayılmaz.
- Bütün ekran durumlarının tasarımını iste: loading, empty, error, success, dialog, permission denied.
- Minimal, Material 3, Türkçe, erişilebilir; dashboard'da kırmızı/sarı/yeşil kritik bilgi ve tek birincil CTA.

## Skill 11 — Controllers / models / views / imports
- Her feature için presentation `controllers/`, `providers/`, `pages/` veya `screens/`, `widgets/` düzenini açık tut. Gerekmeyen klasörü boş dosyalarla doldurma.
- Dart fonksiyonlarını uygun `domain/usecases` veya `core/utils` modülünde tanımla; sınıfları gerekli ekran/controller dosyalarına `import` et. Döngüsel import oluşturma.
- JSON encode/decode `data/models` ve `data/datasources` içinde; UI ekranında `SharedPreferences` çağrısı yapma.
- Örnek akış: AddFoodPage → InventoryController.addFood() → AddFoodUseCase → FoodRepository → FoodRepositoryImpl → SharedPreferencesFoodDataSource → JSON yazımı → state güncellemesi → başarılı/başarısız geri bildirim.


## Skill 12 — Şef AI ekranı, kural tabanlı eşleme ve isteğe bağlı backend
- Referans ekranını Flutter widget ağacına ayır: `ChefHeader`, `PantryConnectionChip`, `SafetyBanner`, `QuickPromptChip`, `ChatBubble`, `RecipeRecommendationCard`, `IngredientMatchList`, `ReservationButton`, `AddToTodayButton`, `StorageWarning`, `ChefComposer`.
- Bileşenler sadece sunumdur; controller/provider bağımlılıkları widget içinden ilgili uygulama arayüzüne geçer. Her widget bir dosyada veya mantıklı küçük grupta bulunur, Dart import ile yeniden kullanılır.
- Asistan gerçek LLM'e bağlanmamışsa **Akıllı Mutfak** olarak adlandır ve kural tabanlı tarif önerisini sun. Serbest metin sohbet kutusu sadece gerçek konuşma işliyorsa açık; görünürde AI simülasyonu YASAK.
- Eşleştirme: normalize edilmiş malzeme anahtarı + alternatifler + miktar ve birim dönüştürme + rezervli stok düşümü + STT kontrolü. Salt ürün adına bakıp `Tümü Mevcut` verme.
- `reserveIngredients` async ve tek-işlem semantiğinde: önce stok uygunluğu/duplikasyon kontrolü, sonra bir bütün snapshot yaz, başarılı yazımda state'i yayımla. `addMealToToday` idempotent; `consumeMeal` onayla ve olay kaydından tasarruf üret.
- Assistant interface: `ChefAssistantRepository`, `OfflineRecipeAssistantRepository`, `RemoteChefAssistantRepository`. DI'da aktif moda göre implementation seç. Offline motor için saf use case; uzak API için `http` veya `dio` adapter, timeout ve typed failure.
- Backend opsiyonel: FastAPI `/v1/chef/respond`; yalnız sunucunun environment'ından LLM anahtarı; `.env` / secrets git'e girmez. Flutter'da sağlayıcı API key'i asla saklama. Veri minimizasyonu, açık kullanıcı tercihi, TLS ve request validation. Backend veritabanı gerektirmez.
- Yanıtlar sadece gösterim veya öneridir, stok otomatik değiştirmez; sahte tarih/saklama garantisi vermez. Gıda güvenliği kural katmanı LLM önünde/sonrasında bağımsız çalışır.
- Mesaj ve kart loading, empty, error, retry, offline, success durumlarını test et; snapshot schema migration/backward compatibility düşün.
- Router: `context.pushNamed('recipeDetail', pathParameters: {'recipeId': recipe.id})`; ürün linki benzersiz ID; route guard/redirect onboarding state'i değişince tazelenir.
- Hataları `Result<T>`/typed Failure veya AsyncValue ile yönet; loading'de tekrar gönderim/çift rezervasyonu engelle. Snackbar yalnız gerçekten başarılı write'dan sonra.
- `flutter analyze`, `flutter test`; ayrıca backend varsa `pytest` ve API sözleşmesi testleri yapılmadan tamamlandı denmez.

### Dart modülleri için bağlantı örneği
```dart
// widgets içinde iş kuralı hesaplama yerine controller metodunu çağır:
await ref.read(mealPlanControllerProvider.notifier)
    .addRecipeForToday(recipeId: recipe.id);
// GoRouter ürün ID'sini taşır:
context.pushNamed('productDetail', pathParameters: {'productId': product.id});
```
`mealPlanControllerProvider` proje içinde gerçekten tanımlanır; salt örnek adına bırakılmaz.


## Skill 13 — Gıda bağışı feature'ı / domain ve servis sınırları
- `DonationDraft`, `DonationLine`, `DonationEligibility`, `DonationPoint`, `DonationReceipt` domain entity; JSON serializer data modeldir. UI widget domain doğrulaması yapmaz.
- `DonationController` Riverpod `AsyncNotifier` üzerinden create/add/remove/validate/reserve işlemlerini çağırır. Tüm olaylar loading/data/error durumuna yansır; başarı yalnızca persist tamamlanınca bildirilir.
- `DonationRepository` domain arayüzü, `DonationRepositoryImpl` SharedPreferences + JSON `DonationLocalDataSource` üzerine kurulur. Kalıcılık için schemaVersion, bozuk JSON fallback + kullanıcı uyarısı, migration ve atomik duruma yakın tutarlı write yaklaşımı uygula.
- Ürün değiştiğinde donation providers invalidate/recompute edilir. Bağımsız ekranlar kopya ürün listesi tutmaz; `productId` üzerinden repository'den güncel nesne alınır.
- `GetEligibleProducts` ile `ValidateDonationDraft` saf Dart olarak test edilebilir. Açılmış paket, tarih geçmiş STT, güvenliği şüpheli ürün, bilinmeyen soğuk zincir, yetersiz miktar kabul edilmez. Bu kriterleri kurumun resmi mevzuatı diye pazarlama; proje içi güvenli kabul politikasıdır.
- Paket seçiminde miktar ve birimi tutarlı değerlendir; aynı üründen birden fazla satırın stok üstüne çıkmasını engelle; SharedPreferences transaction sağlamadığı için tek yazıcı/serial queue ile eşzamanlı işlemleri sırala ve geri yükleme stratejisi kur.
- Harita: `url_launcher` ile sadece gerçek koordinat/harita bağlantısı; konum izni olmadan merkez listesi mümkünse adres bazlı çalışır. Mesafe ancak gerçek koordinatlardan hesaplanır; açıklamasız 'Şu an açık' yok.
- Kaynak bulunmayan doğrulanmış merkez, kurye, halka açık ilan, sertifika veya mahalle istatistiği üretme. Gerçek ağ paylaşımı ve yetkilendirme için backend şarttır; offline-local paket taslağına backend gerekmez.
- Route örneği `context.go('/donations/drafts/${draft.id}')`; ekran `state.pathParameters['draftId']` ile okur, repository ID ile yükler; geçersiz ID için not-found.
- `DonationStatus` üzerinde gerçek entegrasyon onayı yokken delivered/accepted kullanılmaz. Yerel ürün rezervasyonu gerçek teslim diye gösterilmez.
- Örnek testler: eligibility decision table, over-reservation, stale-product handling, saved-draft reload, duplicate taps, failure-retry, screenshot/UI and navigation tests.
