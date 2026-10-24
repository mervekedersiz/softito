Const
1) ne işe yarar: İçine girilen değerleri derleme zamanında tek bir kere yazılarak değişmez olarak üretir.
2) Neden Kullanılır: Bir widget const olarak tanımlanırsa setState olduğunda flutter bu widget'ı yeniden üretmez CPU ve pil tasarrufu sağlar.

final
1) ne işe yarar : çalışma zamanında değeri bir kez atanan ve sonrasında referansı asla değiştirilmeyen değişkenler
const ve final farkı: const derlenirken bilinmek zorunda(const pi=3.14) final ise çalışma anında belirlene bilir(final saat = DateTime.now())---Model sınıflarında alanlar her zaman final olmalıdır.---

late
1) ne işe yarar: değişen tanımlandığı anda değil ,ilk kullanıldığında veya inisState anında başlayılacağı zaman kullanılır.

required
ne işe yarar : isimlendirlmiş parametrelerde o parametrenin(değişkenin ) zorunlu olduğunu belirtir.

@override
1) ne işe yarar: alt sınıfların üst sınıflardan devraldığı metodu ezdiğini belirtir 
2)eğer üst metodun ismini yanlış yazarsak alt sınıfın methodu ezilmez, override olmamış olur. Bu durumda üst metodun içindeki kodlar çalışmaz. Bu yüzden override kullanırken üst metodun isminin doğru yazıldığından emin olunmalıdır. Hata durumlarını önlemek için @override kullanılmalıdır.

null-aware operatörleri( ?. , ??, ??= ,)
?. --- place?.title->>'eğer place null ise hata vermez direk null olarak döner.
?? -- if null: final id =state.userId ?? 10;->
sol taraf null ise sağdakş hardcode değer otomatik olarak atnıtr.
!(null/force): final id =state.userId!;->BU KOD DERLEYİCİYE BANA GÜVEN BU DEĞER O ANDA KESİNLİKLE NULL DEĞİL DER. EĞER NULL GELİR İSE UYGULAMA ANINDA ÇÖKER.(DİKKATLİ KULLAN!)

Spread operatörü(...)
1) ne işe yarar : bir listenin elemanlarını tek tek çıkartıp bulunduğu üst listenin içine ekler.
Column veListView içinde dinamik kart dizini kullanmak için en temiz yöntemdir.
...listeAdi.map((p)=> _buildCard(p))


1) ne işe yarar : bir listenin elemanlarını tek tek çıkartıp bulunduğu üst listenin içine ekler.

initState()
Ne zaman çalışır : Widget ağaca fiziksel olarak ilk başladığında yalnızca 1 kere çalışır
Ne yapar : ScrollController başlatmaları ve ilk api istekleri burda kurulur.
Kural: içinde doğrudan BuildContext ile Navigator çağrılmaz çünkü widget ağaca tam oturmamıştır.

didChangeDependencies()
Ne zaman çalışır: initState()'ten hemen sonra ve widget dinlediği bir (örnek: Theme.of (context) ) değiştiğinde otomatik tektikler.
Ne yapar: BuildContext güvenli bir şekilde erişerek tema ve ya ekran boyutu bağımlılıkları ile ilgili ilk yüklemeler burada yapılır.


build(BuildContext context)
Ne zaman çalışır: Sayfa ilk açıldığında ,setState() çağrıldığında veya üst widget yeni bir inşa ağaç boyama geldiğinde saniyesinde defalarca çalışır
Kural:build() metodu tamamen saf olmalıdır.Asla içinde setState() api isteyi yada controller başlatma yapılmamalıdır.Sadece UI döndürülmelidir.


dispose()
Ne zaman çalışır: widget hafızadan atılmadan hemen önce son bir kez çalışır[cite: 6]
Ne yapılır _controller.dispose() stream dinleyicilerin iptalleri burada yapılır.super.dispose()
un mutlaka son satırda çalıştırılması gerekir.[cite: 6]

setState((){})
1) arka planda ne yapar.State'in bağlı olduğu StatefulElement nesnesine "ben değiştim,build et"
sinyali yollar[cite: 6]
2) nerede kullanılır.Sayfa genelini çizdirmez.Sadece onu dinleyen küçük
ValueListenableBuilder'a sinyal gönderilir.[cite: 6]

ValueNotifier<T>
1) arka planda ne iş yapar.ChangeNotifier sınıfından türer.Belleğinde tek bir nesne referansı tutar(T _value)
2) Tetikleme Değer atandığında (set value(T value)),eğer yeni değer eski değere eşit değilse (_value!=newValue), kayıtlı olan fonksiyonu çağrılır.(addListener(() {}))
InheritedWidget
1) ne yapar: Widget ağacında alttaki childların,aradaki onlarca widgeti baypas ederek, üst widgetin verisine(state'ine) doğrudan erişmesini sağlayan soyut bir widgettir.

Material 3 Tasarınm Dili Renk algoritması ve temalar

primary:Ana marka rengi
onPrimary:Ana rengin üstüne yazılacak yazı rengi(okunabilirlik açısından)
primaryContainer:Anarengin yumuşak pastel arkaplan tonu
onPrimaryContainer:Ana rengin yumuşak pastel arkaplan tonunun üstüne yazılacak yazı (okunabilirlik açısından)
surface:Sayfa arka plan yuvali
onSurface:Sayfa üstündeki ana metin rengi
outlineVariant:İnce sınır ve ayrım çizgilerinin rengi

themeMode.system : cihazın sistem temasına göre tema seçer(iOS'de iOS,Android'de Android rengini otomatik algılar).

color:Colors.black.withOpacity(186)kesinlikl 1 ila 255 arasında girilmelidir **bu kullanım güncelde istenmiyor

color:Colors.black.withValues(alpha: 186/255)// double sayı olarak girilmelidir**Güncel ve doğru yöntemdir**

Arayüz Düzen ve Liste Bileşenleri

Expanded ve Flexible
Expanded:Kalan bol alanın TAMAMINI kaplamaya zorlar.
Flexible:Kalan bol alanı paylaştırır.(flex:1,flex:2)
Flex: yanyana iki expended varsa birine flex2 diğerine flex1  verir  bu sayede ekran boyutuba göre otomstik olarak ayarlarç

Stack ve Positioned.
Ne yapar : Widget'ları z ekseninde üstüste bindirir.
Positioned:Yalnızca bir Stack içinde çalışır.
top:10 , right:10 vererek bir resmin sağ üst köşesine bildirim rozeti eklemenizi sağlar.

ListView.builder.
Klasik ListView(children:[...],) içindeki örnek vermek gerekirse 10.000 elemanın tamamını daha sayfa açılmadan belleğe yükler ve doğal olarak telefon donar.
ListView.builder ise Geri Dönüşümlü Görünüm alanı Mantığını kullanarak ekranda sadece o an eğer 5 kart görünecek ise sadece 5 kartı ram belleğe yükler.Kullanıcı aşağıya kaydıkça yukarıda kalanlar bellekten düşürülüp altta kalanlar belleğe taze olarak yeni olarak üretilir.

shrinkWrap: true
Bir ListView baş bir dikey kaydırıcının (singleChildScrollView) içine konursa Vertical viewport hatası verir
shrinkWrap true verilerek bu çözülebilir ancak:ListView'un sonsuza kayma ( sonsuz scroll) özelliği kaybolur.
**Sadece 3 5 elemanınız varsa bunu kullanmalısınız**
Inkwell ve GestureDetector
GestureDetector:Tıklama çift tıklama sürükleme olaylarını yakalar ama GÖRSEL HİÇ BİR TEPKİ VERMEZ.
Inkwell: tıklandığı an parmağın altından dışa doğru yayılan bir su dalgası efekti verir.

Önemli Kural: Inkwell'in arkasında mutlaka bir material widget olmak zorundadır.Aksi taktirde su dalgası arkadakş tuvali göremediği için hiçbir şekilde görünmez.

Form mimarisi

GlobalKey

Widget içindeki Form düğümüne doğrudan dışarıdan erişilemiyor. Bu yüzden Widgetin en üstüne koyduğumuz globalKey değişkeni sayesinde formun Validate (geçerli) durumunu ve içindeki değerleri (Değişkenleri) dışarıdan okuyoruz.

_formKey.currentState?.validate() çağrıldığında o formun altındaki tüm TextFromFiled validator bloklarını sırayla çalıştırır.

validator :(String ? value)

fonksiyonda bir hata bulursa geriye String olarak hata metni dönerir. Bu metin otomatik olarak kırmızı renkte ve inputun altında belirir.
Eğer veri geçerliyse null döner. Flutter için bu alanda hata yok demektir. Null gelmesi.


Animasyon Motoru   
AnimatedContainer: genişlik yükseklik padding margin border renk ve gölge oynatır   AnimatedOpacity: görünürlüğü 0.0 ila 1.0 arasında yumuşakça soldurur   AnimatedScale: Widget merkezinden dışarıya doğru büyütüp küçültür   AnimatedAlign: widget kutunun içinde sağdan sola yukardan aşağıya karşı konumunu değiştirir.  
 Curves   İvmelenme Karakterleri   Curves.linear: Sabit hız (robotik hareketler)   Curves.easeInOut: Yavaş Başlar ortada hızlanır yavaşça durur   Curves.bounceOut: Hedefe çarptığında top gibi 2 3 kez yaylanarak seker   Curves.elasticOut: Lastik gibi ileri geri titreyerek yerine oturur.

 shal router 
 Gorouter  context.go('/profil'): Route Yönlendirmesidir. Rota tablosunda hiyerarşiyi takip eder sayfayı temizleyebilir.   context.push('/profil/5') Stack yönlendirmedir. Kullanıcı nereden gelirse gelsin mevcut sayfanın tepesine yeni bir katman ekler ve dönüş sayfası için bir geri ok butonu ekler   context.pop() sayfanın en üstteki yığınını kapatır.   state.pathParameters["id"]: Gorouter içinde tanımladığımız /:id yapılarına erişmek için kullanılır   /profil?user=berat   
 state.uri.queryParameters["user"]: Opsiyonelk filtreleme yada arama zamanlarında kullanılır.   

 Cihaz içi yerel depolomo mimarileri
 Shared prefences :
 FlutterSecurestorage:android ve ios cihazlarında şifre token gibi hassas verileri saklamak için kullanılan 
 düşük güvenilirlik
 okuma yazma hızları :orta/yazma hızı yavas 

FlutterSecureStorage:
Şifre token gibi hassas verileri saklamak için kullanılan kütüphanedir.
en yüksek güvende 
okuma yazma hızları :orta/orta

hıve/ısar:
yüksek performanslı nesne depoloma 
orta (isteğe bsğlı şifreleme açılabilir)
okuma yazma hızları:hızlı 