import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  bool _isInit = false;

  bool get isInit => _isInit;

  //INITIALIZE
  Future<void> initNotification() async {
    if (_isInit) return; //If it is already initialized

    //initialize
    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    //INIT SETTINGS
    const initSettings = InitializationSettings(android: initSettingsAndroid);

    //finally initialize the plugin
    await notificationsPlugin.initialize(settings: initSettings);
  }

  //NOTIFICATION DETAIL SETUP
  NotificationDetails notifDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "sensor", //Use different channel to popup
        "sensor notif",
        channelDescription: "Sensor Notification",
        importance: Importance.max,
        priority: Priority.high,

        // ✅ THIS FIXES YOUR CRASH
        icon: '@mipmap/ic_launcher',
      ),
    );
  }

  //SHOW NOTIFICATION
  Future<void> showNotif({int id = 0, String? title, String? body}) async {
    return notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notifDetails(),
    );
  }
}
