import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ui/noti_service.dart';
import 'package:provider/provider.dart';
import 'screens/homeScreen.dart';
import 'provider/sensorProvider.dart';

final NotiService notiService = NotiService();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> requestNotificationPermission() async {
  final android = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  await android?.requestNotificationsPermission();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await notiService.initNotification();
  await requestNotificationPermission();
  runApp(
    ChangeNotifierProvider(
      create: (context) => SensorProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen();
  }
}
