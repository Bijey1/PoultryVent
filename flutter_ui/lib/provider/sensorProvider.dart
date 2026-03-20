import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/sensorModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SensorProvider with ChangeNotifier {
  SensorReading? _latestSensor;

  SensorReading? get latestSensor => _latestSensor;

  //fetch from backend
  Future<void> fetchSensor() async {
    final url = Uri.parse("http://192.168.68.106:5052/api/Sensor");

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
    final url = Uri.parse("http://192.168.68.106:5052/api/Sensor");

    final dataBody = {"Temperature": 200};

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
