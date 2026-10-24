# NutriWallet — DESIGN.md

> **Proje:** NutriWallet — Beslenme & Gıda Bütçesi Takibi  
> **Grup:** Merve, Adil  
> **Platform:** Flutter mobil (Android öncelikli, iOS uyumlu)  
> **Belge türü:** UI/UX tasarım ve etkileşim sözleşmesi  
> **Kaynak:** `project.md` — kapsam ve iş kurallarında öncelikli belge  
> **Sınır:** Bu belge yeni özellik eklemez. API entegrasyonu, JSON alan şeması, ajan görevleri ve kesin tema token'ları sırasıyla sonraki `data.md`, `agent.md`, `tema.md` belgelerinin konusudur.

## 1. Tasarımın amacı

NutriWallet, **beslenme (kalori/makro)** ile **gıda bütçesini (TL)** aynı yerde gösterir. Kullanıcı, en az dokunuşla kayıt yapabilmeli; ne tükettiğini, ne harcadığını, kalan bütçesini ve alternatif harcama senaryolarını karıştırmadan anlamalıdır.

**Tasarım ilkeleri:**
1. **İşlevsel dürüstlük:** Görünen her etkileşim gerçekten çalışır. İşlevsiz ikon, sahte buton, “yakında” kartı yoktur.
2. **Gerçek / tahmini ayrımı:** Gerçek kaydedilmiş gider, kullanıcı tarafından atfedilen öğün maliyeti, demo fiyat ve AI tahmini aynı şekilde gösterilmez.
3. **Bilişsel sadelik:** Ana ekranda dört temel metrik, kısa liste ve birincil hızlı ekle aksiyonu.
4. **Durumların görünürlüğü:** Boş, yükleniyor, başarılı, başarısız, çevrimdışı ve kısmi veri halleri tasarımın bir parçasıdır.
5. **Erişilebilirlik:** Yalnızca renkle anlam verme; metin, ikon ve uygun kontrast kullan.
6. **Tutarlılık:** Tek bir tasarım sistemi, ortak form alanları, kart, diyalog, hata, yükleme ve buton bileşenleri.

## 2. Bilgi mimarisi ve navigasyon

### 2.1 Ana navigasyon

**Alt navigasyon — dört ana hedef:**
- **Ana Sayfa** → `/home`
- **Analiz** → `/analytics`
- **Asistan** → `/assistant`
- **Profil** → `/profile`

**Alışveriş Listesi** (`/shopping`) asistan ekranından ve bütçe/alışveriş bağlamından açık aksiyonla ulaşılabilen ayrı sayfadır. **Yeni Kayıt** (`/entries/new`) dashboard'daki FAB ile açılır. Alt navigasyona ayrı beşinci/altıncı sekme eklenmez; görsel kalabalık önlenir.

**Detay rotaları:** `/entries/:entryId`, `/entries/:entryId/edit`. Analiz sekmesi `?tab=budget` veya `?tab=nutrition` parametresini kullanır. Geçersiz ID hata/bulunamadı ekranına gider.

### 2.2 Navigasyon davranışları

- Ana sekme değişimleri: `context.go(...)`.
- Form, detay, alışveriş gibi alt akışlar: `context.push(...)`; dönüşte `context.pop()`.
- Onboarding bitişi: `context.go('/home')`; geri ile onboarding'e dönülmez.
- Splash ve onboarding kararları GoRouter yönlendirmesinde belirlenir; tasarım tarafında tahmini gecikme veya keyfî zamanlayıcı yoktur.
- Android sistem geri hareketi ve iOS geri jesti tutarlı çalışır.
- Düzenlenmiş ama kaydedilmemiş formdan çıkarken **“Değişiklikleri sil?”** onayı gösterilir.
- Alt navigasyon kullanıcının içerik konumunu korumalı; yeni sayfaya her girişte anlamsız sıfırlama yapılmamalıdır.

### 2.3 Ana akış (metin wireframe)

```text
Native Splash
   ↓
Flutter Bootstrap [yükleniyor / hata → tekrar dene]
   ↓
İlk kullanım mı? ── evet → Onboarding / hedef belirleme
   │                            ↓
   hayır                        Ana Sayfa
   ↓                             ↓
Ana Sayfa ── FAB ── Yeni Kayıt ── Kaydet → Ana Sayfa güncellenir
   ├─ kalori/protein kartı → Analiz / Beslenme
   ├─ harcama/bütçe kartı → Analiz / Bütçe
   ├─ son öğün → Kayıt detayı → Düzenle / Sil
   ├─ Asistan → Tarif önerisi → Eksikleri Alışveriş Listesine Ekle
   └─ Profil → Hedefleri Düzenle → Kaydet → tüm ilgili ekranlar yenilenir
```

## 3. Görsel dil

### 3.1 Kimlik ve atmosfer

- **Hissiyat:** güvenilir, sade, ferah, insani; ne aşırı klinik ne de oyunlaştırılmış.
- **Renk rolleri:** beslenme için yeşil/doğa, finans için mavi/gri; uyarı için amber, tehlike için kırmızı. Kesin HEX ve semantic color token'ları `tema.md`de belirlenecek.
- **Yüzeyler:** Material 3, gölgesiz/flat kartlar, ince border veya tonal zemin ayrımı; ağır gradient ve aşırı gölge kullanılmaz.
- **Tipografi:** belirgin başlık > büyük metrik > yardımcı açıklama hiyerarşisi; para ve sayılarda tabular figures tercih edilir.
- **Sayılar:** `₺1.250,00`, `1.450 kcal`, `72 g`; yüzde için `%45`. Dil ve sayı biçimi `tr_TR`.
- **İkonlar:** tutarlı çizgi ikon ailesi; ikon yanında açıklayıcı metin/tooltip veya erişilebilir etiket.
- **Boşluk sistemi:** 4/8 birimlik ritim; kesin paddings `tema.md`de sabitlenecek. Kart araları, form alanları ve butonlar tüm ekranlarda aynı düzende.
- **Grafikler:** düşük görsel gürültü; renk dışında legend ve değer açıklaması bulunur.

### 3.2 Ekran ölçüsü ve responsive

- Tek sütun mobil tasarım, dar telefonlar için kaydırılabilir yapı.
- Geniş telefonda iki metrik kart yan yana; dar alanda tek sütuna düşebilir.
- Tablet/geniş alanda maksimum içerik genişliği sınırlanır ve kartlar daha geniş grid'e geçebilir; mobil kullanım önceliklidir.
- Klavye açıldığında kaydet butonu ve hata mesajı erişilebilir kalır (`SafeArea`, keyboard inset, scroll).
- Metin büyütülünce taşma, kesilme ve buton gizlenmesi olmamalı.
- Dokunulabilir hedefler yaklaşık **48×48 dp veya daha büyük**; erişilebilir etiketler ve mantıklı odak sırası.
- Sistem açık/koyu tema desteğine uygun semantic renk sistemi; koyu tema ayrıntıları `tema.md`ye bırakılmıştır.

## 4. Ortak bileşenler

| Bileşen | Görevi | Etkileşim/durum |
|---|---|---|
| `NutriScaffold` | AppBar + SafeArea + içerik + gerekiyorsa alt bar | Geri, başlık, seçili sekme |
| `SummaryMetricCard` | Kalori/protein/harcama/kalan bütçe özeti | Tıklanınca gerçek hedef route |
| `BudgetProgressCard` | Bütçe kullanılan/kalan/taşan tutar | Aşım metni + ilerleme çubuğu |
| `PrimaryActionButton` | Kaydet, öner, hesapla gibi ana eylem | idle/loading/disabled/success/error |
| `SecondaryActionButton` | İptal, geri, filtre, alternatif eylem | Net etiket, uygun feedback |
| `AppTextField` | Form girişi | normal/focus/error/read-only/disabled |
| `MoneyField` | TL girişi | Klavye, yerel format, geçerli sayı kontrolü |
| `AppSelectField` | Öğün/kategori/tercih seçimi | Seçili durum + doğrulama |
| `EntryListTile` | Son öğün ve harcama kaydı | Detaya ID ile gider |
| `PriceEstimateTag` | Demo / tahmini maliyet | Doğrulanmış güncel fiyat izlenimi vermez |
| `NutritionEstimateTag` | Tahmini kalori/makro | `Tahmini` ibaresi ve birim |
| `AppEmptyState` | Veri yok | Yalnızca çalışır CTA gösterir |
| `AppErrorState` | Açıklanabilir hata | Hata metni + tekrar dene |
| `AppLoadingState` | Veri yükleniyor | Progress göstergesi; sonsuz kalmaz |
| `ConfirmDialog` | Silme/çıkış gibi riskli işlem | Vazgeç / onayla |
| `InsightCard` | Kural tabanlı açıklama | Kaydedilmiş verilere bağlı |

**Teknik bağ:** Bileşenler `core/widgets` altında paylaşılanlar veya ilgili `features/*/presentation/widgets` altında bulunur. Sadece çizim yapan widget veri tabanı sorgusu yapmaz; veriyi Cubit state'inden alır.

## 5. Ekran tasarımları

### 5.1 Native Splash ve `SplashView`

**Düzen:** ortada NutriWallet yazısı/marka, sade arka plan; Flutter başlatma ekranında erişilebilir indikatör ve “Veriler hazırlanıyor” metni.

**Durum:** `loading → ready` veya `failure`. Hata halinde ayrı `StartupErrorView`: kısa açıklama + **Tekrar Dene**; işlem tekrar başlatılır. Dekoratif animasyon hata açıklamasının yerini almaz. Native Splash üzerinde API çağrısı veya ağ beklemesi yok.

### 5.2 `OnboardingView`

**Amaç:** uygulamayı ilk kez açıklamak ve zorunlu hedefleri belirlemek.

**Akış önerisi (3 adım):**
1. “Beslenmeni ve harcamanı birlikte gör” — kısa açıklama.
2. Aylık gıda bütçesi ve günlük kalori hedefini gir; opsiyonel protein hedefi.
3. İsteğe bağlı diyet tercihi/kısıtlar, yerelde saklama ve asistan veri paylaşımı açıklaması; **Başla**.

**Kontroller:** Geri / Devam / Başla. Geçersiz hedefle ilerleme engellenir; ilgili alanda hata gösterilir. Son adım kaydı başarılı olunca onboarding tamamlanmış sayılır ve `/home` açılır. Kayıt başarısızsa ekranda kalır, tekrar denenir. Kullanıcı hassas sağlık bilgisi girmeye zorlanmaz.

### 5.3 `HomeView` (Dashboard)

```text
┌─────────────────────────────────┐
│ NutriWallet         [Profil]    │
│ Bugünkü özet                    │
│ ┌───────────────┬─────────────┐ │
│ │ Kalori        │ Protein     │ │
│ │ 1.450 kcal    │ 72 g        │ │
│ ├───────────────┼─────────────┤ │
│ │ Bu ay gider   │ Kalan bütçe │ │
│ │ ₺2.100        │ ₺3.900      │ │
│ └───────────────┴─────────────┘ │
│ Aylık bütçe      [ilerleme]     │
│ Son öğünler                    │
│ [öğün kartı → detay]            │
│                                 │
│                        [+ FAB]  │
│ Ana Sayfa | Analiz | Asistan | Profil │
└─────────────────────────────────┘
```

**Görsel not:** Rakamlar örnektir, gerçek uygulama verisi değildir. Metrik kartlarında üstte küçük başlık, altta büyük değer, altında varsa hedefe ilerleme bulunur. `Kalan bütçe` negatifse eksi işareti ve “Bütçe aşıldı” mesajı aynı anda gösterilir; progress bar 100%'de sınırlandırılır.

**Etkileşimler:** Kalori/protein → `/analytics?tab=nutrition`; gider/kalan → `/analytics?tab=budget`; FAB → `/entries/new`; son kayıt → `/entries/:entryId`. Hiç kayıt yokken grafik taklidi yerine **İlk Kaydını Ekle**. Profil simgesi kullanılırsa `/profile` yönlendirmesi mutlaka çalışır.

### 5.4 `AddEntryView` (Öğün & Harcama)

**Alan sırası:** kategori, yemek/harcama adı, tarih-saat, öğün türü (yalnızca tüketim kaydında), yaklaşık kcal, opsiyonel protein/karbonhidrat/yağ, tutar (TL). Kategoriye göre koşullu alan gösterilir:
- **Dışarıdan Söyledim:** öğün + besin + gerçek harcama.
- **Evde Pişirdim:** öğün + besin + öğüne atfedilen maliyet; bu bedelin bütçeden ikinci kez düşülmemesi açıkça anlatılır.
- **Market Alışverişi:** harcama adı + gerçek TL gider; öğün/kalori alanları gösterilmez.

**Alt aksiyonlar:** **Kaydet** (primary) + **İptal**. Kaydet öncesi eksik veya geçersiz alanlarda inline hata; kaydedilirken spinner/disabled; başarı sonrası `SnackBar` + `pop`; kalıcı yazma hatasında ilgili ekranda hata + tekrar dene. Düzenleme modunda başlık “Kaydı Düzenle”, düğme “Değişiklikleri Kaydet”. Silme yalnızca detayda onay ile.

**Giriş ayrıntıları:** TL alanı negatif veya sayısal olmayan değer kabul etmez; isteğe bağlı makro alanı boşsa 0 yazılmaz. Tarih seçici geçmiş/gelecek kayıt politikası domain kurallarıyla tutarlı olmalıdır.

### 5.5 `EntryDetailView`

Üstte isim/tarih/kategori, altında kalori-makro ve maliyet ayrı bilgi grupları. “Gerçek gider” ile “Öğüne atfedilen maliyet” etiketi farklıdır. Eylemler **Düzenle** ve **Sil**. Silmede onay; başarı sonrası önceki ekrana dön ve listeyi yenile. Silinmiş/geçersiz ID için “Kayıt bulunamadı” + geri.

### 5.6 `AnalyticsView` (Bütçe + Beslenme)

**Üst kontrol:** iki segment **Bütçe / Beslenme**; route query param ile başlangıç segmenti seçilir. Altında dönem filtreleri **Bugün / Son 7 Gün / Bu Ay**. Filtre değişince grafik ve içgörüler aynı dönem için yeniden hesaplanır.

**Bütçe segmenti:**
- Bu ay harcanan/kalan metrikleri, aylık bütçe ilerlemesi.
- **“Ay Sonuna Kadar Hayatta Kal”** kartı: bugün dahil kalan gün ve **günlük önerilen limit**.
- **“Şu kadar harcarsam?”** TL inputu + **Hesapla**; sonuç kartında senaryo sonrası kalan bütçe ve uygunsa yarınki önerilen limit. “Simülasyon: gerçek harcamaya kaydedilmedi” açıklaması kalıcı görünür.
- Kategori dağılımı pasta/donut grafiği ve metin legend. Mevcut kategoriler **Market Alışverişi / Evde Pişirdim / Dışarıdan Söyledim**; yalnızca `isBudgetExpense=true` tutarlar dahil edilir.
- Kural tabanlı metinsel içgörü kartı.

**Beslenme segmenti:** günlük kalori trendi, hedefe göre ilerleme, protein özeti. Farklı birimler aynı düşey eksende birleştirilmez.

**Grafik davranışı:** Grafiğe dokunulduğunda gün/kategori + doğru birimde değer etiketi gösterilir. 0 veri varsa “Bu dönemde kayıt yok” gösterilir; sıfır payda ile `%0` içgörüsü uydurulmaz. Bütçe aşımlarında yalnız renk kullanılmaz, tutar ve açıklama yazılır.

### 5.7 `AIAssistantView` (Demo Asistan)

**Üst alan:** başlık “Tarif Asistanı”, küçük açıklama: “Elindeki malzemeleri ve bütçeni yaz.”

**Giriş bölümü:**
- Malzeme girişi (çoklu metin veya etiketler).
- Günlük kullanılabilir bütçe (TL).
- Tercihler profilden okunur; kullanıcı hangi tercihlerin kullanıldığını görebilir.
- **Öneri Oluştur**.

**Sonuç kartı:** tarif adı, porsiyon, süre (demo kaynağında varsa), malzemeler, adımlar, **tahmini** porsiyon maliyeti, **tahmini** kcal/makrolar, eksik malzemeler. Eksik malzemelerin yanında **Alışveriş Listesine Ekle** düğmesi; tekrar ekleme güvenli ele alınır.

**Dürüst veri sunumu:** MVP'de JSON eşleştirmesi kullanılıyorsa **“Demo önerisi”** etiketi bulunur. İleride Qwen kullanımı erişime bağlıdır; uygulama gerçek AI yanıtı gelmiş izlenimi üretmez. Fiyat ve besin değerlerinin veri kaynağı/tahmin niteliği görünürdür. Beslenme kısıtları için kısa “Tıbbi tavsiye değildir; içerikleri ve alerjenleri kontrol edin” notu bulunur. Sağlık bilgisi dış servise varsayılan olarak gönderilmez.

**Durumlar:** giriş boş/geçersiz → inline doğrulama; arama → yükleme; sonuç yok → “Bu malzemelerle demo tarif bulunamadı” + girdiyi düzenleme; hata → açıklama/tekrar dene; internet yok → yalnız uzak model seçiliyse açık çevrimdışı/demoya geçiş mesajı.

### 5.8 `ShoppingListView`

**Üst:** “Alışveriş Listesi”, tahmini sepet toplamı ve kalan bütçe karşılaştırma şeridi. Liste satırı: checkbox/tamamlandı, malzeme adı, miktar-birim, tahmini birim fiyat, satır toplamı, düzenleme/silme aksiyonları.

**İşlemler:** **Malzeme Ekle**, **Düzenle**, **Sil**, **Tamamlandı**, **Satın Almayı Kaydet** (yalnızca gerçek satın alma olarak kaydedilecek seçili girdiler için). Satın alma onayında gerçek TL gider açıkça gösterilir ve market harcama kaydı oluşturulur; listeye eklemek veya tamamlandı işaretlemek tek başına gider yaratmaz. Tekrar kaydetmeyi önleyen işlem durumu gerekir.

**Bütçe uyarısı:** sepetin tahmini toplamı kullanılabilir bütçeyi aşıyorsa kırmızı/uyarı görseli + **“Tahmini sepet bütçeni ₺X aşıyor”** metni. Eksik fiyat bulunan satırlarda toplam “kısmi tahmin” olarak işaretlenir.

### 5.9 `ProfileView` (Profil ve Hedefler)

Kartlar: **Finansal Hedefler** (aylık gıda bütçesi), **Beslenme Hedefleri** (günlük kcal, opsiyonel protein), **Tercihler / Kısıtlar** (diyet tercihleri ve kullanıcı beyanı), **Gizlilik / paylaşım onayı** (gelecekteki çevrimiçi model için; MVP yerel çalışır).

**Kaydet** yalnızca gerçek değişiklik varsa aktif olabilir; başarılı kaydetme sonucu anında dashboard ve analiz hedeflerini yeniler. Hata varsa form verileri kaybolmaz. Hassas kısıtlar için “Bu bilgiler kendi beyanınızdır ve tıbbi doğrulama değildir” açıklaması bulunur.

## 6. Etkileşim sözleşmesi ve buton matrisi

| Konum | Aksiyon | Beklenen sonuç | Başarısızlık davranışı |
|---|---|---|---|
| Başlangıç hatası | Tekrar Dene | Bootstrap tekrar çalışır | Hata metni korunur |
| Onboarding | Devam/Geri/Başla | Adımlar/başlangıç rotası | Hedef validation veya kayıt hatası |
| Ana Sayfa | 4 metrik kartı | Doğru Analiz sekmesi açılır | Hatalı route fallback |
| Ana Sayfa | FAB / İlk Kaydını Ekle | Form açılır | Navigasyon hatası kullanıcıya açıklanır |
| Ana Sayfa | Son kayıt | ID'ye özel detay | Kayıt bulunamadı |
| Form | Kaydet | Bir kez veritabanına yazar | Inline hata veya yeniden dene |
| Form | İptal/Geri | Geri döner | Kirli formda vazgeçme onayı |
| Detay | Düzenle/Sil | Güncelle/Onayla + sil | Veri hatasında açık mesaj |
| Analiz | Segment/Dönem seçimi | Eşleşen veri/grafik | Boş veri mesajı |
| Simülatör | Hesapla | Salt-okunur senaryo | Geçersiz TL doğrulaması |
| Asistan | Öneri Oluştur | Demo tarif yanıtı | Boş sonuç/hata/demoya dönüş |
| Asistan | Alışveriş Listesine Ekle | Kalıcı liste güncelleme | Mükerrer/DB hata uyarısı |
| Alışveriş | Ekle/Düzenle/Sil/İşaretle | Kalıcı CRUD | Hata + retry |
| Alışveriş | Satın Almayı Kaydet | Tek market gider kaydı | Çift kaydı engelle + hata |
| Profil | Kaydet | Hedef/tercihleri güncelle | Form korunur + hata |

**Yasak:** `onPressed: () {}` gibi boş callback; işlem yapılmadan “Kaydedildi”; yükleme sırasında ikinci kaydetme; statik grafik değerlerini kullanıcı verisi gibi sunma; görünür fakat bağlı olmayan filtreler.

## 7. UI durum sistemi

Her önemli ekran en az şu durumlara sahip olmalı:

- **Initial:** veri isteği henüz başlamadı; gereksiz flash boş ekran yok.
- **Loading:** içerikle ilgili loader/skeleton; kullanıcıya işlem sürüyor bilgisi.
- **Success:** gerçek yerel veriyle arayüz.
- **Empty:** neden boş ve sonraki çalışır aksiyon.
- **Failure:** anlaşılır hata + varsa Tekrar Dene.
- **Submitting:** kaydet/oluştur sürüyor; aynı eylemin ikinci kez tetiklenmesi engellenir.
- **Partial data:** örneğin protein bilinmiyor veya fiyat eksik; değer uydurulmaz.

**Bildirimler:** Kalıcı olmayan başarı mesajı `BlocListener` ile `SnackBar`; yıkıcı işlem onayı `Dialog`; alan doğrulaması `TextFormField` altı metin. `BlocBuilder` içinde `showDialog`, `SnackBar`, `context.go/push` çağırma. Boş durum ekranında gerçek bir yönlendirme yoksa CTA oluşturma.

### 7.1 Mikro animasyonlar

- Kart dokunuşunda hafif geri bildirim; navigasyon akıcı.
- Save başarılı olduğunda kısa onay simgesi / `SnackBar`.
- Grafik aralığı değişirken hafif veri geçişi; sayısal gerçekler animasyon boyunca yanıltıcı verilmez.
- Hata animasyonu varsa yanında hata metni ve tekrar dene zorunlu.
- Sistem `reduce motion` tercihine saygı göster; animasyon işlev için zorunlu olmasın.

## 8. Kullanılabilirlik ve erişilebilirlik

- Renk körlüğü için grafik bölümlerinde legend, kategori adı ve tutar sun.
- Dinamik yazı boyutunda kartlar büyüyebilir; metni kesme.
- Ekran okuyucu etiketleri: `Günlük kalori: 1450 kilokalori. Beslenme analizine git` benzeri.
- Dokunma/klavye odak sırası, hata alanına odaklanma ve açık hata metni.
- Formun zorunlu alanlarını belirt; placeholder'ı tek başına label yerine kullanma.
- Tutarlı sayısal giriş: decimal separator, ₺ formatı; `0`, negatif, boş, taşan değerler test edilir.
- Hedefleri “iyi/kötü insan” değerlendirmesi gibi anlatma; nötr yönlendirici dil kullan.
- Sağlık koşullarından otomatik güvenli yemek sonucu çıkarma; alerjen ve belirsiz veri uyarısı sun.

## 9. Ekran/durum test kontrol listesi

- [ ] İlk açılış → onboarding → hedef kaydı → ana sayfa; ikinci açılış onboarding'i atlar.
- [ ] Başlangıç başarısızlığı → hata sayfası → Tekrar Dene.
- [ ] Dashboard dört kartının her biri doğru analiz sekmesini açar.
- [ ] FAB ile kayıt eklenir, geri dönünce dashboard ve son kayıt listesi güncellenir.
- [ ] Market alışverişi kalorilere eklenmez; evde yemek maliyeti gerçek nakit gideri iki kez artırmaz.
- [ ] Kayıt detayı ID ile yüklenir, düzenlenir, onayla silinir; geçersiz ID güvenli boş/hata ekranına çıkar.
- [ ] Bütçe hesaplayıcı sıfır/aşılan bütçe ve ayın son gününde doğru metin verir.
- [ ] Simülasyon tek başına harcama kaydı oluşturmaz.
- [ ] Filtre, grafik ve içgörü aynı döneme göre değişir; boş dönemde sahte grafik çizilmez.
- [ ] Asistan demo etiketi gösterir; tarif yoksa kullanıcıyı yönlendirir; eksikleri listeye aktarır.
- [ ] Sepet tahmini fiyatları etiketlenir; satın almayı kaydetmeden gerçek gider oluşturulmaz.
- [ ] Profil kaydı hedefleri ve ilgili özetleri yeniler; başarısız kayıtta form kaybolmaz.
- [ ] Bütün ekranlar dar ekran, büyük metin, klavye açık, yükleme, boş ve hata durumunda taşma yapmaz.
- [ ] Tüm görünen butonlar/sekme/filtreler gerçek davranışa bağlıdır ve manuel/widget testleri vardır.

## 10. Uygulama notları ve dosya bağlantıları

- `project.md`: özellik kapsamı, domain hesaplamaları, route listesi ve Clean Architecture sınırları için otorite.
- `design.md` (bu belge): ekran hiyerarşisi, düzen, durumlar ve kullanıcı etkileşimleri.
- `tema.md` (sonra): HEX, Material 3 color scheme, typography, spacing, radius, dark/light token'ları.
- `data.md` (sonra): demo JSON kayıt şemaları, tarif/malzeme/fiyat kaynak işaretleri, opsiyonel Qwen kontratları.
- `agent.md` (sonra): geliştirme ajanının uygulama sırası ve kalite/test kuralları.

**Son tasarım ilkesi:** Kullanıcının gördüğü her veri kaynağı ve her aksiyon açıklanabilir, tutarlı ve çalışır olmalıdır. Kapsam dışı işlevler uygulamada gösterilmez.
