import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void>_firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Arka planda bildirim geldi: ${message.notification?.title}');
}
class FcmBildirimServisi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

 Future<void> baslat() async {
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localPlugin.initialize(initSettings);
    
    FirebaseMessaging.onMessage.listen((message) {
      _yerelBildirimGoster(message);
      onMesajGeldi(message);
    });
 Future<void> konudanAyrıl(String konu) async {
    await _firebaseMessaging.unsubscribeFromTopic(konu);
   
  }
  Future<void> konudanAboneOl(String konu) async {
    await _firebaseMessaging.subscribeToTopic(konu);
   
  }
 Future<void> _yerelBildirimGoster(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'kanal_id',
      'Kanal Adı',
      importance: Importance.max,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localPlugin.show(
      id:message.hashCode,
      title:message.notification?.title ?? '',
      body:message.notification?.body ?? '',
      notificationDetails,
  
    );
  }
  


}}