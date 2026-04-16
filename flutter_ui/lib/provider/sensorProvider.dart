import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ui/main.dart';
import 'package:flutter_ui/noti_service.dart';
import '../model/sensorModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SensorProvider with ChangeNotifier {
  SensorReading? _latestSensor;
  Map<String, String> _topSensor = {
    "temp": "Good",
    "humid": "Good",
    "ammon": "Good",
  };

  //TESTING COUNTDOWN
  double _testing = 30;
  bool hasNotified = false;

  double get testing => _testing;

  Map<String, String> get topSensor => _topSensor;
  SensorReading? get latestSensor => _latestSensor;

  Future<void> countDown() async {
    _testing--;

    if (_testing >= 26) {
      _topSensor["ammon"] = "High";
    } else if (_testing >= 11) {
      _topSensor["ammon"] = "Moderate";
    } else {
      _topSensor["ammon"] = "Good";
    }

    notifyListeners();
  }

  //fetch from backend
  final url = Uri.parse("http://10.110.170.193:5052/api/Sensor");
  // 10.110.170.193 april 16/04/2026 LAPTOP HOTSPOT NA NAKACONNECT SA OPOSIR
  Future<void> fetchSensor() async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _latestSensor = SensorReading.fromJson(data);

        //Air status card above
        topSensorCard(_latestSensor!);

        //Notification condition
        if (_latestSensor!.ammonia >= 26 && !hasNotified) {
          hasNotified = true;

          await notiService.showNotif(
            title: "Warning",
            body: "Ammonia level is HIGH",
          );
        }

        // RESET when safe again
        if (_latestSensor!.ammonia < 26) {
          hasNotified = false;
        }
      } else {
        //Set all status card to 'Good' for when error
        setDefaultGood();
      }

      //Notification if air quality is bad
    } catch (error) {
      print(error);
      print("Di makaconnect sa API");

      //Set all status card to 'Good' for when error
      setDefaultGood();
    }
    notifyListeners();
  }

  void topSensorCard(SensorReading current) {
    double temp = current.temperature;
    double humidity = current.humidity;
    double ammonia = current.ammonia;

    // 🌡️ TEMP
    if (temp >= 35) {
      _topSensor["temp"] = "High";
    } else if (temp >= 31) {
      _topSensor["temp"] = "Moderate";
    } else {
      _topSensor["temp"] = "Good";
    }

    // 💧 HUMIDITY
    if (humidity >= 81) {
      _topSensor["humidity"] = "High";
    } else if (humidity >= 71) {
      _topSensor["humidity"] = "Moderate";
    } else {
      _topSensor["humidity"] = "Good";
    }

    // 🧪 AMMONIA
    if (ammonia >= 26) {
      _topSensor["ammon"] = "High";
    } else if (ammonia >= 11) {
      _topSensor["ammon"] = "Moderate";
    } else {
      _topSensor["ammon"] = "Good";
    }
  }

  void setDefaultGood() {
    _topSensor = {"temp": "Good", "humidity": "Good", "ammon": "Good"};
  }

  //post from backend
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
