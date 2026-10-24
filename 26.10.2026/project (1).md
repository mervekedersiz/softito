# NutriWallet — PROJECT.md

> **Proje:** Beslenme & Gıda Bütçesi Takibi  
> **Grup:** Merve, Adil  
> **Platform:** Flutter (Android öncelikli; iOS uyumlu tasarım)  
> **Durum:** Mimari ve uygulama kapsamı — MVP  
> **Kapsam kuralı:** Bu belge yalnızca aşağıda tanımlanan NutriWallet özelliklerini içerir. Önceden konuşulan akıllı buzdolabı, bahçe, ödül sistemi vb. özellikler kapsam dışıdır.

## 1. Proje özeti ve amacı

NutriWallet, kullanıcının **beslenme kayıtlarını** (kalori ve tahmini makrolar) ve **gıda harcamalarını** (TL) aynı mobil uygulamada takip etmesini sağlar. Temel soru: **“Sağlıklı beslenirken bütçemi nasıl yönetirim?”**

Uygulama için özel bir backend sunucusu **zorunlu değildir**. Kullanıcının öğünleri, harcamaları, hedefleri ve alışveriş listesi cihazdaki yerel veritabanında tutulur. İlk gösterim için malzeme içerikleri, besin değerleri ve fiyatlar **yerel JSON demo veri seti** ile sağlanır. Sohbet/tarif önerisi bileşeni için **Hugging Face üzerinde sunulan bir Qwen modeli** hedeflenir; ücretsiz erişim, kota, kimlik doğrulama ve model kullanılabilirliği uygulama aşamasında doğrulanmalıdır. Erişim olmadığında demo, önceden tanımlı JSON tarif/yanıtlarıyla çalışır. Bu belgede canlı API entegrasyonu veya gerçek fiyat API'si uygulanmaz; veri şemaları daha sonra `data.md` içinde tanımlanacaktır.

### 1.1 Hedefler
- Tek form üzerinden öğün ve ilgili harcamayı kaydetmek.
- Günlük kalori/protein ve aylık harcama/kalan bütçe özetlerini göstermek.
- Ay sonuna kalan bütçeden önerilen günlük limiti hesaplamak.
- Harcama kategorilerini ve beslenme trendlerini grafikle göstermek.
- Kullanıcının malzeme ve bütçe girdisine göre demo tarif önerisi sunmak.
- Eksik malzemeleri alışveriş listesine aktarabilmek.
- Her butonun gerçek ve test edilebilir bir davranışı olmasını sağlamak.

### 1.2 Kapsam dışı
- Kullanıcılar arası sosyal ağ, puan/rozet, dijital bahçe, barkod tarama, stok/SKT takibi.
- Gerçek zamanlı market fiyatı garantisi, ödeme sistemi, bulut senkronizasyonu.
- Merkezi kullanıcı yönetimi veya yönetici paneli.
- Tıbbi tanı, tedavi veya kesin hastalığa uygun diyet önerisi.

## 2. MVP özellikleri ve iş kuralları

### 2.1 Dashboard (`HomeView`)
- Kartlar: **bugünkü kalori**, **bugünkü tahmini protein**, **bu ay toplam harcama**, **kalan aylık bütçe**.
- Bütçe ilerleme çubuğu: `harcanan / aylık hedef` (görsel oran 0–100% arasında sınırlandırılır; aşım ayrıca metinle gösterilir).
- Günün son öğünleri; tarih, öğün adı, kalori ve TL bilgisi.
- Hızlı ekle FAB → kayıt formu.
- Kalori/protein kartı → beslenme analizi; harcama/bütçe kartı → bütçe analizi.
- Veri yoksa boş durum ve **İlk Kaydını Ekle** aksiyonu.

### 2.2 Tekil öğün ve harcama formu (`AddEntryView`)
- Alanlar: yemek adı, tarih/saat, öğün türü (kahvaltı/öğle/akşam/ara öğün), yaklaşık kalori, protein/karbonhidrat/yağ (opsiyonel), TL tutarı, harcama kategorisi.
- Kullanıcı kategorileri: **Dışarıdan Söyledim**, **Evde Pişirdim**, **Market Alışverişi**.
- `Market Alışverişi` bir **harcama** kaydıdır; tüketilmiş öğün sayılmaz ve kalorilere eklenmez. Form kategoriye göre uygun alanları gösterir.
- `Evde Pişirdim` kaydındaki TL değeri, kullanıcı tarafından belirtilen **öğüne atfedilen maliyet** olarak yorumlanır. Aynı alışveriş gideri ayrıca market kaydı olarak tutuluyorsa **toplam nakit harcamaya tekrar eklenmez**; kayıt modelinde `expenseImpact` / `isBudgetExpense` ayrımı uygulanır.
- Başarılı kayıt → kalıcı veritabanına yaz → başarı bildirimi → önceki ekrana dön → özetler yenilenir.
- Geçersiz alan → alan altı hata; veritabanı hatası → açıklayıcı hata + yeniden dene. Çift tıklama ile mükerrer kayıt engellenir.
- Kayıt düzenleme ve silme: kimlik bazlı; silme için onay diyaloğu.

### 2.3 “Ay Sonuna Kadar Hayatta Kal” bütçe simülatörü
- Profilde aylık TL bütçesi belirlenir.
- `kalanBütçe = aylıkBütçe − buAyınGerçekGiderleri`.
- `kalanGün = bugünden ay sonuna kadar, bugün dahil gün sayısı`.
- `günlükÖneri = max(0, kalanBütçe) / kalanGün`.
- Kullanıcı deneme harcaması `x` girerse, simülasyon mevcut kayıtları değiştirmez: `yeniKalan = kalanBütçe − x`.
- “Yarınki limit” hesaplanırken yarından ay sonuna kadar kalan gün sayısı kullanılır; ayın son gününde yarın için limit gösterilmez.
- Bütçe aşıldığında negatif kalan tutar açıkça gösterilir; günlük öneri 0 TL olur.
- Alışveriş listesinde işaretlenen ürünlerin **tahmini fiyat toplamı** bütçeyi aşarsa görsel ve metinsel uyarı verilir.
- Simülasyondaki tutar gerçek harcamaya ancak kullanıcı ayrıca bir kayıt oluşturup kaydederse eklenir.

### 2.4 Demo asistan ve tarif önerisi (`AIAssistantView`)
- Kullanıcı malzemeleri, mevcut günlük bütçesini ve isteğe bağlı beslenme tercihlerini girer.
- Asistan, tarif adı, malzeme listesi, hazırlama adımları, **tahmini** porsiyon maliyeti ve **tahmini** kalori/makroları gösterir.
- Öncelikli demo veri kaynağı: `assets/data/*.json` ve deterministik tarif eşleştirme.
- Gelecekteki sağlayıcı: Hugging Face üzerinde Qwen; `AssistantRepository` arayüzü arkasında opsiyonel `HuggingFaceQwenDataSource`. Model sürümü, ücretsiz kota ve erişim biçimi sabit varsayılmaz.
- Canlı model kapalı/ulaşılamıyor ise **“Demo önerileri gösteriliyor”** ifadesiyle yerel sonuç gösterilir; gerçek model yanıtıymış gibi sunulmaz.
- Eksik malzemeler → **Alışveriş Listesine Ekle**; aynı ürün tekrar eklenirse miktar birleştirme/uyarı kuralı uygulanır.
- Profildeki alerji, intolerans, hastalık veya diyet tercihleri yalnızca **kullanıcı beyanı** olarak tutulur. AI çıktısının her zaman güvenli olduğu iddia edilmez. Alerjen uyarısı, belirsiz içerik etiketi ve “tıbbi tavsiye değildir” açıklaması bulunur. Sağlık geçmişi uzaktaki modele varsayılan olarak gönderilmez; açık onay gerekir.
- Modelin önerdiği fiyat ve besin değerleri doğrulanmış veri değilse **tahmini** olarak etiketlenir; JSON katalog değerleri varsa öncelik verilir.

### 2.5 Analiz ve raporlama (`AnalyticsView`)
- Dönem filtreleri: bugün / son 7 gün / bu ay (gerçek kayıtlarla hesaplanır).
- Pasta grafik: **Market Alışverişi / Evde Pişirdim / Dışarıdan Söyledim**; yalnızca bütçeye etkisi olan harcamalar toplamı kullanılır.
- Çubuk grafik: günlük harcama ve günlük kalori; farklı birimler aynı eksene karıştırılmaz.
- Kural tabanlı içgörü: ör. “Bu ay dışarıdan sipariş, gerçek gıda giderlerinin %45'ini oluşturdu.” Payda sıfırsa yüzde hesaplanmaz.
- Boş veri için grafik yerine anlamlı boş durum.

### 2.6 Alışveriş listesi (`ShoppingListView`)
- Malzeme adı, miktar, birim, tahmini birim fiyat ve tahmini toplam.
- Manuel ekle/düzenle/sil, tamamlandı işaretleme, asistandan eksik malzeme aktarımı.
- Fiyatlar **demo JSON / kullanıcı girişi** kaynaklıdır; güncel market fiyatı olduğu söylenmez.
- Alışveriş listesine ekleme **harcama oluşturmaz**. Kullanıcı satın almayı onayladığında ayrı gerçek gider kaydı oluşturulur; çift sayım önlenir.

### 2.7 Profil ve hedefler (`ProfileView`)
- Aylık gıda bütçesi (TL), günlük kalori hedefi, opsiyonel protein hedefi.
- Diyet tercihi (örn. vegan) ve kullanıcı beyanına dayalı hassasiyet/kısıtlar (örn. çölyak, diyabet).
- Değişiklikleri kaydet, başarı/hata durumları, doğrulama.
- Hassas sağlık tercihlerini yerelde minimum veriyle sakla; paylaşım/onay tercihi ayrıca tutulur.

## 3. Ekran ve navigasyon tasarımı

### 3.1 Açılış akışı
1. **Native Splash:** İşletim sistemi açılış ekranı; burada ağ işlemi veya karmaşık yönlendirme yapılmaz.
2. **App Bootstrap / SplashView:** Yerel veritabanı ve bağımlılıklar hazırlanır; `loading / ready / failure` durumları.
3. **OnboardingView:** İlk açılışta hedefleri tanıtır; tamamlandı bayrağı yerelde saklanır.
4. **Router redirect:** Onboarding tamamlandıysa `/home`, değilse `/onboarding`. Başlatma hatasında `/startup-error` ve **Tekrar Dene**.
5. Onboarding tamamlandığında `context.go('/home')`; geri tuşuyla onboarding'e dönülmez.

### 3.2 Önerilen GoRouter rotaları

| Route | Ekran | Veri geçişi |
|---|---|---|
| `/splash` | `SplashView` | bootstrap state |
| `/startup-error` | `StartupErrorView` | hata kodu / retry |
| `/onboarding` | `OnboardingView` | yerel tamamlanma durumu |
| `/home` | `HomeView` | repository üzerinden canlı özet |
| `/entries/new` | `AddEntryView` | yeni kayıt |
| `/entries/:entryId` | `EntryDetailView` | benzersiz kayıt ID |
| `/entries/:entryId/edit` | `AddEntryView` | mevcut kayıt ID |
| `/analytics` | `AnalyticsView` | opsiyonel `?tab=budget` veya `?tab=nutrition` |
| `/assistant` | `AIAssistantView` | form/chat durumu |
| `/shopping` | `ShoppingListView` | yerel liste |
| `/profile` | `ProfileView` | hedef ve tercih verisi |

- Kimlik taşıyan detay sayfalarında ID **path parameter** olur; ekran repository'den ID ile veriyi yükler.
- Geçersiz/silinmiş ID → `NotFoundView` + geri dön.
- `context.go()` ana sekmeler ve akış değiştirme; `context.push()` detay/form açma; `context.pop()` tamamlanan alt ekranı kapatma.
- Router `redirect` sadece onboarding/başlatma gibi yönlendirme kurallarını uygular; veritabanı sorguları widget build içinde yapılmaz.
- `refreshListenable` veya router'ın desteklediği durum yenileme mekanizmasıyla onboarding/bootstrap değişince redirect yeniden değerlendirilir; sonsuz yönlendirme döngüsü önlenir.

## 4. Clean Architecture + Feature-First

### 4.1 Katmanların görevleri
- **Presentation:** View, widget, Cubit ve UI state; kullanıcı etkileşimi, loading/success/empty/error gösterimi. HTTP/SQL burada bulunmaz.
- **Domain:** Entity, repository interface, use case, değer nesneleri ve saf iş kuralları. Flutter UI, Drift ve dış API paketlerine bağımlı değildir.
- **Data:** Model/DTO, local JSON, Drift tabloları ve DAO'lar, repository implementasyonları; domain arayüzlerini uygular.
- **Core:** Router, DI, tema, ortak hata tipi, tarih/para yardımcıları, ağ durumları ve tekrar kullanılabilir bileşenler.

**Bağımlılık yönü:** `presentation → domain ← data`; `core` yalnızca ortak altyapıyı sağlar. Feature'lar birbirinin `data` katmanına doğrudan erişmez; paylaşılan gereksinim domain sözleşmeleri üzerinden çözülür.

### 4.2 Klasör ağacı

```text
nutriwallet/
├── project.md
├── pubspec.yaml
├── analysis_options.yaml
├── assets/
│   └── data/
│       ├── ingredients_demo.json
│       ├── recipes_demo.json
│       ├── prices_demo.json
│       └── assistant_responses_demo.json
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── bootstrap.dart
│   │   ├── di/injection_container.dart
│   │   └── router/
│   │       ├── app_router.dart
│   │       ├── route_names.dart
│   │       └── router_refresh_notifier.dart
│   ├── core/
│   │   ├── error/{failure.dart,exceptions.dart}
│   │   ├── result/result.dart
│   │   ├── theme/{app_theme.dart,app_colors.dart,app_typography.dart}
│   │   ├── utils/{currency_utils.dart,date_utils.dart,validators.dart}
│   │   └── widgets/{app_loading.dart,app_error.dart,empty_state.dart}
│   └── features/
│       ├── startup/
│       │   ├── presentation/{cubit,views,widgets}/
│       │   └── domain/{repositories,usecases}/
│       ├── onboarding/
│       │   ├── data/{datasources,repositories}/
│       │   ├── domain/{entities,repositories,usecases}/
│       │   └── presentation/{cubit,views,widgets}/
│       ├── entries/
│       │   ├── data/{datasources,models,repositories}/
│       │   ├── domain/{entities,repositories,usecases}/
│       │   └── presentation/{cubit,views,widgets}/
│       ├── dashboard/
│       │   ├── domain/{entities,usecases}/
│       │   └── presentation/{cubit,views,widgets}/
│       ├── budget/
│       │   ├── domain/{entities,usecases}/
│       │   └── presentation/{cubit,views,widgets}/
│       ├── analytics/
│       │   ├── domain/{entities,usecases}/
│       │   └── presentation/{cubit,views,widgets}/
│       ├── assistant/
│       │   ├── data/{datasources,models,repositories}/
│       │   ├── domain/{entities,repositories,usecases}/
│       │   └── presentation/{cubit,views,widgets}/
│       ├── shopping/
│       │   ├── data/{datasources,models,repositories}/
│       │   ├── domain/{entities,repositories,usecases}/
│       │   └── presentation/{cubit,views,widgets}/
│       └── profile/
│           ├── data/{datasources,models,repositories}/
│           ├── domain/{entities,repositories,usecases}/
│           └── presentation/{cubit,views,widgets}/
├── test/
│   ├── unit/{budget,entries,analytics,assistant}/
│   ├── widget/{forms,dashboard,shopping}/
│   └── router/
└── integration_test/
    └── main_flow_test.dart
```

> Ağaçtaki `{...}` grupları belgeyi kısa tutmak için klasör adlarını temsil eder; gerçek projede ayrı dizinler oluşturulacaktır. `data.md`, `agent.md`, `tema.md` ve `design.md` **bu aşamada oluşturulmayacak**, sonraki dokümanlardır.

### 4.3 Örnek çağrı zinciri

```text
Kaydet butonu
  → EntryFormCubit.save()
  → CreateEntryUseCase.execute(entry)
  → EntryRepository.create(entry)            [domain sözleşmesi]
  → EntryRepositoryImpl.create(entry)        [data]
  → DriftEntryLocalDataSource.insert(entry)
  → Result<Success, Failure>
  → UI: success / validation error / storage error
  → DashboardCubit.refresh() / veri akışıyla otomatik yenileme
```

Dart fonksiyonları uygun sınıflarda tanımlanır ve başka dosyalardan **import** edilir. İş kuralları widget içine kopyalanmaz. `build()` içinde kayıt, API çağrısı veya kalıcı yazma yapılmaz.

## 5. State management, DI ve asenkron çalışma

- Varsayılan: `flutter_bloc` ile **Cubit**. Karmaşık event akışı gerektiren özellikte BLoC kullanılabilir; sebepsiz karıştırılmaz.
- Her Cubit için açık durumlar: `initial`, `loading`, `success/data`, `empty`, `failure`; formda ayrıca `submitting` ve `saved`.
- `BlocBuilder` arayüzü oluşturur; `BlocListener` snackbar, dialog, yönlendirme gibi **tek seferlik yan etkiler** için kullanılır. `build()` içinde dialog/navigation çağrılmaz.
- `BlocSelector` ile sadece ilgili özet kartı güncellenir.
- `get_it` üzerinden repository, use case, data source ve Cubit bağımlılıkları kayıt edilir. Durum tutan ekran Cubit'leri varsayılan olarak **factory**, paylaşılan veritabanı/repository **lazy singleton** olabilir; kapatılma yaşam döngüsü yönetilir.
- Disk/JSON/model istekleri `Future` veya `Stream` ile asenkron; bütçe formülleri ve doğrulamalar saf senkron fonksiyonlar.
- Her asenkron akış `try/catch` ve tanımlı `Failure` eşlemesi kullanır. Loading sonsuza kadar kalmaz; zaman aşımı ve tekrar deneme yolu bulunur.

## 6. Veri saklama ve demo veri stratejisi

### 6.1 Kalıcı veri
- **Drift + SQLite** tercih edilir: ilişkisel kayıtlar, filtreleme, tarih bazlı toplamlar ve tutarlılık için.
- Örnek kavramsal tablolar: `entries`, `profile_settings`, `shopping_items`, `assistant_history` (opsiyonel), `app_preferences`.
- Kimlikler benzersiz UUID veya güvenilir DB kimliği; tarih/saat yerel gün sınırlarına göre raporlanır.
- Para hesaplarında kayan nokta kullanılmaz: **kuruş cinsinden tamsayı** saklanır. UI'da TL biçimlendirilir.
- Kalori/makro miktarları geçerli ve negatif olmayan sayılar olarak saklanır; bilinmeyen değer `null` olabilir, otomatik `0` varsayılmaz.
- Veritabanı şema değişikliklerinde migration gerekir.

### 6.2 Demo JSON (`data.md` kapsamı)
- `ingredients_demo.json`: malzeme ID, ad, birim, besin değerleri ve veri kaynağı.
- `prices_demo.json`: malzeme ID, paket/miktar, **tahmini TL fiyat**, tarih, `source: demo`.
- `recipes_demo.json`: tarif ID, porsiyon, malzeme ID + miktar, adımlar, tahmini değerler.
- `assistant_responses_demo.json`: demo kullanıcı girdisi / tarif önerisi eşleşmeleri.
- Kesin JSON alan adları, örnek payload, validasyon, eşleştirme ve Qwen istek/yanıt formatı **ileride `data.md` içinde** kararlaştırılacaktır. Şu an API endpoint, token veya gerçek market fiyatı eklenmez.
- JSON varlıkları uygulama paketine dahildir; ilk çalıştırmada okunur. Kullanıcının düzenlediği kayıtlar JSON'a değil Drift'e yazılır.

### 6.3 Asistan soyutlaması

```text
AIAssistantView
  → AssistantCubit
  → GenerateRecipeSuggestionUseCase
  → AssistantRepository (interface)
      ├── DemoAssistantRepository / LocalJsonDataSource  [MVP, çevrimdışı]
      └── QwenAssistantRepository / HuggingFaceDataSource [sonraki aşama, opsiyonel]
```

- **Ücretsiz Hugging Face/Qwen erişimi garanti edilmez**; demo akışı buna bağımlı olamaz.
- Üçüncü taraf API token'ı mobil uygulama kaynak koduna, asset JSON'a veya Git deposuna gömülmez. Canlı erişim için güvenli anahtar yönetimi/aracı katman gerekip gerekmediği entegrasyon öncesi değerlendirilir.
- Üretken model çıktısı yapılandırılmış yanıt olarak doğrulanır; hatalı/eksik alanlar UI'ı çökertmez.

## 7. Hesaplama kuralları ve veri tutarlılığı

| Hesaplama | Kural |
|---|---|
| Günlük kalori | Yalnızca tüketilmiş öğünlerin kcal toplamı |
| Günlük protein | Makrosu bilinen öğünlerin gram toplamı; eksik veri ayrıca belirtilir |
| Aylık gider | `isBudgetExpense = true` olan bu ayki kayıtların kuruş toplamı |
| Kalan bütçe | Aylık hedef − gerçek gider |
| Günlük öneri | `max(0, kalan bütçe) / bugün dahil kalan gün` |
| Kategori oranı | Kategori gerçek gideri / tüm gerçek gider × 100 |
| Sepet tahmini | Miktar × tahmini birim fiyat; eksik fiyatlar ayrıca işaretlenir |
| Tarif porsiyon maliyeti | Kullanılan miktara orantılanmış malzeme maliyetleri / porsiyon sayısı |

**Çift sayım politikası:** Aynı malzemenin marketten satın alınması ve daha sonra evde yemeğe dönüştürülmesi **tek gerçek nakit gider** doğurur. Öğün maliyeti ayrı analiz amaçlı tutulabilir, fakat market harcamasıyla beraber tekrar bütçeden düşülmez.

## 8. UI/UX, tema ve hata durumları

- Material 3; yeşil/doğa + mavi/gri; modern, gölgesiz kartlar. Renkler ve bileşen ölçüleri daha sonra `tema.md` ve `design.md` içinde kesinleştirilir.
- Mobil ekranlarda kaydırılabilir formlar, klavye açılınca taşmayan layout, erişilebilir dokunma alanları.
- Tüm para alanları `₺`, kalori `kcal`, makrolar `g` birimiyle etiketlenir.
- Başarı: kayıt sonrası `SnackBar` veya uygun başarı durumu.
- Hata: gerçek nedenin anlaşılır özeti, tekrar dene; internet yoksa yalnızca online özellikte uyarı.
- Boş durum: eylem çağrısı; yanlış route/ID: bulunamadı ekranı; başlangıç hatası: tekrar dene.
- Hata animasyonu hata metninin **yerini almaz**; kullanıcı hatanın ne olduğunu anlar.
- **Çalışmayan buton, sahte başarı, “yakında” yazılı işlevsiz kart bulunmaz.** MVP'de olmayan aksiyon UI'a konulmaz.

## 9. Buton/aksiyon kabul matrisi

| Ekran | Kontrol | Beklenen davranış |
|---|---|---|
| Dashboard | Kalori kartı | `/analytics?tab=nutrition` |
| Dashboard | Bütçe/harcama kartı | `/analytics?tab=budget` |
| Dashboard | FAB / İlk Kaydını Ekle | `/entries/new` |
| Dashboard | Son öğün kartı | `/entries/:entryId` |
| Kayıt formu | Kaydet | Doğrula → DB yaz → başarı / hata |
| Kayıt formu | İptal | Kaydetmeden geri dön; değişiklik varsa uyar |
| Kayıt detayı | Düzenle / Sil | ID ile düzenle / onayla sil; ekranı yenile |
| Analytics | Dönem filtresi | Grafik ve içgörüleri yeniden hesapla |
| Analytics | Simülasyon hesapla | Kaydetmeden senaryo sonucu göster |
| Asistan | Öneri oluştur | Demo JSON eşleştir → tarif / açık boş durum |
| Asistan | Eksikleri listeye ekle | Yerel listeye kalıcı yaz; başarı/hata göster |
| Alışveriş | Ekle / düzenle / sil | Drift CRUD ve toplam yenileme |
| Alışveriş | Tamamlandı | Durumu güncelle; harcama otomatik oluşturma |
| Profil | Hedefleri kaydet | Doğrula → yerel kaydet → özetleri güncelle |
| Onboarding | Tamamla | Bayrağı kaydet → `go('/home')` |
| Başlangıç hatası | Tekrar Dene | Bootstrap işlemini tekrar çalıştır |

## 10. Teknik riskler ve çözüm kararları

1. **Ücretsiz model erişimi/kota:** Qwen erişimi değişebilir → demo JSON fallback zorunlu.
2. **Token güvenliği:** Mobil binary içindeki token gizli değildir → API anahtarını kodda/asset'te tutma.
3. **Sağlık güvenliği:** AI önerileri tıbben doğrulanmış değildir → tahmini/uyarı etiketleri, hassas veri paylaşımı için onay.
4. **Fiyat doğruluğu:** Demo fiyatları güncel Türkiye market fiyatı değildir → `demo`, tarih ve tahmini etiketleri.
5. **Bütçede çift sayım:** Market ve evde pişirme maliyeti ayrıştırılır → `isBudgetExpense` kuralı.
6. **Kalori/makro tutarlılığı:** Eksik değerler 0 gibi sunulmaz; tarif başına/porsiyon başına ayrımı korunur.
7. **Ay sınırı ve saat dilimi:** Ay sonu, yerel tarih ve şubat/artık yıl senaryoları test edilir.
8. **Yavaş yükleme:** `loading / success / empty / failure` state'leri; tekrar dene ve iptal yönetimi.
9. **Router döngüsü:** Bootstrap ve onboarding redirect durumları tek merkezden yönetilir.
10. **SQLite migration:** Şema versiyonu ve yükseltme testleri tutulur.

## 11. Geliştirme sırası

1. Flutter iskeleti, tema temeli, GoRouter, GetIt, bootstrap, onboarding.
2. Drift tabloları, domain entity/repository/use case sözleşmeleri.
3. Öğün & harcama CRUD; form doğrulama ve hata durumları.
4. Dashboard, hedefler ve bütçe simülatörü.
5. Analiz grafikleri ve kural tabanlı içgörüler.
6. Alışveriş listesi CRUD ve sepet uyarısı.
7. Demo JSON tarif/malzeme/fiyat verileri ve yerel asistan.
8. Opsiyonel Qwen sağlayıcı adaptörü (erişim koşulları doğrulandıktan sonra).
9. Unit, widget, router, integration testleri; demo senaryosu.

## 12. Test ve tamamlanma kriterleri

- `flutter analyze` kritik hata vermemeli; `flutter test` geçmeli.
- Her görünür buton için widget/integration test veya manuel kabul senaryosu bulunmalı.
- Uygulama kapatılıp açıldığında kayıtlar ve hedefler korunmalı.
- Kaydetme başarısı, doğrulama hatası, veritabanı hatası, boş veri, yanlış ID ve offline asistan durumları denenmeli.
- Dashboard ve grafikler kayıt ekleme/düzenleme/silme sonrası güncellenmeli.
- Kategori bazlı gider toplamları çift sayım yapmamalı.
- Ay sonu, sıfır bütçe, aşılmış bütçe ve eksik fiyat/makro durumları test edilmeli.
- API olmadan **tam demo akışı** çalışmalı: onboarding → hedef → öğün → dashboard → simülasyon → tarif → alışveriş listesi → grafik.

## 13. Daha sonra hazırlanacak belgeler (şimdi oluşturulmayacak)

- **`data.md`:** JSON şemaları, örnek malzeme/fiyat/kalori/tarif verileri, kaynak etiketleri, Qwen istek/yanıt formatı, demo fallback eşleştirmeleri.
- **`agent.md`:** Kodlama ajanı kuralları, görev sırası, dosya sorumlulukları, test ve teslim kontrol listeleri.
- **`tema.md`:** Renk paleti, tipografi, spacing, bileşen token'ları, açık/koyu tema.
- **`design.md`:** Wireframe, sayfa düzenleri, kartlar, boş/yükleme/hata/başarı durumları ve etkileşim ayrıntıları.

---

**Proje ilkesi:** Az sayıda, birbiriyle bağlantılı, **gerçekten çalışan** özellik; backend zorunlu olmadan yerel verilerle güvenilir demo; temiz katman sınırları; doğru finansal hesaplar; açıkça etiketlenmiş tahmini besin/fiyat verileri.
