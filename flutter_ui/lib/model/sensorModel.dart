class SensorReading {
  int temperature;

  SensorReading({required this.temperature});

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(temperature: json["temperature"]);
  }
}
