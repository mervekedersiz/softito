---
name: flutter-feature-scaffold
description: Flutter projelerinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini, UI ayrımını ve birim test iskeletini standartlara uygun olarak üretir.
---

# Flutter Feature Scaffold (Modüler Ekran İskeleti)

Bu yetenek, projede yeni bir ekran ya da işlev modülü açarken Clean UI ve reaktif State kurallarına tam uyulmasını garanti altına alır.

## Temel Kurallar
1. **Asla tek dosyada toplama:** 
   UI (`_view.dart`), State Controller (`_controller.dart`), Model (`_model.dart`) ve alt bileşenler (`widgets/`) dosyaları ayrı ayrı açılmalıdır.

2. **State Yönetimi:** 
   Hafif, yerel ve reaktif durumlar için `ValueNotifier` ve `ValueListenableBuilder` kullanılmalıdır.
   Doğrudan devasa `StatefulWidget`'lar ve sayfa genelinde ağır `setState` çağrıları yaparak mimariyi karmaşıklaştırmaktan kesinlikle kaçınılmalıdır.

3. **Const Zorunluluğu:**
   Statik olan tüm widget'larda `const` ifadesi zorunludur.

4. **Metot Boyutu Sınırı:**
   40 satırı geçen `build` metotları alt özel widget sınıflarına ayrıştırılmalıdır.

---

## Adım Adım Uygulama Akışı

### Adım 1: Klasör Yapısı Oluşturma
Hedeflenen modül adlarını (örnek: `water_tracker`), `lib/features/<feature_name>` altına kur:

```text
lib/features/<feature_name>/
    controllers/
        <feature_name>_controller.dart
    models/
        <feature_name>_model.dart
    views/
        <feature_name>_view.dart
    widgets/
        <feature_name>_card.dart
```

---

### Adım 2: Model Dosyasını Oluşturma
`models/<feature_name>_model.dart` dosyasını `copyWith`, `fromJson`, `toJson` metotlarını içerecek şekilde `immutable` (`const` constructor) olarak tanımla:

```dart
class UserProfile {
  final String name;
  final String email;
  final String profileImage;
  final int level;
  final int coins;

  const UserProfile({
    required this.name,
    required this.email,
    required this.profileImage,
    required this.level,
    required this.coins,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? profileImage,
    int? level,
    int? coins,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      level: level ?? this.level,
      coins: coins ?? this.coins,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      level: (json['level'] as num?)?.toInt() ?? 0,
      coins: (json['coins'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'level': level,
      'coins': coins,
    };
  }
}
```

---

### Adım 3: Controller Dosyasını Yazma
`controllers/<feature_name>_controller.dart` içinde mantığı `ValueNotifier` tanımları ve `dispose` metodu ile oluştur:

```dart
import 'package:flutter/foundation.dart';

class WaterTrackerController {
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);
  final int dailyGoalWater = 2000; // 2 Litre

  void addWater() {
    currentWater.value += 250;
  }

  void resetWater() {
    currentWater.value = 0;
  }

  void dispose() {
    currentWater.dispose();
  }
}
```

---

### Adım 4: Alt Bileşen (Widget) Dosyasını Oluşturma
`widgets/<feature_name>_card.dart` dosyasında `StatelessWidget` kullanılarak alt bileşen UI katmanını oluştur:

```dart
import 'package:flutter/material.dart';

class WaterTrackerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final int level;
  final int coins;

  const WaterTrackerCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.level,
    required this.coins,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level: $level'),
                Text('Coins: $coins'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

---

### Adım 5: View Dosyasını Oluşturma
`views/<feature_name>_view.dart` dosyasında `StatelessWidget` ve `ValueListenableBuilder` kullanılarak UI katmanını bağla:

```dart
import 'package:flutter/material.dart';
import '../controllers/water_tracker_controller.dart';

class WaterTrackerView extends StatelessWidget {
  final WaterTrackerController controller;

  const WaterTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Feature Scaffold'),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: controller.currentWater,
        builder: (context, currentWater, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Mevcut Su: $currentWater ml',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.addWater,
                  child: const Text('250 ml Ekle'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: controller.resetWater,
                  child: const Text('Sıfırla'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

---

## Clean Architecture ve Kod Kalitesi Kurallarına Uyum
- **Separation of Concerns:** Her dosyanın tek ve belirgin bir sorumluluğu olmalıdır.
- **Reusability:** Alt widget'lar ve controller diğer modüllerde de tekrar kullanılabilecek biçimde soyutlanmalıdır.
- **Testability:** Controller katmanı Flutter UI'dan bağımsız saf Dart ile test edilebilir olmalıdır (`unit test`).

---

## Kullanım Örnekleri

### Örnek 1: Ekranı Sayfada Entegre Etme
```dart
import 'package:flutter/material.dart';
import '../features/water_tracker/controllers/water_tracker_controller.dart';
import '../features/water_tracker/views/water_tracker_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final WaterTrackerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WaterTrackerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WaterTrackerView(controller: _controller);
  }
}
```

---

## Ekstra İpuçları
- **Dependency Injection:** Controller nesnelerini ihtiyaç duyulduğunda enjekte etmek için servis lokasyonları ya da kurucu parametreleri kullanılabilir.
- **Lifecycle Yönetimi:** Notifier sızıntılarını (memory leak) önlemek için controller'ın `dispose()` metodu widget ağacından ayrılma anında mutlaka çağrılmalıdır.
- **Testing:** `flutter analyze` ve `flutter test` adımları ile sıfır uyarı politikası benimsenmelidir.

---

## Sık Sorulan Sorular (SSS)
### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Projede yeni bir ekran, özellik modülü veya temiz state ayrımı gerektiren işlevler eklenirken kullanılmalıdır.

### Soru: Bu yeteneği hangi durumlarda kullanmamalıyım?
**Cevap:** Küçük bir tema renk düzeltmesi veya tek satırlık hata onarımları gibi yeni bir modül yapısı gerektirmeyen durumlarda kullanılmamalıdır.
