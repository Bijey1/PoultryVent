import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/sensorModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SensorProvider with ChangeNotifier {
  SensorReading? _latestSensor;

  SensorReading? get latestSensor => _latestSensor;
  final url = Uri.parse("http://192.168.68.103:5052/api/Sensor"); //Mesh Wifi ip
  //:10.160.200.193 mobile phone hotspot

  //fetch from backend
  Future<void> fetchSensor() async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _latestSensor = SensorReading.fromJson(data);
      }
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  //fetch from backend
  Future<void> postSensor() async {
    final dataBody = {"Temperature": 200, "Humidity": 300, "Ammonia": 400};

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(dataBody),
      );

      if (response.statusCode == 200) {
        print("SUCCESS POSTED");
      }
    } catch (error) {
      print(error);
    }
  }
}
