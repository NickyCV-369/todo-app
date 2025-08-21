import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/todo.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  static bool initialized = false;

  static Future<void> init() async {
    if (kIsWeb) {
      initialized = true;
      return;
    }
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const init = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(init);
    if (Platform.isAndroid) {
      final androidDetails = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      await androidDetails?.requestNotificationsPermission();
      await androidDetails?.requestExactAlarmsPermission();
    }
    initialized = true;
  }

  static Future<void> notifyDueSoon(List<Todo> todos) async {
    if (!initialized || kIsWeb) return;
    final now = DateTime.now();
    for (final t in todos) {
      if (t.dueDate == null) continue;
      final diff = t.dueDate!.difference(now).inMinutes;
      if (diff <= 15 && diff >= 0) {
        const details = NotificationDetails(
          android: AndroidNotificationDetails('todo_due', 'Todo Due', importance: Importance.high, priority: Priority.high),
          iOS: DarwinNotificationDetails(),
        );
        await _plugin.show(t.id, 'Sắp đến hạn', t.title, details);
      }
    }
  }
}
