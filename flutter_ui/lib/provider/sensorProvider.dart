import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ui/main.dart';
import 'package:flutter_ui/noti_service.dart';
import '../model/sensorModel.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class SensorProvider with ChangeNotifier {
  SensorReading? _latestSensor;
  // Labels per sensor type (Title Case)
  String tempCool = "Cool";
  String tempComfort = "Comfort";
  String tempWarm = "Warm";
  String tempHot = "Hot";

  String humLow = "Low";
  String humMid = "Moderate";
  String humHigh = "High";
  String humCritical = "Critical";

  String gasLow = "Low";
  String gasModerate = "Moderate";
  String gasHigh = "High";
  String gasCritical = "Critical";

  // Map
  Map<String, String> _topSensor = {
    "temp": "Cool",
    "humidity": "Low",
    "ammon": "Low",
  };

  //TESTING COUNTDOWN
  double _testing = 30;
  bool hasNotified = false;

  double get testing => _testing;

  Map<String, String> get topSensor => _topSensor;
  SensorReading? get latestSensor => _latestSensor;

  Future<void> countDown() async {
    _testing--;
    /*
    if (_testing >= 26) {
      _topSensor["ammon"] = high;
    } else if (_testing >= 11) {
      _topSensor["ammon"] = mid;
    } else {
      _topSensor["ammon"] = low;
    }
*/
    notifyListeners();
  }

  //fetch from backend
  final url = Uri.parse("http://10.110.170.193:5052/api/Sensor");
  // 10.110.170.193 april 16/04/2026 LAPTOP HOTSPOT NA NAKACONNECT SA OPOSIR
  //10.110.170.193

  Future<void> fetchSensor() async {
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        _latestSensor = SensorReading.fromJson(data);

        //Air status card above
        topSensorCard(_latestSensor!);

        //Notification condition
        if (_latestSensor!.ammonia >= 30 && !hasNotified) {
          hasNotified = true;

          await notiService.showNotif(
            title: "Warning",
            body: "Ammonia level is HIGH",
          );
        }

        // RESET when safe again
        if (_latestSensor!.ammonia < 30) {
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

    //  TEMPERATURE
    if (temp >= 28) {
      _topSensor["temp"] = tempHot; //Hot
    } else if (temp >= 24) {
      _topSensor["temp"] = tempWarm; //Warm
    } else if (temp >= 18) {
      _topSensor["temp"] = tempComfort; //Comfort
    } else {
      //Cool
      _topSensor["temp"] = tempCool;
    }

    //  HUMIDITY
    if (humidity >= 80) {
      _topSensor["humidity"] = humCritical;
    } else if (humidity >= 60) {
      _topSensor["humidity"] = humHigh;
    } else if (humidity >= 50) {
      _topSensor["humidity"] = humMid;
    } else {
      _topSensor["humidity"] = humLow;
    }

    //  AMMONIA
    if (ammonia >= 30) {
      _topSensor["ammon"] = gasCritical;
    } else if (ammonia >= 20) {
      _topSensor["ammon"] = gasHigh;
    } else if (ammonia >= 10) {
      _topSensor["ammon"] = gasModerate;
    } else {
      _topSensor["ammon"] = gasLow;
    }
  }

  void setDefaultGood() {
    _topSensor = {"temp": tempCool, "humidity": humLow, "ammon": gasLow};
  } //post from backend

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
