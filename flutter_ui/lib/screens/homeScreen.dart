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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<SensorProvider>(
                  builder: (context, provider, child) {
                    final latestRead = provider.latestSensor;
                    if (latestRead == null) {
                      return Text("No Data");
                    }

                    return Text("Temperature: ${latestRead.temperature}");
                  },
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<SensorProvider>().fetchSensor();
                      },
                      child: Text("Get Data"),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        context.read<SensorProvider>().postSensor();
                      },
                      child: Text("Post Data"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
