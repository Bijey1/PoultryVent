import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/homeScreen.dart';
import 'provider/sensorProvider.dart';

void main() {
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
