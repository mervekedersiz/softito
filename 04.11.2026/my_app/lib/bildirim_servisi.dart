import 'package:firebase_messaging/firebase_messaging.dart';

// Arka planda gelen bildirimleri yakalamak için global (top-level) fonksiyon
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Arka planda bildirim geldi: ${message.notification?.title}');
}

class BildirimServisi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> baslat() async {
    // Bildirim izni isteme
    NotificationSettings ayarlar = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 'settings' yerine tanımladığımız 'ayarlar' değişkenini kullanıyoruz
    if (ayarlar.authorizationStatus == AuthorizationStatus.authorized) {
      print('Kullanıcı bildirim izni verdi');
    } else {
      print('Kullanıcı bildirim izni vermedi');
    }

    // FCM Token alma
    final token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
  }
}
