import 'dart:async';

import 'package:flutter/material.dart';
import '../provider/sensorProvider.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  /*
  @override
  void initState() {
    super.initState();
    final provider = context.read<SensorProvider>();

    // Initial fetch
    // provider.fetchSensor();

    // Auto-fetch every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      provider.fetchSensor();
    });
  }
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Inter',
        textTheme: TextTheme(
          bodySmall: TextStyle(fontWeight: FontWeight.w400), // Regular
          bodyMedium: TextStyle(fontWeight: FontWeight.w500), // Medium
          titleMedium: TextStyle(fontWeight: FontWeight.w600), // SemiBold
          titleLarge: TextStyle(fontWeight: FontWeight.bold), // Bold
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 90, // default is ~56, so 100 is taller,
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              "PoultryVent",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
          ),
        ),

        backgroundColor: Color(0xFFF9FAFB),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  color: Color(0xFFE6F4EA),
                  margin: EdgeInsets.only(left: 35, right: 35, top: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Air Quality Status",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),

                        Row(
                          children: [Text("Optimal"), Icon(Icons.air_rounded)],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
