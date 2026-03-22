class SensorReading {
  double temperature;
  double humidity;
  double ammonia;

  SensorReading({
    required this.temperature,
    required this.humidity,
    required this.ammonia,
  });

  factory SensorReading.fromJson(Map<String, dynamic> json) {
    return SensorReading(
      temperature: (json["temperature"] as num).toDouble(),
      humidity: (json["humidity"] as num).toDouble(),
      ammonia: (json["ammonia"] as num).toDouble(),
    );
  }
}
