import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static void initilize() {
    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _notificationsPlugin.initialize(initializationSettings);
  }

  static void showNotificationOnForeground(RemoteMessage message) {
    final notificationDetail = NotificationDetails(
        android: AndroidNotificationDetails(
            "com.example.lost_and_found_app_staff",
            "lost_and_found_app_staff",
            importance: Importance.max,
            priority: Priority.high));

    _notificationsPlugin.show(
        DateTime.now().microsecond,
        message.notification!.title,
        message.notification!.body,
        notificationDetail,
        payload: message.data["message"]);
  }
}