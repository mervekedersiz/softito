Kendime Söz 🎟️ — Proje Tanımı ve Uygulama Planı
Belge sürümü: 1.0 • Tarih: 22 Ekim 2026 • Platform: Flutter mobil uygulama.
Bu belge yapılacak ürünün sözleşmesidir; henüz geliştirilmiş uygulama veya çalıştırılmış test raporu değildir. AGENTS.md geliştirme kurallarını, SKILLS.md uygulama rehberini tamamlar. Üç belge proje köküne konur.
1. Proje Özeti
Kendime Söz; kullanıcının maneviyat ve iyilik, ders ve gelişim alanlarında küçük alışkanlıklar oluşturduğu, günlük ilerlemesini takip ettiği ve seçtiği kişisel deneyim ödüllerine ulaştığı çevrimdışı çalışan bir alışkanlık uygulamasıdır.

Üç ana bölüm:
1. Maneviyat ve İyilik 🤲: İsteğe bağlı ibadet, şükür, yardım ve gönüllülük hedefleri.
2. Ders ve Gelişim 📚: Ders çalışmak, soru çözmek, okumak, kod yazmak ve odaklanma oturumları.
3. Kendime Zaman 🎟️: Gezi, bisiklet, film, hobi ve rahatlama için kişisel ödül biletleri.
Ana fikir: “İç dünyama iyi geliyorum, geleceğime yatırım yapıyorum, kendime güzel anılar hediye ediyorum.”
2. Proje Amacı
- Mikro hedeflerle sürdürülebilir alışkanlıklar kazandırmak.
- Planlanan günlere göre mevcut seri ve en uzun seriyi göstermek.
- Haftalık/aylık oranları ve katkı ızgarasını anlaşılır sunmak.
- Kullanıcının kendisinin belirlediği ödüllerle ilerlemeyi somutlaştırmak.
- Ara veren kullanıcıya suçluluk yerine yeniden başlama desteği sunmak.
- Clean Architecture, controller/model ayrımı, Riverpod, GoRouter, asenkron işlemler ve kalıcı depolamayı ders projesinde birlikte göstermek.
İbadetler karşılaştırılmaz, dini başarı puanı verilmez. Kullanıcı bu alışkanlıkları ödüle dahil edip etmemeyi kendisi seçer; varsayılan kapalıdır. Normal mola, beslenme, uyku ve temel dinlenme ödül kazanma şartına bağlanmaz. Ödül özel bir kutlama veya deneyimdir.
3. Tahmini Ekran ve Sayfa Sayısı
Beş ana ekran türü kullanılır. Aynı tür farklı verilerle tekrar kullanılır; her form için yeni bir tam sayfa açılmaz.
No	Ekran türü	İçerik
1	Maneviyat ve İyilik	Bugünün listesi, tarih seçimi, ekleme, günlük ilerleme, kısa kişisel not
2	Ders ve Gelişim	Bugünün listesi, ders filtresi, odaklanma sayacı, çalışma toplamı
3	Kendime Zaman	Aktif ödül, bilet ilerlemesi, kazanılan/planlanan/kullanılan ödüller
4	Alışkanlık Detayı	ID ile kayıt, düzenleme, takvim, seri, notlar, arşivleme
5	İlerlemem	Haftalık/aylık analiz, katkı ızgarası, rozetler, kategori filtresi


Alışkanlık oluşturma/düzenleme, ödül oluşturma/düzenleme/detay/planlama ve ayarlar modal bottom sheet veya dialog olarak açılır. Küçük ekranda sheet kaydırılabilir ve klavye güvenlidir. Splash, onboarding ve başlangıç hata görünümü giriş durumlarıdır; bu beş ürün ekranına ek teknik görünümlerdir. Bu sayım öğretmene açıkça anlatılmalıdır; kesin toplam görünüm sayısı istenirse giriş adımları da sayılır.

Alt menüde yalnızca üç ana bölüm vardır. İlk iki bölümün üst kısmında “Bugün”; analiz simgesi ve ayarlar düğmesi bulunur. Varsayılan ana sayfa Ders ve Gelişimdir. Ayarlardan varsayılan bölüm değiştirilebilir; maneviyat kullanımı zorunlu değildir.
4. Temel Özellikler ve Kesin Kapsam
4.1 Alışkanlıklar
- Ekle, görüntüle, düzenle, arşivle/arşivden çıkar, onayla kalıcı sil.
- Başlık, emoji, alan, alt kategori, haftanın tekrar günleri, hedef türü ve değeri, hatırlatma, ödüle katılım tercihi.
- Türler: tek onay (check), adet (count), dakika (duration).
- Tek dokunuş: check alışkanlığını tamamla/geri al. Adet ve dakika kartı küçük giriş sheet'i açar; hedefe ulaşınca otomatik tamamlanır. Çalışma sayacı da dakika hedefini besleyebilir.
- Örnekler: 20 dakika ders, 10 soru, 5 sayfa kitap, bir iyilik, kişinin belirlediği ibadet takibi.
- Namaz takibi isteyen kullanıcı ayrı alışkanlıklar oluşturabilir; otomatik vakit hesabı veya konum izni yoktur. Oruç kişinin seçtiği günlerde takip edilir; dini hüküm üretilmez.
- GitHub katkısı manuel öz bildirimdir; token, hesap bağlantısı, otomatik push veya dışarıya mesaj gönderme yoktur.
- Kişisel sınırlar için kullanıcı kendi başlığını yazabilir; eski partnere mesaj atmamak gibi özel ifadeler hazır bildirimlerde gösterilmez.
- Lazer randevusu, sinema ve gezi gibi tek seferlik işler seri alışkanlık değil, ödül planı veya not olarak kaydedilir.
4.2 Seri, takvim ve analiz
- Mevcut seri, en uzun seri, toplam tamamlanan planlı gün, haftalık/aylık tamamlama yüzdesi.
- GitHub benzeri katkı ızgarası: günlük tamamlanan/planlanan hedef oranı. Plan olmayan günler nötrdür; yüzde sıfırla aynı renkte değildir.
- Isı haritası hücresine dokununca tarih ve 3/4 hedef · %75 açıklaması açılır.
- Rozetler: İlk Adım (ilk tamamlanan gün), Ritim Buldum (bir alışkanlıkta 7 planlı gün seri), Yeniden Başladım (kaçırılan planlı günden sonra ilk tamamlama), İlk Bilet (ilk kazanılan ödül). İbadet türüne özel üstünlük rozeti yoktur.
4.3 Ödül sistemi: kişisel bilet
- Para, indirim kuponu, gerçek bilet satışı veya uygulamanın hediye göndermesi yoktur. Kullanıcı ödülü kendi imkanlarıyla gerçekleştirir.
- Örnek: “8 tamamlanan alışkanlık günü sonunda müze gezisi.” Her seçili alışkanlık bir planlı günde en fazla 1 adım kazandırır. Fazla dakika/adet ek ödül üretmez.
- İlk sürümde aynı anda tek aktif ödül vardır. Diğer ödüller taslak olarak kalır. Böylece bir tamamlama birden çok ödüle yazılmaz.
- Hedef 1–1000 tamamlama adımı; varsayılan 8. Başlık 2–80 karakter. Açıklama en fazla 500 karakter.
- Aktivasyonda hedef ve uygun alışkanlık listesi dondurulur. En az bir uygun, arşivlenmemiş alışkanlık zorunludur. İbadet alt türlerinde ayrıca açık katılım gerekir.
- Aktifleştirmeden önceki tamamlamalar ödüle eklenmez. Yeni alışkanlık otomatik dahil olmaz. Başlık/not değişebilir; hedef ve bağlantılar için ödül iptal edilip yeni hedef açılır.
- Aynı gün daha önce tamamlanmış bir kaydı geri alıp yeniden işaretlemek yeni ödüle katkı sağlamaz. Ödül uygunluğu o (habitId, localDate) kaydının ilk tamamlanma anına göre değerlendirilir.
- Bir tamamlamadan çıkan tek adım; RewardContribution ile aktif bilete ayrılır. Aktif bilet yoksa geriye dönük kullanılacak bakiye oluşmaz.
- Eşiğe ulaşıldığında aynı transaction içinde earned olur; kazanım zamanı yazılır. Animasyon yalnızca kalıcı başarıdan sonra oynar. Uygulama yeniden açılınca tekrar bilet üretilmez.
- Kullanıcı “Planla” ile gelecekte bir tarih/saat, yer adı ve not kaydeder. “Ödülümü kullandım” onayla used yapar. Konum önerisi yerleşik fikirdir; canlı mekan araması yoktur.
- Normal akış: draft → active → earned → planned → used; earned durumundan doğrudan used mümkündür. active → canceled; kazanılmış biletler iptal edilmez, geçmişte tutulur.
- Kullanılmamış earned/planned bilete katkı sağlayan tamamlama geri alınırsa ön uyarı gösterilir: bilet tekrar active olur, plan temizlenir. Başka aktif bilet varsa onun iptal edilmesi veya geri alma işleminden vazgeçilmesi gerekir; iki aktif bilet oluşturulmaz.
- Kullanılmış bilete ait tamamlama düzeltilirse bilet kullanılmış olarak kalır; ilgili katkı reversedAfterUse ile işaretlenir, bilette “Geçmiş kayıt düzeltildi” görünür. Bu katkı başka bilete aktarılmaz.
- Active ödül iptalinde katkılar serbest bakiyeye dönüşmez; geçmişte canceled bilete bağlı kalır. Silinmiş/geri alınmış katkı yeniden tamamlanırsa sadece kendi aktif bileti için geri etkinleşebilir; başka bilete taşınamaz.
- Ödül hedefi tamamlanınca fazla katkılar otomatik başka ödüle akmaz. Yeni ödül kullanıcı tarafından etkinleştirilir.
- Bilet tasarımı: parçalı ilerleme, yüzde, kalan adım; 6/8 • Son 2 adım!. Duyuru ve animasyon metni hiçbir zaman gerçekleşmemiş başarı iddia etmez.
4.4 Odaklanma sayacı
- Varsayılan 25 dakika; kullanıcı 5–120 dakika seçer. Başlat, duraklat, sürdür, bitir ve vazgeç çalışır.
- Aynı anda tek aktif oturum. Hedef alışkanlık seçilmeli; yalnızca planlı ders/gelişim dakika alışkanlıkları bağlanır.
- Timer.periodic yalnızca görünümü yeniler. Doğru süre başlangıç/bitiş zamanları ve birikmiş aktif saniyeden hesaplanır; ekrandaki tick sayısına güvenilmez.
- Oturum başlatma, duraklatma, sürdürme ve tamamlama kalıcı yazılır. Uygulama kapanıp açılsa da geri yüklenir. Arka planda sürekli Dart çalışacağı varsayılmaz.
- Süre bitince tamamlanan dakika bir kere kaydedilir. Önceden bitirmede tamamlanan tam dakikalar onayla kaydedilir; 1 dakikadan azsa oturum iptal edilir. Manuel dakika toplamı ile oturum toplamı ayrı saklanır; hedef aşımı ödülde yine tek adımdır.
- Gece yarısını geçen aktif aralıklar yerel gün sınırında bölünür; her günün alışkanlık planına uygun kısmı o güne eklenir. Plan dışı dakikalar oturum geçmişinde kalır ama günlük tamamlamaya sayılmaz.
- İleri/geri saat değişiminde negatif süre yazılmaz; şüpheli sıçrama kullanıcıya süre onayı olarak sunulur. Bu öz bildirim uygulaması hileye dayanıklı ölçüm iddia etmez.
4.5 Hatırlatmalar
- Her alışkanlık için seçili tekrar günlerinde bir yerel saat. Haftalık tekrarlayan bildirim kullan; sınırsız gelecek bildirim listesi üretme.
- İzin, kullanıcı hatırlatmayı açınca açıklamayla istenir. İzin reddi uygulamanın geri kalanını engellemez.
- İstenen ayar ve gerçek planlama durumu ayrı saklanır: off / scheduled / permissionDenied / failed / unsupported.
- Kaydetme başarılı, planlama başarısızsa: “Alışkanlık kaydedildi; hatırlatma kurulamadı.” Yeniden dene ve cihaz ayarlarını aç eylemi sunulur.
- Düzenleme/arşivleme/silme sonrası eski bildirimler iptal edilir; uygun yenileri planlanır. Bildirim integer ID'leri DB'de benzersiz atanır; UUID hash çakışmasına güvenilmez.
- Bildirim payload'ında yalnızca alışkanlık ID'si bulunur. Dokunma soğuk/sıcak açılışta aynı router akışına girer. Silinmiş ID anlaşılır bulunamadı ekranına gider.
- Android/iOS izinleri ve üretici güç kısıtları nedeniyle dakikası dakikasına teslim garantisi verilmez. Exact alarm izni ilk sürümde istenmez; paket destekli yaklaşık planlama kullanılır.
- Kilit ekranında varsayılan genel metin: “Kendin için küçük bir adım zamanı.” Kullanıcı isterse başlığı gösterebilir. Tema ve bildirim ayarları ayarlar sheet'inde çalışır.
5. Hedef Kitle
Öğrenciler ve kişisel rutinlerini küçük adımlarla güçlendirmek isteyen genel kullanıcılar. Maneviyat tercihleri kişiseldir; bölüm boş bırakılabilir. İlk sürüm tek cihaz, tek yerel profil ve Türkçe arayüzdür. Üyelik, sunucu, sosyal sıralama, reklam ve abonelik yoktur.
6. Öğrenci Çalışma ve Detay Alanı
6.1 Kullanılacak Teknolojiler ve Kütüphaneler
Alan	Karar	Amaç
Frontend	Flutter + Dart, Material 3	Mobil arayüz, açık/koyu/sistem teması
Durum yönetimi	flutter_riverpod	Notifier/AsyncNotifier controller, bağımlılık sağlama
Router	go_router	StatefulShellRoute, ID ile detay ve başlangıç redirect
Ana veri	Drift + SQLite, drift_flutter	İlişkiler, transaction, sorgular ve migration
Basit tercihler	shared_preferences	Tema ve onboarding gibi kritik olmayan tercihler
Hatırlatma	flutter_local_notifications, timezone, flutter_timezone	Cihaz bölgesinde yerel bildirim
Native splash	flutter_native_splash	Android/iOS başlangıç görünümü
Yardımcı	uuid, intl	Kalıcı ID, Türkçe tarih/sayı biçimi
Geliştirme	flutter_lints, flutter_test, integration_test, drift_dev, build_runner	Analiz, test, DB üretimi


Kod üretimi yalnızca Drift için zorunlu; başlangıçta Freezed ve Riverpod generator eklenmez. Model copyWith ve eşitliği elle, tutarlı yazılır. Isı haritası Flutter Grid/Wrap bileşenleriyle, grafikler basit Flutter çizimleriyle yapılır; ağır grafik veya animasyon paketi gerekmez.

Bu bir teknoloji kararıdır, güncel sürüm numarası iddiası değildir. Uygulamaya başlanırken resmi paket belgelerinden Flutter/Dart/Android/iOS uyumu kontrol edilir; uyumlu sürümler pubspec.yaml'a yazılır ve uygulamanın pubspec.lock dosyası git'e eklenir. Çözümlenmemiş latest bağımlılığı bırakılmaz.

Drift seçilme nedeni: tamamlama, ödül katkısı ve bilet durumunun atomik güncellenmesi gerekir. SharedPreferences tüm veri tabanı yerine kullanılmaz. Hive/Isar aynı anda eklenmez. FlutterSecureStorage yalnızca gerçek bir gizli anahtar/token ihtiyacı doğarsa değerlendirilir; ilk sürümde üyelik/token olmadığı için kurulmaz. Yerel SQLite kendiliğinden şifreli değildir; “en yüksek güvenlik” iddiası kullanılmaz.

Android birincil doğrulama hedefi, iOS ikinci hedeftir. Android cihaz veya emülatörde bildirim/native splash test edilir; Chrome'da açılması bunları doğrulamaz. iOS derlemesi macOS/Xcode gerektirir. Web desteği ilk teslim kapsamı değildir.
6.2 Sayfa Hiyerarşisi ve Akış Planı
/bootstrap                         başlangıç yükleme / başlangıç hatası
/onboarding                        ilk kullanım adımları
StatefulShellRoute.indexedStack
  /maneviyat                       Maneviyat ve İyilik
  /ders                            Ders ve Gelişim
  /kendime-zaman                    Ödüller
/habits/:id                        kök navigator üzerinde alışkanlık detayı
/progress                          kök navigator üzerinde analiz
- MaterialApp.router uygulamanın tek router girişidir. Router build içinde yeniden oluşturulmaz.
- Alt menü navigationShell.goBranch(index, ...) kullanır; sekmeler kendi kaydırma ve navigator durumlarını korur.
- Kart context.push('/habits/$id'); geri dönüş canPop varsa pop, doğrudan bağlantıyla gelindiyse varsayılan bölüme go.
- state.pathParameters['id'] ile kalıcı UUID alınır; ID bir session token değildir ve gizli veri taşımaz. Kaydı repository bulur. Liste index'i ID olarak kullanılmaz.
- Opsiyonel filtre örneği /progress?category=study&month=2026-10; query whitelist ve tarih biçimi kontrol edilir. Geçersiz filtre güvenli varsayılana döner.
- Ödül detayına doğrudan erişim /kendime-zaman?rewardId=<uuid> ile desteklenir. Sayfa hazır olduğunda sheet bir kere açılır; kapanınca query kaldırılır. build içinde showModalBottomSheet çağrılmaz.
- Formlar showModalBottomSheet ile açılır; başlangıç verisi ID üzerinden controller'dan gelir. Router extra tek veri kaynağı yapılmaz.
- Bildirimden hedef ID bekleyen rota olarak tutulur. Onboarding bittikten ve DB hazır olduktan sonra hedefe gidilir.
Başlangıç durum makinesi: loading → needsOnboarding / ready / failure.
1. Binding, ProviderScope ve başlangıç görünümü hazırlanır. Native splash sadece ilk Flutter karesine kadar kalır.
2. Flutter bootstrap ekranında DB açılır/migrate edilir, tercihler okunur, Türkçe tarih verileri ve bildirim servis durumu hazırlanır.
3. Kritik DB hatası failure üretir: sakin kısa animasyon, “Verilerin açılamadı”, “Tekrar dene”. Hata saklanmaz, sahte başarılı ekran gösterilmez. Otomatik DB silme yoktur.
4. Bildirim izin reddi veya bildirim servisi hatası kritik olmayan uyarıdır; DB sağlamsa uygulama açılır.
5. Onboarding tamamlanmamışsa /onboarding; tamamlanmışsa bekleyen geçerli hedef veya /ders.
6. Onboarding bitişi tercih yazımı başarılı olunca state değiştirir. Redirect, state değişimine bağlı refresh dinler; widget içinden rastgele çoklu go çağrısı yapılmaz.
7. Her state değişiminde aynı rotaya yönlendirme yapılmaz; döngü engellenir. Bilinmeyen rota not-found görünümü ve “Ana sayfaya dön” sunar.
Onboarding: (1) üç bölümü tanıt, (2) isteğe bağlı başlangıç şablonlarını seç, (3) kişisel bilet sistemini açıkla. Atla ve Başla ikisi de tercihi kalıcı kaydeder. Onboarding sırasındaki seçimler onayla, transaction içinde bir kere oluşturulur. Kullanıcı sıfır alışkanlıkla da başlayabilir; örnek geçmiş tamamlama üretilmez.
6.3 Veri Modeli ve Bileşen Tasarımı
Tüm domain nesneleri immutable; alanlar final, koleksiyonlar değiştirilemez kopyadır. DB kayıt modelleri domain nesnelerine mapper ile çevrilir. Zaman damgaları UTC, günlük anahtarlar yerel yyyy-MM-dd, saat dilimi IANA adı olarak saklanır. Telefon saat dilimi değişince geçmiş günlük anahtarlar yeniden yazılmaz; aktif planlar ileriye dönük yeniden kurulur.
Model / tablo	Temel alanlar	Kısıt / ilişki
Habit	id, title, emoji, category(spiritual/study), subcategory, createdAtUtc, archivedAtUtc?	UUID PK; başlık 2–60 karakter
HabitPlanVersion	id, habitId, effectiveFromDate, weekdays, targetType, targetValue, unit, rewardEligible	habit FK; aynı günde tek sürüm; geçmiş plan korunur
DailyCheckIn	id, habitId, localDate, planVersionId, manualValue, sessionSeconds, isCompleted, firstCompletedAtUtc?, lastCompletedAtUtc?, note?	UNIQUE(habitId,localDate); hedef plan snapshot'ından okunur
FocusSession	id, habitId, startedAtUtc, activeSegmentStartedAtUtc?, accumulatedSeconds, plannedSeconds, status, endedAtUtc?	running/paused/completed/canceled; tek açık oturum
FocusAllocation	sessionId, localDate, activeSeconds	UNIQUE(sessionId,localDate); tekrar kayıtta dakika çoğalmaz
Reward	id, title, emoji, description, targetSteps, status, activatedAtUtc?, earnedAtUtc?, usedAtUtc?, planAtUtc?, planTimezone?, placeName?, planNote?	tek active; hedef aktivasyondan sonra sabit
RewardHabitLink	rewardId, habitId	bileşik PK; aktivasyonda dondurulur
RewardContribution	id, rewardId, checkInId, allocatedAtUtc, isReversed, reversedAfterUse	UNIQUE(checkInId); bir kayıt bir bilete ayrılır
Badge	code, earnedAtUtc, evidenceId?	code PK; aynı rozet bir kere; elde edilme anı hatıra olarak kalır
DailyReflection	localDate, text, updatedAtUtc	tarih PK; en fazla 500 karakter; isteğe bağlı
Reminder	id(int), habitId, weekday, hour, minute, status, lastErrorCode?	UNIQUE(habitId,weekday); DB integer bildirim ID'si
LocalPreferences	schemaVersion, onboardingDone, themeMode, defaultSection, hideNotificationTitle	SharedPreferences; eksik tercihler güvenli varsayım


Reward ilerlemesi ayrı sayacı elle artırarak tutulmaz; ters çevrilmemiş katkılardan hesaplanır. earnedAt ve durum transaction içinde bu hesapla uyumlu yazılır. Veri tabanı UNIQUE, FK ve CHECK kısıtları controller doğrulamasına ek korumadır.

Plan ve tarih kuralları
- Alışkanlık oluşturulduğu yerel günden itibaren seçili haftanın günlerinde planlıdır.
- Hedef, tekrar günleri ve ödül uygunluğu değişikliği ertesi yerel günden geçerlidir; geçmiş istatistikleri değiştirmez. Başlık/emoji hemen değişebilir.
- Arşivleme yeni günleri durdurur; bugünkü plan korunur, ertesi gün ve sonrası planlanmaz. Arşivden çıkarma ertesi gün başlar. Geçmiş sürümler saklanır.
- İlk sürüm manuel tamamlama değişikliği yalnızca bugün yapılır; geçmiş günler okunur. Oturum gece yarısını geçmişse tarih bölme özel kuralı geçerlidir.
- Bir habit/day kaydı silinip yeni ID ile çoğaltılmaz; geri alma aynı kaydı günceller ve firstCompletedAt korunur.
- Kalıcı alışkanlık silmede ilgili check-in, plan ve oturumlar onayla silinir; ödül kayıtlarında denetim için başlık snapshot'ı ve tarih tutulur, contribution checkInId nullable tombstone'a dönüşür. Kullanılmış ödül silinmez. Aktif/kazanılmış bilet etkisi yukarıdaki geri alma kurallarıyla aynı transaction içinde çözülür; çözülemiyorsa silme engellenip arşivleme önerilir.
Seri hesabı
- Seri takvimde art arda tüm günler değil, planlanan günler üzerinden hesaplanır. Pazartesi/çarşamba planında salı boşluğu seriyi bozmaz.
- Bugün planlı ve henüz tamamlanmamışsa gün bitene kadar önceki seri korunur. Bugün tamamlanırsa seriye eklenir.
- Geçmişte kaçırılan planlı gün mevcut seriyi keser. En uzun seri geçmişin tamamından bulunur; bugünkü geri alma yeniden hesaplatır.
- Gün sınırı yerel takvimle belirlenir; Duration(hours:24) ile yeni gün üretilmez. UTC ile fark alıp gün sayma kullanılmaz.
- Uygulama açıkken yerel gece yarısı ve resume olayında bugünün planları/seri/analiz yenilenir; tamamlamalar kendiliğinden eklenmez.
Oran hesabı
oran = tamamlanan planlı alışkanlık-gün sayısı / vadesi gelen planlı alışkanlık-gün sayısı × 100.
- Seçili dönemde başlangıçtan bugüne kadar olan günler, bugün dahil sayılır; gelecek günler paydada yoktur.
- Payda 0 ise “Henüz planlı hedef yok” ve — gösterilir; %0 başarı gibi sunulmaz.
- Günlük hücre oranı aynı kurala uyar; eksik sayısal hedef tamamlanmış sayılmaz.
- Çalışma dakika toplamı tamamlanma yüzdesinden ayrıdır; hedef üzerindeki dakika gerçek süre istatistiğinde kalır.
Örnek kabul hesabı: Pzt/Çrş/Cuma planlı tek alışkanlıkta pzt ve çrş tamam, cuma bugün ve henüz boşsa oran 2/3=%67, mevcut seri 2'dir. Cuma bitip cumartesiye geçildiğinde mevcut seri 0 olur. Cuma tamamlanırsa seri 3 olur.

Bileşenler: AppScaffold, SectionHeader, HabitCard, HabitFormSheet, NumericProgressSheet, CompletionButton, DailyProgressCard, FocusTimerPanel, RewardTicketCard, RewardFormSheet, RewardDetailSheet, ContributionHeatmap, StreakSummary, BadgeTile, SettingsSheet, EmptyState, LoadingState, ErrorState ve ActionFeedback.

Her bileşenin veri girdisi ve callback'i vardır. HabitCard DB açmaz; CompletionButton ödül hesaplamaz. Genel widgets klasörü feature iş kuralları içermez.
6.4 Proje Takvimi ve Teslim Aşamaları
Aşama	Önerilen süre	Çıktı / bitiş ölçütü
1 — Tasarım ve wireframe	1. hafta	Beş ekran, üç sekme, form alanları, tema, modeller, rota ve buton listesi net
2 — Temel fonksiyonlar ve arayüz	2–3. hafta	Kalıcı CRUD, planlar, tamamlama/geri alma, seri ve analiz; ardından ödül ve sayaç uçtan uca çalışır
3 — Test ve iyileştirme	4. hafta	Bildirimler, onboarding/native splash, hata senaryoları, erişilebilirlik ve gerçek cihaz kontrolü
4 — Final teslim	5. hafta	Kaynak kod, README, lockfile, test sonuçları ve Android APK; iOS doğrulama durumu açıkça yazılı


Süreler öneridir; kesin ders takvimi verilince tarihlendirilir. Önce kalıcı çalışan dikey dilim, sonra görsel iyileştirme yapılır. Detaylı görev sırası AGENTS.md'dedir.
6.5 Notlar ve Karşılaşılabilecek Zorluklar
Konu	Çözüm yaklaşımı
Aynı butona hızlı basma	ID bazlı pending durumu + transaction + UNIQUE kısıtı
Bildirim reddi	Kaydı koru, gerçek durum/tekrar dene göster
Uygulama kapalıyken sayaç	UTC aralıklarından geri yükle, bir kere allocate et
Planı değiştirince geçmişin bozulması	Ertesi günden geçerli plan sürümleri
Ödülü iki kez kazanma	UNIQUE katkı, durum geçişi ve atomik commit
DB migration hatası	Tekrar deneme ekranı; sessiz veri silme yok
Gece yarısı/saat dilimi	Enjekte Clock, yerel tarih anahtarı, resume kontrolü
Çok uzun listeler	ListView.builder; iç içe sınırsız scroll'dan kaçın
Mobilde animasyon kasması	Küçük subtree animasyonu, reduce motion, ölçülü süre


Bu tablo tahmini risk kaydıdır; gerçekleşmiş sorun gibi sunulmaz. Geliştirme sırasında gerçek bulgular ve çözümler tarihli eklenir.
7. Clean Architecture ve Klasör Yapısı
Bağımlılık: presentation → domain ← data. Domain saf Dart'tır; Flutter, Riverpod, Drift veya BuildContext import etmez. app/di repository implementasyonlarını domain arayüzlerine bağlar. Feature'lar birbirinin data katmanını import etmez; çapraz özellik transaction'ları journey uygulama akışı üzerinden yönetilir.
lib/
  main.dart
  app/
    app.dart
    bootstrap/app_bootstrap_controller.dart
    router/app_router.dart
    router/route_paths.dart
    di/app_providers.dart
    lifecycle/app_lifecycle_observer.dart
    theme/app_theme.dart
    theme/app_colors.dart
  core/
    errors/app_failure.dart
    result/result.dart
    time/clock.dart
    time/local_date.dart
    validation/validators.dart
    widgets/{empty_state,error_state,loading_state}.dart
  infrastructure/
    database/{app_database,tables,migrations}.dart
    notifications/local_notification_service.dart
    preferences/preferences_store.dart
  features/
    habits/
      domain/entities/{habit,habit_plan,daily_check_in}.dart
      domain/repositories/habit_repository.dart
      domain/usecases/{create_habit,update_habit,watch_today_habits}.dart
      data/models/habit_record.dart
      data/mappers/habit_mapper.dart
      data/datasources/habit_local_data_source.dart
      data/repositories/habit_repository_impl.dart
      presentation/controllers/{habit_list_controller,habit_form_controller}.dart
      presentation/pages/{spiritual_page,study_page,habit_detail_page}.dart
      presentation/widgets/{habit_card,habit_form_sheet}.dart
    journey/
      domain/repositories/journey_repository.dart
      domain/usecases/{record_progress,revert_progress,finalize_focus_session}.dart
      data/repositories/journey_repository_impl.dart
      presentation/controllers/completion_controller.dart
    focus/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/controllers/focus_controller.dart
      presentation/widgets/focus_timer_panel.dart
    rewards/
      domain/{entities,repositories,usecases}/
      data/{models,datasources,repositories}/
      presentation/controllers/reward_controller.dart
      presentation/pages/rewards_page.dart
      presentation/widgets/{reward_ticket_card,reward_form_sheet,reward_detail_sheet}.dart
    progress/
      domain/{entities,repositories,usecases}/
      domain/services/{streak_calculator,completion_rate_calculator}.dart
      data/repositories/progress_repository_impl.dart
      presentation/controllers/progress_controller.dart
      presentation/pages/progress_page.dart
      presentation/widgets/{contribution_heatmap,badge_tile}.dart
    onboarding/presentation/onboarding_page.dart
    settings/presentation/{settings_controller,settings_sheet}.dart
test/{domain,data,presentation}/
integration_test/
assets/{branding,illustrations}/
PROJECT.md
AGENTS.md
SKILLS.md
README.md
Süslü parantezli yollar kısaltılmış plandır; gerçek klasör/dosya isimleri tek tek açılır. Boş klasör yığını oluşturulmaz. journey repository implementasyonu aynı Drift bağlantısında check-in, focus allocation, reward ve badge güncellemelerini atomik yürütür. Tek usecase'in ardışık bağımsız repository yazımlarıyla transaction taklidi yapılmaz.
Controller ve model sorumlulukları
- Controller UI olayını alır, usecase çağırır, loading/success/failure state üretir. SQL, tarih/seri algoritması veya BuildContext içermez.
- Domain entity iş verisini, usecase iş eylemini, repository arayüzü erişim sözleşmesini tanımlar.
- Data record DB serileştirmesini, mapper dönüşümü, local data source sorguyu, implementasyon hata dönüşümünü üstlenir.
- Widget state'i izler; navigation, dialog ve snackbar'ı UI katmanında yapar.
- Ortak algoritma farklı sayfalara kopyalanmaz; ilgili domain servisinden import edilir.
8. Görsel Tasarım, Animasyon ve Erişilebilirlik
- Pastel lila ana renk (#7965A8), krem arka plan (#FFF9F2), şeftali vurgu (#F2B6A0), adaçayı destek (#A3BFA8). Bunlar başlangıç paletidir; yazı kontrastı açık/koyu temada ayrıca doğrulanır.
- Material 3 ColorScheme üzerinden primary/onPrimary, surface/onSurface, container ve outlineVariant kullanılır. Renkler sayfalara hardcode dağıtılmaz.
- Emoji yanında her zaman metin bulunur. Sadece renk veya emojiyle başarı/hata anlatılmaz.
- Kart tamamlanması: AnimatedContainer + kısa AnimatedScale, 180–250 ms easeInOut. Bilet kazanımı: 500–700 ms ölçülü kutlama; tekrarlı zıplama yok.
- AnimatedOpacity/Align küçük değişimlerde kullanılabilir. Reduce motion açıksa ölçek/sekme animasyonları kaldırılır, kısa opaklık veya statik başarı kullanılır.
- Native splash statik marka görünümüdür; asıl animasyon Flutter bootstrap/onboarding ekranındadır. Lisanslı veya uygulama içinde çizilmiş görseller kullanılır.
- En az 48 logical pixel dokunma alanı; büyük yazıda taşmayan kartlar; ekran okuyucu etiketi; grafikler için metinsel özet; koyu tema; safe area ve klavye testleri.
- Boş liste: ilgili ekleme eylemi. Hata: kısa neden + tekrar dene. Yükleme: işlem göstergesi. Animasyon hata bilgisini örtmez.
9. Buton ve Etkileşim Sözleşmesi
Kontrol	Gerçek eylem	Başarı	Hata / sınır
Üç alt sekme	goBranch	İlgili liste korunarak açılır	Yanlış sekme index'i kullanılmaz
Alışkanlık ekle	Form → create	DB kaydı, liste güncelleme	Inline doğrulama / kaydetme hatası
Tamamla	recordProgress	Kart, seri, analiz ve ödül birlikte güncellenir	Pending kilidi / retry
Geri al	revertProgress	Aynı kaydı düzeltir	Bilet etkisi önce açıklanır
Kartın gövdesi	ID ile push	Doğru detay	Silinmiş kayıt görünümü
Düzenle	Update usecase	Başlık hemen; plan yarından	Geçersiz alanlar korunur
Arşivle / geri getir	Onay + plan bitiş/başlangıç	Geçmiş korunur	DB hatası state'i bozmaz
Kalıcı sil	Etkileri açıklayan onay	İlişkiler tutarlı silinir	Ödül çatışması çözülmeden silmez
Sayaç kontrolleri	Kalıcı oturum işlemi	Süre tek kere kaydedilir	Çifte aktif oturum engeli
Ödül ekle / etkinleştir	Form / activate	Tek aktif bilet	Uygun alışkanlık yoksa açıklama
Ödül iptal	Onay	Canceled geçmişi	Katkılar başka bilete taşınmaz
Planla / plan düzenle	Tarih, yer, not kaydet	Planned bileti	Geçmiş tarih reddedilir
Planı kaldır	Onay	Earned durumuna döner	Kayıt hatası
Ödülümü kullandım	Onay + usecase	Used geçmişine geçer	İkinci kullanım engellenir
Analiz / tarih / filtre	Router / controller	Doğru dönemi gösterir	Boş dönemde —
Hatırlatma	İzin + servis	Gerçek planlama durumu	Red/unsupported/failed görünür
Tema / başlangıç bölümü	Tercih kaydı	Anında uygulanır	Yazma hatası açıklanır
Onboarding atla/başla	Tercih + router refresh	Doğru ilk hedef	Tercih kaydı başarısızsa tekrar dene
Tekrar dene	Başarısız işlemi yeniden çağır	Gerçek veri yüklenir	Sonsuz otomatik retry yok


Hiçbir görünür buton boş callback, sahte snackbar, sabit demo başarı, “yakında” veya çalışmayan bağlantı içermez. İşlem koşulu yoksa neden metinle belirtilir. Geliştirilmemiş özellik final arayüzde sunulmaz. Form kapatma kaydedilmemiş değişiklikte onay ister. Android geri hareketi de aynı davranışı kullanır.
10. Test ve Teslim Kabul Kriterleri
Kritik otomatik testler
1. Planlı/plan dışı gün, bugün bitmeden seri, kaçırılan gün, en uzun seri, ay/yıl geçişi.
2. Oranda gelecek günlerin dışlanması; sıfır payda; plan değişikliğinde geçmişin korunması.
3. Hızlı çift tamamlama tek check-in/tek katkı; tamamla–geri al–tamamla aynı kayıtta.
4. Tek aktif ödül, eşik, tekrar açılışta tek bilet, iptal katkılarının tekrar kullanılmaması.
5. Earned/planned geri alma, başka aktif ödül çatışması, used geçmiş düzeltme, silme tombstone tutarlılığı.
6. Sayacın arka plan/kapanma/duraklatma/yeniden açılma ve gece yarısı bölünmesi; tekrar finalize idempotency.
7. DB transaction ortasında hata: check-in yazılı ama ödül eksik kalmamalı. Migration veri kaybetmemeli.
8. Router onboarding redirect, pending notification hedefi, geçersiz UUID, silinmiş ID, deep link geri dönüşü.
9. Form doğrulaması, pending buton durumu, empty/loading/error ve kaydetme hatasında formun korunması.
Cihaz ve manuel doğrulama
- Uçak modunda CRUD/ödül/analiz; kapatıp açınca verinin korunması.
- Android bildirim izni kabul/red, yeniden planlama/iptal, bildirime soğuk ve sıcak dokunma.
- Native splash ve bootstrap hata/retry; karanlık/açık tema; büyük font; dar ekran; klavye; reduce motion.
- Uygulama açıkken gün değişimi ve zaman dilimi değişimi. iOS kontrol edilmediyse teslim raporunda açıkça belirt.
Bitti tanımı
- Beş ekran ve üç bölüm gerçek kalıcı verilerle çalışır; her görünür eylem test edilmiştir.
- dart format, flutter analyze, flutter test başarılıdır. En az bir Android uçtan uca akış çalıştırılmıştır.
- Release APK oluşturulmuş ve cihazda açılmıştır. Yapılamayan kontroller yapılmış gibi raporlanmaz.
- README: kurulum, Flutter/Dart sürümü, bağımlılıklar, mimari, çalıştırma, testler, desteklenen platform ve bilinen sınırlar içerir.
- Kullanıcıya ait gerçek manevi/personal kayıtlar örnek veri veya log olarak teslim edilmez.
11. Resmi Teknik Kaynaklar
Uygulama aşamasında seçilen sürümün belgeleri esas alınır. Kaynak kontrol tarihi: 22 Ekim 2026.
- Flutter state ve yaşam döngüsü: https://api.flutter.dev/flutter/widgets/State-class.html
- setState: https://api.flutter.dev/flutter/widgets/State/setState.html
- Riverpod: https://riverpod.dev/docs/introduction/getting_started
- Riverpod API: https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/AsyncNotifierProvider-class.html
- GoRouter: https://pub.dev/packages/go_router
- Stateful shell: https://pub.dev/documentation/go_router/latest/topics/Configuration-topic.html
- Drift: https://drift.simonbinder.eu/ ve https://drift.simonbinder.eu/dart_api/transactions/
- Migration: https://drift.simonbinder.eu/migrations/
- Yerel bildirimler: https://pub.dev/packages/flutter_local_notifications
- Native splash: https://pub.dev/packages/flutter_native_splash
- Dart dil rehberi: https://dart.dev/language