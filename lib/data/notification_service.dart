import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings);

    const channel = AndroidNotificationChannel(
      'medicine_immediate',
      'Immediate Notifications',
      description: 'Instant app feedback notifications',
      importance: Importance.max,
    );

    final androidPlugin =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(channel);
  }

  static Future<void> showImmediate(String title, String body) async {
    const android = AndroidNotificationDetails(
      'medicine_immediate',
      'Immediate Notifications',
      importance: Importance.max,
      priority: Priority.max,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      const NotificationDetails(android: android),
    );
  }
}
