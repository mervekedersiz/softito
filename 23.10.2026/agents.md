Kendime Söz — Geliştirici ve AI Ajan Kuralları
Bu dosya Flutter proje kökünde AGENTS.md adıyla bulunur. Bir uygulama geliştirme talimatıdır; ürün gereksinimleri PROJECT.md, teknik açıklamalar SKILLS.md içindedir. Henüz oluşturulmamış uygulamanın var olduğunu veya test edildiğini varsayma.
1. Görev ve Ürün Sınırı
Kendime Söz uygulamasını PROJECT.md kapsamına göre uçtan uca geliştir. Üç bölüm sabittir: Maneviyat ve İyilik, Ders ve Gelişim, Kendime Zaman. Beş ana ekran türü ve yardımcı sheet/dialog düzenini koru.
- Her görünür eylem çalışmalı; boş callback, “yakında”, sahte başarı, rastgele istatistik, üretimde demo tamamlama yasaktır.
- Örnek alışkanlık şablonları yalnızca kullanıcının seçimiyle eklenir. Tamamlama ve ödül geçmişi kendiliğinden doldurulmaz.
- Kullanıcı adına mesaj gönderme, GitHub push, bağış, ödeme, gerçek rezervasyon veya satın alma yapma. Bunlar uygulama işlevi değildir.
- İbadeti zorunlu kılma, sıralama veya dini başarı skoru ekleme. Ödül katılımını varsayılan kapalı tut.
- İlk sürüme backend, login, sosyal ağ, konum servisi, yapay zeka koçu veya canlı mekan API'si ekleme.
- Temel dinlenme ve ihtiyaçları hedefe bağlama; özel ödül ile normal molayı ayır.
- Kullanıcıya yönelik bütün metinler anlaşılır Türkçe; sınıf/dosya/değişken adları İngilizce ve tutarlı olsun.
2. Başlangıçta Yapılacaklar
1. PROJECT.md ve SKILLS.md'yi oku. Mevcut projede pubspec.yaml, lib/, platform ayarları ve mevcut testleri incele.
2. Flutter/Dart ve paket sürümlerini yerel ortamdan belirle. Sürümlere uymayan API'leri ezberden yazma; resmi belgeleri kontrol et.
3. Kullanıcı verisini ve mevcut çalışan özellikleri koru. Alakasız dosyaları yeniden düzenleme.
4. Flutter projesi yoksa mobil proje oluştur; varsa üstüne ikinci proje açma.
5. Kapsamı küçük tamamlanabilir adımlara ayır; her adımda gerçek kalıcı veriyle çalışan bir akış bitir.
6. İlk dikey dilim: alışkanlık oluştur → DB'ye yaz → listele → tamamla → kapat/aç → tamamlamayı doğrula.
3. Mimari Kurallar
Widget → Controller → UseCase → Repository arayüzü
                                  ↑
                        Repository implementasyonu → LocalDataSource → Drift
- Domain saf Dart; Flutter, Riverpod, Drift, platform servisi ve BuildContext import etmez.
- Presentation domain'i bilir, data implementasyonlarını bilmez. Bağlama app/di içindedir.
- Data domain arayüzünü uygular; domain data'yı import etmez.
- Widget içinde SQL, DB açma, ödül hesabı, seri algoritması veya JSON serileştirme yazma.
- Controller içinde navigation/snackbar/dialog veya BuildContext tutma. UI sonucu dinleyip gösterir.
- Çapraz feature yazımları journey usecase/repository üzerinden tek DB transaction'ına girer.
- UI → data source kestirmesi yapma. Feature'lar birbirinin data klasörüne erişmez.
- İş kuralı fonksiyonunu farklı sayfalara kopyalama. Domain servisini import et; katman sınırlarını koru.
- Küçük ayar veya salt okunur veri için gereksiz katman ve boş usecase dosyaları üretme. Kritik iş akışlarında katmanları atlama.
4. Durum Yönetimi ve Controller Sözleşmesi
Tek ana çözüm Riverpod'dur. provider paketi ve Riverpod aynı iş için birlikte kullanılmaz.
- ProviderScope köktedir. Repository, DB, Clock ve platform servisleri provider ile enjekte edilir.
- Notifier senkron görünüm tercihleri için; AsyncNotifier asenkron komut/başlatma için; StreamProvider DB gözlemleri için kullanılır. Kurulu sürümün API'sini doğrula.
- İzleme ref.watch; olaydan komut ref.read(...notifier); tek seferlik UI etkisi ref.listen ile yapılır. Listener'ın tekrar bildirim üretmesini action ID veya gerçek state geçişiyle engelle.
- Kalıcı veri için tek kaynak DB'dir. Liste controller'ı, detay controller'ı ve ödül controller'ı birbirinden bağımsız sayacı artırmasın.
- Mutation sırasında sayfanın tüm verisini silen tam ekran loading yerine ilgili satır/form pending olsun. ID bazında çift işlem kilidi tut.
- Controller usecase sonucunu immutable state'e çevirir. AsyncValue yükleme/veri/hata hallerini taşıyabilir; form mutation sonucu ayrıca modellenebilir.
- Ekranın yaşam süresi biten listener/timer/controller dispose edilir. Global aktif focus oturumu sayfa kapanınca kaybolmaz; UI tick aboneliği kapanabilir.
- setState yalnızca lokal görsel state için kullanılabilir: seçili emoji, formun açık bölümü gibi. Ortak veri için kullanılmaz.
- ValueNotifier küçük bağımsız UI durumunda mümkündür; Riverpod verisinin ikinci kopyası yapılmaz.
5. Modeller, Fonksiyonlar ve Import Düzeni
- Domain modellerinde alanlar final; dışarıdan gelen List/Set/Map değiştirilemez kopyaya çevrilir.
- final List tek başına liste içeriğini immutable yapmaz. copyWith ile yeni nesne üret.
- Gerekli named parametrelerde required; gerçekten opsiyonel alanda nullable tür kullan.
- dynamic, late ve ! zorunlu olmadıkça kullanılmaz. Gerekçesiz force unwrap yazma.
- Const uygulanabilen constructor ve sabit widget'larda const kullan; runtime veriyi const yapmaya çalışma.
- Dart snake_case dosya, PascalCase tür, camelCase üye; private üyelerde _.
- Import grupları: Dart SDK → Flutter/paket → proje. Klasörler arası package:kendime_soz/... tercih et; relative/absolute stratejisini tutarlı uygula. Proje adı farklıysa gerçek pubspec adına uyarla.
- Salt tarih, seri ve oran hesabı senkron saf fonksiyon olur. Disk, bildirim ve kalıcı komut Future; reaktif DB okuması Stream olur.
- Her fonksiyonu gereksiz async yapma. Await edilmemiş Future bırakma; bilinçli arka plan işinde hata işleme zorunlu.
- setState(() async { ... }) yazma. Await sonrası UI erişiminde context.mounted kontrol et.
- Hata mesajını UI'da göstermek için exception.toString() kullanma. Teknik sebebi AppFailure koduna, kullanıcı metnine ve gerekli debug loguna ayır.
- Kişisel notları, ibadet isimlerini veya kullanıcı kayıtlarını loglama. ID bile yalnızca gerekli debug bağlamında kullanılır.
6. Depolama, Transaction ve Veri Bütünlüğü
- Ana veri Drift/SQLite'dadır. SharedPreferences yalnızca kritik olmayan tercihler içindir.
- Tüm tablolar ve kısıtlar PROJECT.md veri sözleşmesine uyar. schemaVersion ve migration stratejisi ilk günden bulunur.
- Release migration'da drop-and-recreate veya sessiz veri sıfırlama yapma.
- Tamamlama, katkı, ödül durum geçişi, focus allocation ve ilgili rozet güncellemesi gerektiğinde aynı DB transaction'ında yapılır.
- Bellekte pending kilidi tek başına yeterli değildir: UNIQUE(habitId,localDate), UNIQUE(checkInId), tek aktif ödül ve tek aktif oturum kısıtları DB/transaction düzeyinde güvenceye alınır.
- Ödül adımı DB katkısından türetilir; UI sayaç artırmaz. Check-in ilk tamamlanma anı geri almada silinmez.
- Arşivleme geçmişi korur. Kalıcı silme ödül ilişkilerini tombstone/snapshot ile korur; tek transaction'dır.
- Bildirim platform çağrısı DB transaction'ına dahil değildir. Önce istenen ayar kaydedilir, servis çalışır, sonuç durumuna yazılır. İki sistem için sahte atomiklik iddia etme.
- UUID kalıcı kimliktir. Bildirim için integer ID ayrıca saklanır; liste index'i veya kararsız hash kullanma.
- Uygulama çevrimdışıyken temel özelliklerin tümü çalışır. İnternet hatası ekranı uydurma; gerçek yerel hatayı açıkla.
7. Tarih, Seri, Sayaç ve Ödül Kuralları
- PROJECT.md algoritmaları tek doğru kaynaktır. Clock soyutlaması enjekte et; iş kuralı içinde rastgele DateTime.now() çağrısı dağıtma.
- UTC timestamp ve yerel gün anahtarı farklı şeylerdir. Yerel takvim günü DST nedeniyle her zaman 24 saat değildir.
- Tekrarlanmayan günler seri bozmaz. Bugünkü hedefin vadesi gün sonunda biter.
- Plan/uygunluk değişikliği yarından geçerli; geçmişe yeni hedef uygulanmaz. Arşiv yaşam döngüsü de sürümlenir.
- Geçmiş gün manuel tamamlama ilk sürümde yoktur. Gelecek güne tamamlama yazılmaz.
- İlk sürümde tek aktif ödül. Geçmiş tamamlamayı yeni bilete taşıma, fazladan dakika için çoklu adım verme.
- Earned/planned geri alma ve kullanılan bilet düzeltmesi kuralları atlanamaz. Kullanıcıya etkisini işlemden önce söyle.
- Sayaç tick sayısıyla ölçülmez; başlangıç/birikmiş süre ve kalıcı oturumdan hesaplanır. Finalize idempotent olmalıdır.
- Android/iOS'un uygulama kapalıyken sürekli Dart kodu çalıştıracağını varsayma. Bildirim yerel OS servisi, süre hesabı persisted timestamp üzerinden yapılır.
- Zaman dilimi değişiminde geçmişi yeniden tarihleme. Planlı bildirimleri yenile, gün/resume hesaplarını kontrol et.
8. Router, Splash ve Yaşam Döngüsü
- MaterialApp.router ve tek GoRouter instance kullan. Beş ekran ve üç branch sözleşmesini koru.
- Alt menü StatefulShellRoute.indexedStack ve goBranch; detay push; ana hedef go; geri canPop kontrolüyle pop.
- pathParameters['id'] ID için; query yalnızca opsiyonel filtre/ödül sheet hedefi için. Route ID'si auth token değildir.
- UUID biçimi yanlış, kayıt silinmiş veya kategori geçersizse ayrı açıklayıcı durum üret. Yanlış ID yerine hardcode kayıt seçme.
- Başlangıç durumu router refresh kaynağına bağlanır. Onboarding bitişi veya bootstrap sonucu değişince redirect bir kez doğru hedefe gider.
- Kritik DB hatasında onboarding'e veya ana sayfaya yönlendirme yapma. Flutter hata görünümü ve retry sun.
- Native splash'i uzun disk işlemine bağlı sonsuza kadar tutma. İlk Flutter bootstrap karesine geç; başlatma hatası görülebilsin.
- flutter_native_splash preserve/remove runtime API'si kullanılıyorsa paket normal dependencies içindedir. remove başarı ve hata yollarında garanti edilir.
- Build içinde navigation, modal açma, setState veya veri yazma yapma. UI etkileri listener veya uygun post-frame callback ile, tekrar açılma korumasıyla çalışır.
- initState'te controller kurulabilir; inherited dependency gerektiren işlemler didChangeDependencies'e, router kararları merkezi bootstrap'a gider.
- Dispose'da sahip olunan kaynakları bırak; super.dispose() son çağrıdır. Ortak provider kaynağını tek widget kapatmasın.
9. Arayüz ve Geri Bildirim Kalitesi
- Material 3, ColorScheme, Türkçe metinler, emoji + metin, üç bölüme uygun sıcak ama sakin tasarım.
- Başarı yalnızca DB commit sonrası gösterilir. Başarısız kayıtta kartı tamamlandı bırakma; form girdilerini kaybetme.
- Loading/empty/error/success her veri akışında tanımlıdır. Hata görünümü hem kısa metin hem gerçek retry sunar.
- Görsel animasyon hata açıklamasının yerine geçmez. “Bir sorun oluştu” tek başına yeterli değildir; kullanıcı neyi tekrar deneyebileceğini anlasın.
- Uzun listelerde ListView.builder; kısa form için scrollable sheet. Sınırsız iç içe scroll ve gereksiz shrinkWrap kullanma.
- InkWell için Material yüzeyi; minimum 48 dp hedef; yeterli kontrast; büyük font ve ekran okuyucu.
- Animasyonları küçük subtree ile sınırla; reduce motion desteği ekle. Her butonda konfeti oynatma.
- withOpacity(186) yazma; alfa 0–1 aralığındadır. Destekleyen SDK'da withValues(alpha:186/255) kullan.
- ThemeMode.system açık/koyu sistem parlaklığını izler; Android/iOS tasarımını otomatik seçtiğini iddia etme.
- Kullanılabilir olmayan özellik final menüsünde yer almaz. Yetki reddi gibi gerçek koşullarda kontrolün nedeni ve çözümü görünür olur.
10. Uygulama Sırası
1. Proje, lint, tema, ProviderScope, Clock, Result/AppFailure ve basit router iskeleti.
2. Drift tabloları, mapper, repository, migration ve temel test veritabanı.
3. Gerçek alışkanlık CRUD + kalıcı tamamlama dikey dilimi.
4. Sürümlü plan, yerel tarih, seri, oran ve ısı haritası.
5. Tek aktif ödül, katkı transaction'ı, kazanım, geri alma ve kullanım akışı.
6. Kalıcı focus session, pause/resume/finalize ve gece yarısı allocation.
7. Gerçek bildirim izin/planlama/iptal ve notification deep link.
8. Bootstrap, onboarding, native splash ve başlangıç hata senaryoları.
9. Rozet, kişisel not, tema/tercih, boş/hata/erişilebilirlik ve animasyon iyileştirmesi.
10. Android uçtan uca doğrulama, release APK ve README teslimi.
Üstteki sıra üretim ilerleyişidir; router/bootstrap'ın minimal altyapısı başta kurulabilir. Sonraki aşama için çalışan önceki akışı bozma. Kapsamı bitirmeden süslemeye tüm zamanı harcama.
11. Test ve Doğrulama
Önemli iş kurallarına test yaz; sadece getter veya framework davranışını kopyalayan anlamsız test üretme.
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format lib test integration_test
flutter analyze
flutter test
flutter test integration_test/app_flow_test.dart -d <android-device-id>
flutter build apk --release
Entegrasyon testi dosyası oluşturulunca gerçek adını kullan. Native splash yapılandırması değişince dart run flutter_native_splash:create çalıştır. --delete-conflicting-outputs yalnızca generator çıktıları için; elle yazılmış dosyaları silmek için kullanılmaz.
- Önce etkilenen domain/data/widget testlerini çalıştır, ardından gerekli teslim kontrollerini tamamla.
- Transaction rollback, tekrar gönderim, gün sınırları, plan değişimi, ödül geri alma ve kapat/aç senaryoları zorunludur.
- Platform özelliklerini yalnızca mock ile test edilmiş diye cihazda doğrulanmış sayma.
- Flutter/SDK/cihaz yoksa kaynak üretmeye devam et; çalıştıramadığın kontrolü ve nedenini son raporda yaz. Test geçti/derlendi diye uydurma.
- Compile hatasını lint ignore, her yerde try/catch veya ! ekleyerek susturma.
12. Teslim ve Çalışma Disiplini
- README gerçek kurulum adımlarını ve gereken araçları anlatsın. pubspec.lock ve migration dosyaları teslimde olsun.
- Geliştirme sonunda değişiklik, neden, yapılan testler ve kalan somut sınırları kısaca raporla.
- Harici git deposu varsa conventional commit kullan: feat, fix, refactor, test, docs. Kullanıcı istemeden uzak depoya push/merge/deploy etme.
- Kullanıcı kapsam değiştirirse ilgili belgeyi ve kabul kriterini birlikte güncelle; gizli yeni varsayım bırakma.
- Paket, servis veya ekran adını gereksiz değiştirme. Silme ve veri sıfırlama işlemlerini kullanıcıya açık onay olmadan çalıştırma.
- SKILLS.md bu projeye ait teknik el kitabıdır; kendiliğinden kurulan bir ChatGPT skill paketi değildir.