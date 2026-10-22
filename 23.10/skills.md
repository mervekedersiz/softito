Kendime Söz — Flutter Teknik Rehberi ve Düzeltilmiş Terimler Sözlüğü
Bu dosya proje geliştiricisi ve AI ajanı için teknik el kitabıdır. Ürün kuralları PROJECT.md, çalışma kuralları AGENTS.md içindedir. Kurulabilir bir ChatGPT skill paketi değildir. Kod parçaları konuyu gösteren örneklerdir; tamamlanmış/derlenmiş uygulama olarak sunulmaz. Kullanılacak SDK ve paket sürümünde API uyumu doğrulanır.
1. Dart Temelleri
const ve final
const, derleme zamanında bilinebilen sabit değer içindir. Sabit nesne değiştirilemez; eşdeğer const ifadeler kanonik bir nesneyi paylaşabilir. Const widget kullanımı gereksiz widget güncellemelerini azaltabilir; bütün alt ağacın hiçbir koşulda build olmayacağı veya sabit miktarda pil kazancı sağlayacağı garantisi değildir. Alt widget kendi state veya inherited bağımlılığı nedeniyle yine güncellenebilir.

final, değişkene bir kez atama yapılmasını sağlar. Değer çalışma zamanında belirlenebilir. Referansın sabitliği, referans verilen nesnenin içeriğinin sabitliği değildir.
const defaultTarget = 8;
final openedAt = DateTime.now();
final mutable = <String>['Ders'];
mutable.add('Kitap'); // Geçerli: referans aynı, liste içeriği değişti.
final immutable = List<String>.unmodifiable(mutable);
Bu projede domain model alanları final'dır. Koleksiyonlar unmodifiable kopyadır; güncelleme copyWith ile yeni nesne üretir. Bu, tüm Dart modelleri için dilin zorunlu kıldığı bir kural değil, proje standardıdır.
late
Başlatılması ertelenen non-null değişkendir; ilk okuma öncesi atama yapılmadıysa runtime hatası verir. late final ilk atamadan sonra değişmez. Başlatıcısı olan late değişken ilk erişimde hesaplanabilir; başlatıcısız late değişkene kendiliğinden değer atanmaz.

TextEditingController gibi yaşam döngüsüne bağlı kaynaklarda initState içinde kurulabilir. Constructor'da açıkça verilebilen repository veya nullable model için late kullanma.
required
Named parametrenin çağrıda verilmesini zorunlu kılar. Tek başına non-null yapmaz; null kabulünü tür belirler. required String title null alamaz, required String? note açıkça null alabilir.
@override
Üst türdeki bir üyeyi yeniden uygulama niyetini analyzer'a bildirir. İsim veya imza yanlışsa uyarı/hata yakalamayı sağlar. Metodu ezmeyi mümkün kılan şey annotation değildir; doğru isim/imzadır. Üst metodun da çalışması gerekiyorsa ayrıca super.method() çağrılır; override bunu otomatik yapmaz.
Null güvenliği
İfade	Anlam
habit?.title	Habit null ise null döner
title ?? 'Adsız'	Sol null ise varsayılanı seçer
note ??= ''	Değişken null ise atar
habit!	Null olmadığını ileri sürer; null ise runtime hatası
...?items	Liste null değilse elemanlarını yayar


Route ID eksikse id ?? '1' gibi başka kaydı açan fallback kullanılmaz. Eksik/yanlış ID açıkça ele alınır. Görsel bir başlık için varsayılan metin kullanılabilir; veri kimliği için kullanılamaz.
Spread ve koleksiyonlar
final suggestions = <String>[
  'Kitap oku',
  ...studySuggestions,
  if (includeKindness) 'Birine yardım et',
];
Spread bir iterable'ın elemanlarını dış koleksiyona ekler. ...habits.map(...) kısa listelerde uygundur; büyük listelerde widget'ları önceden üretmek yerine ListView.builder kullanılır.
2. Senkron, Asenkron ve Import
- Senkron: Elindeki veriden seri, yüzde veya kalan adım hesaplamak. Sonucu doğrudan döndürür.
- Future<T>: DB okuma/yazma, bildirim planlama veya tercihi kaydetme; tek sonucun daha sonra gelmesi.
- Stream<T>: DB değiştikçe listenin tekrar gelmesi.
- async kodu otomatik olarak ayrı CPU thread'ine taşımaz. Ağır hesap gerekiyorsa ayrıca isolate değerlendirilir; bu projede temel hesaplar küçük tutulur.
// features/progress/domain/services/completion_rate_calculator.dart
double? completionRate({required int completed, required int planned}) {
  if (planned == 0) return null;
  if (completed < 0 || completed > planned) {
    throw ArgumentError('Tamamlama sayısı plan aralığında olmalı.');
  }
  return completed / planned;
}
Başka dosyada gerçek pubspec paket adı kullanılarak import edilir:
import 'package:kendime_soz/features/progress/domain/services/completion_rate_calculator.dart';
Widget algoritmayı yeniden yazmaz; controller/usecase ürettiği özeti gösterir. UI'da Future işlemini await et; başarıdan sonra mesaj göster. State güncelleyen callback async olamaz: setState(() async { ... }) yanlıştır.
3. Model, Controller, UseCase ve Repository
Katman	Kendime Söz örneği	Yapmaması gereken
Domain entity	Habit, Reward, DailyCheckIn	Flutter/SQL bağımlılığı
Data model/record	Drift satırını taşıyan HabitRecord	UI davranışı
Mapper	Record → entity dönüşümü	Ödül kazanım kararı
Usecase	RecordProgress, ActivateReward	Snackbar/navigation
Repository interface	JourneyRepository	Drift sınıfı dışarı sızdırmak
Repository implementation	JourneyRepositoryImpl	Widget oluşturmak
Controller	CompletionController	SQL ve seri algoritması
Widget	HabitCard	Doğrudan DB yazmak


Modelin küçültülmüş örneği:
class HabitSummary {
  const HabitSummary({
    required this.id,
    required this.title,
    required this.completed,
  });

  final String id;
  final String title;
  final bool completed;

  HabitSummary copyWith({String? title, bool? completed}) => HabitSummary(
    id: id,
    title: title ?? this.title,
    completed: completed ?? this.completed,
  );
}
Bu tam Habit modeli değildir; tam alanlar PROJECT.md'de yer alır. Nullable alanı temizlemesi gereken copyWith'te value ?? oldValue yeterli değildir; null atamayı “parametre verilmedi” durumundan sentinel veya açık clear metodu ile ayır.

Repository saf Dart arayüzünde Future<Result<CompletionOutcome>> recordProgress(...) gibi sonuç sunar. Result; Success veya Failure, AppFailure ise validation/storage/notFound/conflict/permission/platform gibi türleri taşır. Teknik exception data katmanında çevrilir. Kullanıcı metni presentation'a aittir.

Tamamlama transaction'ı için işlem sırası:
1. ID, planlı yerel gün ve hedef değerini doğrula.
2. Check-in'i benzersiz habit/day anahtarıyla bul veya oluştur.
3. İlerlemeyi güncelle; hedefe ulaştıysa firstCompletedAt yalnızca ilk kez yazılsın.
4. Uygun aktif ödül ve bu check-in'e ait eski contribution durumunu kontrol et.
5. Gerekliyse tek contribution oluştur/geri etkinleştir; başka bilete taşıma.
6. İlerlemeyi sorgulayarak ödül durumunu ve rozetleri güncelle.
7. Commit et; başarılı outcome döndür. Hata varsa bütün DB değişiklikleri rollback olur.
8. Controller state günceller; UI gerçek başarıyı gösterir. Bildirim yeniden kurma gerekiyorsa ayrı servis sonucu ayrıca raporlanır.
4. Provider ve Riverpod Ne İş Yapar?
İkisi de veriyi/servisleri erişilebilir kılmaya ve değişince ilgili arayüzü güncellemeye yardımcı olur. Aynı paket değildir.
Konu	provider paketi	Riverpod
Temel yaklaşım	Widget ağacındaki sağlayıcılar	Provider tanımları ve ProviderScope
Erişim	Çoğunlukla BuildContext ile read/watch	Ref üzerinden read/watch/listen
Yaygın değişim modeli	ChangeNotifier + notifyListeners	Notifier/AsyncNotifier + immutable state
Test	Widget/provider kurulumu	ProviderContainer ve override
Projedeki karar	Kullanılmayacak	Tek ana durum/DI çözümü


Dikkat: Riverpod'daki Provider sınıfı ile provider adlı paket aynı şey değildir.
- ref.watch(provider): Veriye abone olur; değişim ilgili consumer'ı günceller.
- ref.read(provider): O an erişir; event callback'inde controller komutu için kullanılır.
- ref.listen(provider, ...): Geçişe tepki verir; örneğin başarı snackbar'ı. Veriyi UI'da göstermek için watch yerine kullanılmaz.
- select: Gerekirse state'in küçük bir alanını izler. Ölçmeden her yere optimizasyon eklenmez.
- .family: ID veya filtreye göre sağlayıcı üretir; habit detail için uygundur.
- .autoDispose/yaşam süresi API'si: İhtiyaç kalmayınca abonelik bırakılır. Kalıcı focus kaydı DB'dedir; ekrandan çıkınca oturum silinmez.
Örnek komut yönü: buton → ref.read(completionControllerProvider.notifier).complete(habitId) → usecase → DB → gözlenen listeler. Widget ayrıca rewardCount++ yapmaz.

Riverpod'un AsyncNotifier build() metodu başlatma/bağımlılık işlevi görebilir. Bu, Flutter widget'ının Widget build(BuildContext) metoduyla aynı kural değildir. “Build'de asla yükleme yok” kuralı widget build'i için geçerlidir; iki metodu karıştırma.
5. setState, ValueNotifier ve InheritedWidget
setState
Callback senkron çalışır; bağlı State'in Element'ini yeniden build için işaretler. Bu State'in build'inin ürettiği subtree yeniden değerlendirilebilir. Yalnızca ValueListenableBuilder'a sinyal gönderdiği iddiası yanlıştır.

Kapsamı küçük tut; lokal bir açılır bölüm için uygundur. Build çağrısı ile tüm ekranın her pikselinin yeniden boyanması aynı şey değildir.
ValueNotifier<T>
Tek bir değer taşır. Yeni değer == karşılaştırmasına göre farklıysa dinleyicilere haber verir. Listeyi aynı nesne üzerinde add ile değiştirmek setter çağırmaz, bildirim üretmez.
final selectedIds = ValueNotifier<List<String>>([]);
selectedIds.value = [...selectedIds.value, 'habit-id'];
// Sahibi işi bitince: selectedIds.dispose();
ValueListenableBuilder bu notifier'ı dinler. setState ile ValueNotifier iki ayrı mekanizmadır. Projedeki kalıcı alışkanlık listesi için Riverpod/DB kullanılır; bu örnek küçük yerel seçim içindir.
InheritedWidget
Alt widget'ların üstteki ortak veriyi, aradaki widget'lara tek tek parametre taşımadan bulmasını sağlayan Flutter mekanizmasıdır. Bağımlı olarak erişen widget'lar updateShouldNotify koşuluna göre yenilenir. Theme.of(context) bu tür mekanizmalardan yararlanır. Bu projede ayrıca özel InheritedWidget mimarisi kurmak gerekmez.
6. Widget Yaşam Döngüsü
Metot	Ne zaman?	Bu projede
initState	Her State nesnesi için ilk kez	TextEditingController/AnimationController kurulumu
didChangeDependencies	initState sonrası; bağlı inherited veri değişince	Bağımlılığa bağlı UI ayarı; gerekirse bir kez çalıştırma koruması
didUpdateWidget	Aynı State'e yeni widget konfigürasyonu gelince	Değişen habitId/controller girdisine uyarlama
build	İlk görüntüde ve rebuild gerektiğinde	Yalnızca UI üretme
dispose	State kalıcı olarak çıkarılınca	Sahip olunan kaynakları temizleme


- BuildContext initState'te vardır; fakat inherited bağımlılık kaydı isteyen işlemler o aşamada yapılmaz. Navigator işlemi sırf context var diye başlatılmaz. Başlangıç yönü merkezi router/bootstraptadır.
- didChangeDependencies birden fazla kez çalışabilir; her çağrıda DB'yi doldurmak veya kontrolsüz istek göndermek yanlıştır.
- Widget build içinde setState, DB yazma, bildirim planlama, Timer oluşturma veya modal açma yoktur.
- dispose içinde controller.dispose, timer.cancel, subscription.cancel yapılır; Flutter State için super.dispose son çağrıdır.
- İşletim sisteminin uygulamayı öldürmesi dispose çağrısını garanti etmez. Veriyi sadece dispose'da kaydetme.
- Await sonrası widget'a erişilecekse if (!context.mounted) return; gibi kontrol kullan. Global oturumu tek widget'ın mounted durumuna bağlama.
7. Material 3 ve Tema
Renk rolü	Kullanımı
primary	Ana eylem ve marka vurgusu
onPrimary	Primary üstündeki okunabilir yazı/ikon
primaryContainer	Vurgunun yumuşak kapsayıcı rengi
onPrimaryContainer	Container üzerindeki içerik
surface	Sayfa/kart yüzey ailesi
onSurface	Yüzey üzerindeki içerik
outlineVariant	Hafif sınır ve ayırıcı


ThemeMode.system, sistemin açık/koyu parlaklık tercihini izler; iOS/Android arayüzünü veya marka rengini otomatik seçmez. ThemeData ve darkTheme ayrı tanımlanır. Dynamic color ayrıca karar verilmesi gereken farklı bir özelliktir; ilk sürümde gerekmez.
final color = Theme.of(context).colorScheme.primary;
final shadow = Colors.black.withValues(alpha: 186 / 255);
withOpacity de 0.0–1.0 aralığı bekler; 1–255 iddiası yanlıştır. Yeni SDK'nın desteklediği API'de withValues kullanılır. 186/255 yaklaşık 0.73'tür. Aynı gölge değerini her karta gelişigüzel uygulama; tema token'ı oluştur.
8. Düzen ve Liste Bileşenleri
- Expanded: Row/Column/Flex'in ana ekseninde ayrılan alanı doldurur; tight fit kullanır. Tüm ekranı her durumda kaplamaz.
- Flexible: Varsayılan loose fit ile ayrılan alandan daha küçük kalabilir. Her ikisi de flex oranı alabilir; 2:1 uygun ana eksen alanını o oranda paylaştırır.
- Stack: Çocukları üst üste yerleştirir. Positioned uygun Stack parent-data ilişkisi içinde top/right gibi konumlar verir. Bilet rozeti örneğinde uygundur.
- ListView.builder: Öğeleri ihtiyaç oldukça üretir; viewport yanında cache alanındaki öğeler de kurulabilir. “Tam beş kart bellekte” garantisi yoktur. KeepAlive gibi davranışlar da saklamayı etkiler.
- ListView(children): Çocuk listesini önceden oluşturur; büyük listede pahalıdır. Telefonun kesin donacağı gibi mutlak sonuç çıkarılmaz.
- shrinkWrap: Kaydırma yönündeki boyutu içeriğe göre belirler; sonsuz scroll'u otomatik kapatmaz. Yeniden ölçüm maliyeti vardır. Büyük listede Expanded veya sliver düzeni tercih edilir.
- SingleChildScrollView içindeki kısa liste gerekiyorsa shrinkWrap ve uygun scroll physics birlikte düşünülür. Büyük iç içe kaydırma tasarımı kurulmaz.
- GestureDetector: Dokunma/sürükleme hareketlerini algılar; kendi başına Material dalga efekti çizmez. Callback ile görsel tepki eklenebilir.
- InkWell: Material yüzeyinde ripple sağlar. Aradaki opak Container/Decoration efekti örtebilir; Ink veya uygun Material düzeni kullanılır.
9. Form ve Doğrulama
GlobalKey<FormState> FormState'e erişir; bütün alan değerlerini otomatik bir nesne halinde döndürmez. Alan verisi controller/onChanged/onSaved ile alınır. Key build içinde yeniden oluşturulmaz.
final formKey = GlobalKey<FormState>();

String? validateTitle(String? value) {
  final text = value?.trim() ?? '';
  if (text.length < 2) return 'En az 2 karakter yaz.';
  if (text.length > 60) return 'En fazla 60 karakter yaz.';
  return null;
}

// Kaydet callback'i içinde:
// if (!(formKey.currentState?.validate() ?? false)) return;
// await controller.save(...);
TextFormField.validator hata varsa String, geçerliyse null döndürür. validate() bağlı alanları kontrol eder. save() ayrı işlemdir. TextEditingController widget'ın sahipliğindeyse dispose edilir.

Doğrulamalar:
- Başlık trim sonrası uzunluk; sadece boşluk kabul edilmez.
- En az bir tekrar günü; check hedefi 1; count pozitif tamsayı; duration pozitif dakika.
- Hedef dakika 1–1440, adet 1–100000, not 0–500 karakter. Kullanıcı formunda açık sınır metni gösterilir.
- Hatırlatma saat/dakikası geçerli aralıkta; izin sonucu ayrı durumdur.
- Ödül hedefi 1–1000; etkinleştirme için en az bir uygun alışkanlık ve başka aktif ödül bulunmaması.
- Planlanan ödül zamanı gelecekte; yer ve not isteğe bağlıdır.
- Kaydet sırasında buton pending; hata varsa girdiler korunur. Başarıdan önce sheet kapanmaz.
10. Animasyon
Bileşen / eğri	Amaç
AnimatedContainer	Boyut, padding, dekorasyon, renk gibi özellikler arasında geçiş
AnimatedOpacity	Opaklık geçişi; görünmez çocuk yine etkileşim alabilir
AnimatedScale	Küçük tamamlanma tepkisi
AnimatedAlign	Hizalama geçişi
Curves.linear	Sabit ilerleme
Curves.easeInOut	Yumuşak başlangıç/bitiş
Curves.bounceOut	Sekme; sınırlı kutlama kullanımında
Curves.elasticOut	Yaylanma; reduce motion'da kaldırılır


Opacity sıfır olduğunda dokunmayı kapatmak gerekiyorsa IgnorePointer veya koşullu widget kullanılır. Bilet animasyonu kalıcı earned geçişinden sonra bir kez oynar. Geri dönülen ekranda her build'de yeniden kutlama olmaz. Focus kalan süre hesaplaması görsel animasyondan bağımsızdır.
11. GoRouter ve Akıllı Yönlendirme
- go('/ders'): Hedef konumun route eşleşmelerine göre sayfa yığınını kurar. Her koşulda “tüm geçmişi temizler” diye genellenmez.
- push('/habits/$id'): Mevcut navigator yığınına detay ekler. Geri okunun görünmesi AppBar/navigator koşullarına bağlıdır; otomatik garanti değildir.
- pop(): En üst uygun route'u kapatır; pop mümkün değilse ana hedefe fallback kullanılır.
- StatefulShellRoute.indexedStack: Üç sekmenin ayrı navigator dallarını korur. goBranch sekme değiştirir; ShellRoute tek başına aynı branch davranışını garanti etmez.
- pathParameters['id']: Zorunlu kayıt kimliği; queryParameters opsiyonel filtre/ay seçimi içindir.
Örnek rota tanımı fikri:
GoRoute(
  path: '/habits/:id',
  builder: (context, state) {
    final id = state.pathParameters['id'];
    if (id == null || !isValidUuid(id)) {
      return const InvalidRoutePage();
    }
    return HabitDetailPage(habitId: id);
  },
)
Buradaki sayfalar/validator uygulamada ayrıca yazılacaktır. ID doğru biçimde olsa bile kayıt bulunmayabilir; controller notFound döndürür. ID session token değildir; route'a gizli bilgi konmaz.

Bootstrap state değişimi → router refresh → redirect → doğru hedef. Riverpod ile GoRouter köprüsü, ilgili state'i dinleyen Listenable/adaptör ile kurulabilir; listener dispose edilir. Her state değişiminde router'ı yeniden yaratma. Redirect içinde DB yazma, snackbar veya yeni onboarding kaydı oluşturma yoktur.

Native splash ilk statik yüzeydir. Flutter bootstrap animasyonu yükleme/hata durumunu gösterir. Başlangıç exception'ını yakalayıp sonsuza kadar animasyon oynatmak doğru hata yönetimi değildir: kısa açıklama ve gerçek retry olmalıdır.
12. Yerel Depolama Karşılaştırması
Araç	Uygun kullanım	Bu projede
SharedPreferences	Basit key-value tercihler; gizli olmayan küçük veri	Tema, onboarding ve başlangıç sekmesi
FlutterSecureStorage	Platform güvenlik mekanizmalarıyla küçük gizli veriler	Şimdilik gerekmez; token yok
Hive/Isar	Nesne/NoSQL yerel depolama seçenekleri	Seçilmedi; ek paralel DB yok
Drift/SQLite	İlişkili kayıt, transaction, rapor sorgusu ve migration	Ana veri kaynağı


Hız ve güvenlik için her platformda geçerli kesin “en hızlı/en güvenli” sıralaması yoktur. Secure storage hassas küçük veri içindir; büyük alışkanlık geçmişini oraya koyma. SharedPreferences parola/token deposu değildir. Yerel DB yedeklenebilir veya cihaz erişimiyle okunabilir; şifreleme kendiliğinden var sayılmaz.

Şema değişince schemaVersion artırılır, migration yazılır ve önceki veriyle test edilir. Kullanıcı verisini silip açılabilmesini sağlamak başarılı migration değildir.
13. Başarı, Hata ve Asenkron UI
Durum	Görünüm	Eylem
İlk yükleme	Sakin gösterge/kısa animasyon	Veri beklenir
Veri var	Gerçek liste	Etkileşimler açık
Boş	“İlk küçük sözünü ekle”	Alışkanlık ekle
Satır işlemi sürüyor	İlgili butonda pending	Çift basma engellenir
Başarı	Güncellenen gerçek veri + kısa feedback	Sonraki işlem
Doğrulama hatası	Alan altında açıklama	Girdiyi düzelt
Depolama hatası	İşleme özel mesaj	Girdiyi koru, tekrar dene
Bildirim reddi	“Kayıt duruyor, hatırlatma kapalı”	Ayarlar / tekrar dene
Kayıt bulunamadı	Anlaşılır metin	Geri/ana sayfa


İyimser UI zorunlu değildir; bu projede kritik ödül/tamamlama için commit sonrası güncelleme tercih edilir. Kullanılırsa rollback gerekir. Hata halinde başarı animasyonu gösterilmez.
14. Ödül ve Seri İçin Geliştirme Kontrolü
- Bugün planlı mı, doğru plan sürümü mü? Hedefe ulaşıldı mı?
- Aynı habit/day kaydı zaten var mı? İlk tamamlanma zamanı korunuyor mu?
- Ödül o ilk tamamlanma anında aktif miydi; alışkanlık seçili ve uygun muydu?
- Katkı başka bilete ayrılmış mı? Geri alma eski bileti mi etkiliyor?
- Tek aktif ödül sınırı hem etkinleştirmede hem earned geri almada korunuyor mu?
- Kullanılmış bilet geçmişi düzeltildiğinde eski katkı başka bilete dönüşüyor mu? Dönüşmemeli.
- Seri sadece planlı günler üzerinden mi? Bugünkü tamamlanmamış hedef gün bitmeden seriyi kırıyor mu? Kırmamalı.
- Oran geleceği ve plan dışı günü dışlıyor mu? Sıfır payda yüzde 0 diye sunuluyor mu? Sunulmamalı.
15. Öğretmene Anlatılabilecek Örnek Akış
1. “25 dakika ders çalış” alışkanlığı oluştur; pazartesi/çarşamba/cuma seç.
2. “8 adım sonunda müze gezisi” ödülünü oluştur ve bu alışkanlığa bağlayarak etkinleştir.
3. Bugün planlıysa sayacı başlat; uygulama kapanınca oturum kaydının korunduğunu göster.
4. Oturum tamamlanınca günlük hedef tamamlanır; aynı gün tekrar çalışmak süreyi artırır ama ikinci ödül adımı üretmez.
5. Detaydan seri/takvimi, İlerlemem'den haftalık oranı göster.
6. Sekiz uygun alışkanlık-gün adımı sonunda bilet açılır; Planla ve Ödülümü kullandım çalışır.
7. Bildirim iznini reddederek uygulamanın diğer işlevlerinin çalıştığını göster.
Sunum için hızlandırılmış sayaç veya önceden hazırlanmış geçmiş gerekiyorsa yalnızca açıkça ayrılmış test fixture'ında kullan; final üretim davranışı gibi sunma.
16. Geliştirmeyi Başlatmak İçin AI Talimatı
PROJECT.md, AGENTS.md ve SKILLS.md dosyalarını oku. Kendime Söz Flutter uygulamasını üç ana bölüm ve beş ana ekran türüyle geliştir. Clean Architecture katmanlarını, Riverpod controller'larını, GoRouter akıllı yönlendirmesini ve Drift kalıcı verisini kur. Önce alışkanlık oluşturma–listeleme–tamamlama–kapatıp açma dikey dilimini tamamla; ardından seri, analiz, ödül bileti, odaklanma sayacı ve yerel bildirimleri uygula. Her görünür buton gerçek işlem yapsın. Başarı, hata, yükleme ve boş durumlarını göster. Sahte demo veri, boş callback ve “yakında” ekleme. Kritik iş kurallarını test et; çalıştırılamayan kontrolleri açıkça raporla.

17. Resmi Kaynaklar
- Dart: https://dart.dev/language/variables ve https://dart.dev/null-safety
- Widget lifecycle: https://api.flutter.dev/flutter/widgets/State-class.html
- setState: https://api.flutter.dev/flutter/widgets/State/setState.html
- ValueNotifier: https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html
- Tema: https://api.flutter.dev/flutter/material/ThemeMode.html
- Riverpod: https://riverpod.dev/docs/introduction/getting_started
- GoRouter: https://pub.dev/packages/go_router
- Drift: https://drift.simonbinder.eu/
- Bildirim: https://pub.dev/packages/flutter_local_notifications
- Splash: https://pub.dev/packages/flutter_native_splash