# Kendime Söz 🎟️ — Alışkanlık ve Yaşam Takip Mobil Uygulaması

**Kendime Söz**, kullanıcının maneviyat ve iyilik, ders ve gelişim alanlarında mikro alışkanlıklar oluşturduğu, günlük ilerlemesini ve serilerini (streak) takip ettiği ve seçtiği kişisel deneyim ödüllerine ulaştığı çevrimdışı çalışan bir Flutter uygulamasıdır.

Ana fikir: **“İç dünyama iyi geliyorum, geleceğime yatırım yapıyorum, kendime güzel anılar hediye ediyorum.”**

---

## 📌 Temel Özellikler

### 1. Üç Sabit Ana Bölüm
- **Maneviyat ve İyilik 🤲 (`/maneviyat`):** İsteğe bağlı ibadet, şükür, tefekkür, birine yardım ve gönüllülük hedefleri.
- **Ders ve Gelişim 📚 (`/ders`):** Ders çalışma, soru çözme, kitap okuma, kodlama ve odaklanma oturumları.
- **Kendime Zaman 🎟️ (`/kendime-zaman`):** Kişisel ödül biletleri (müze gezisi, sahil yürüyüşü, kahve molası vb.).

### 2. Akıllı Alışkanlık ve Seri (Streak) Sistemi
- **Hedef Türleri:** Tek Onay (`check`), Adet (`count`), Süre (`duration` / dakika).
- **Seri Hesaplama:** Seri takvimde ardışık tüm günler üzerinden değil, yalnızca o alışkanlığın planlanan günleri üzerinden hesaplanır. Bugünkü plan gün bitene kadar önceki seriyi korur. Kaçırılan geçmiş planlı gün seriyi sıfırlar.
- **Oran Hesaplama:** Tamamlanan planlı alışkanlık-gün / vadesi gelen planlı alışkanlık-gün × 100. Gelecek günler paydada yer almaz.

### 3. Kişisel Deneyim Ödül Biletleri 🎟️
- **Tek Aktif Ödül Kuralı:** Sistemde aynı anda yalnızca tek bir bilet aktif olabilir.
- **Adım Katkısı:** Her seçili alışkanlık bir günde en fazla 1 adım kazandırır.
- **Durum Akışı:** `draft` ➔ `active` ➔ `earned` ➔ `planned` ➔ `used`.
- **Planlama:** Kazanılan ödül için tarih, saat, mekan ve kişisel not kaydedilebilir.

### 4. Pomodoro Odaklanma Sayacı ⏱️
- 15, 25, 45, 60 dakika veya özel süre seçimi.
- Oturum durumu (`running`, `paused`, `completed`, `canceled`) veritabanında kalıcıdır; uygulama kapanıp açılsa dahi durum korunur.
- Oturum bitiminde tamamlanan dakikalar günlük alışkanlığa eklenir ve hedefe ulaşılınca otomatik tamamlanır.

### 5. İlerlemem ve Başarı Rozetleri 🏅
- Haftalık ve aylık tamamlama yüzdesi kartları.
- **GitHub benzeri Katkı Izgarası:** Son 60 günün tamamlama yoğunluğu matrisi.
- **Rozetler:** İlk Adım (`first_step` 🌱), Ritim Buldum (`in_the_rhythm` 🔥), Yeniden Başladım (`started_again` 💪), İlk Bilet (`first_ticket` 🎟️).
- **Günün Kişisel Notu:** Her güne özel kişisel not / günlük tutma alanı.

---

## 🏛️ Mimari (Clean Architecture)

```
Widget ──► Controller (Riverpod) ──► Repository Interface (Domain)
                                              ▲
                                              │
                    Repository Implementation (Data) ──► Drift SQLite DB
```

- **Domain Katmanı:** Saf Dart. Flutter, Riverpod, Drift ve BuildContext bağımlılığı içermez.
- **Presentation Katmanı:** Material 3, Riverpod `Notifier`/`AsyncNotifier`, GoRouter akıllı shell routing (`StatefulShellRoute.indexedStack`).
- **Data Katmanı:** Drift SQLite ORM, transaction yönetimi, atomik güncellemeler.
- **Infrastructure Katmanı:** Drift DB, SharedPreferences (tercihler), LocalNotificationService (yerel bildirimler).

---

## 🚀 Kurulum ve Çalıştırma

### Gereksinimler
- **Flutter SDK:** >= 3.24.0 (Test edilen: 3.47.6)
- **Dart SDK:** >= 3.5.0 (Test edilen: 3.13.5)

### Adımlar

1. **Bağımlılıkları yükleyin:**
   ```bash
   flutter pub get
   ```

2. **Drift kod üretimini çalıştırın (gerekirse):**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Statik analiz kontrolü:**
   ```bash
   flutter analyze
   ```

4. **Birim testleri çalıştırın:**
   ```bash
   flutter test
   ```

5. **Uygulamayı başlatın:**
   ```bash
   flutter run
   ```

---

## 📱 Sayfa Rotaları (GoRouter)

- `/bootstrap` — Başlangıç veritabanı açılışı ve yükleme durumu
- `/onboarding` — İlk karşılama, felsefe tanıtımı ve başlangıç şablonları
- `/maneviyat` — Maneviyat ve İyilik sekmesi
- `/ders` — Ders ve Gelişim sekmesi (varsayılan ana sayfa)
- `/kendime-zaman` — Ödül biletleri sekmesi
- `/habits/:id` — Alışkanlık detay, istatistik ve düzenleme sayfası
- `/progress` — İlerlemem, katkı ızgarası, rozetler ve günlük not sayfası
