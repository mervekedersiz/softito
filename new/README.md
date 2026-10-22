# FreshTrack

Flutter ile geliştirilen gıda envanteri ve yerel bağış taslakları uygulaması.

## Çalıştırma

```powershell
cd "C:\Users\merve\new"
flutter pub get
flutter run -d chrome
```

Android emülatörü zaten açıksa cihaz kimliğini `flutter devices` ile kontrol edip
`flutter run -d emulator-5554` komutunu kullanın; kimlik farklıysa komutta değiştirin.

## Harita ve konum

Bağış ekranındaki **Konum & Teslimat** kartı iki ayrı kayıt tutar:

- **Konuma Git:** Kullanıcının seçtiği teslimat noktası.
- **Kurye Teslimi:** Paket için kullanıcının belirlediği alım adresi. Bu işlem bir kurye siparişi oluşturmaz veya adresi bir kurye şirketine göndermez.

Haritaya dokunarak pin seçilebilir; başka bir noktaya dokunulduğunda pin taşınır.
**Konumumu Al (GPS)** yalnızca düğmeye basıldığında cihazın/tarayıcının konumunu ister.
Konum izni reddedilirse veya konum hizmetleri kapalıysa elle pin seçimi ve
**Koordinat gir** alanları kullanılabilir. Konum kendiliğinden kaydedilmez;
**Konumu Kaydet / Alım Adresini Kaydet** düğmesiyle onaylanır.

Kayıtlı pin, ad ve adres açıklaması mevcut sürümlü JSON kaydının
`donationLocations` alanında bu cihazda saklanır. Eski kayıtlarda bu alanın bulunmaması
desteklenir. Kaydetme başarısızsa başarı mesajı gösterilmez ve önceki pin korunur.
Teslimat ve alım adresleri ayrı ayrı düzenlenebilir ve silinebilir.
Bu küçük ders projesi SharedPreferences kullanır; kritik veriler için veritabanı garantileri sağlamaz.

**Google Haritalar’da Yol Tarifi**, seçilen koordinatı Google Haritalar'a iletir.
Harita görüntüleri OpenStreetMap sunucusundan internet üzerinden alınır; kişisel
adres açıklaması harita sunucusuna gönderilmez. Bir kurum veya bağış noktası
resmen doğrulanmış gibi sunulmaz; koordinatı kullanıcı belirler.

Tarayıcı konumu için uygulamayı `localhost` veya HTTPS üzerinde açın ve site konum
iznini verin. Tarayıcının bildirdiği konum yaklaşık olabilir. Android emülatöründe
GPS sonucu emülatörün konum ayarına bağlıdır; gerçek cihazın konumu değildir.

## Kontroller

```powershell
flutter analyze
flutter test
flutter build web
```

Harita: [flutter_map](https://pub.dev/packages/flutter_map/versions/8.3.2),
konum: [geolocator](https://pub.dev/packages/geolocator/versions/14.0.2),
yol tarifi: [url_launcher](https://pub.dev/packages/url_launcher/versions/6.3.2).
OpenStreetMap'in görünür atıf, uygulama kimliği ve önbellekleme gereksinimleri
[Tile Usage Policy](https://operations.osmfoundation.org/policies/tiles/) belgesindedir.

## İsteğe bağlı backend

```powershell
cd "C:\Users\merve\new\backend"
.\.venv\Scripts\python.exe -m uvicorn app.main:app --host 127.0.0.1 --port 8000
```

Harita ve pin kaydetme backend gerektirmez. Mevcut mutfak backend'i kural tabanlıdır.
