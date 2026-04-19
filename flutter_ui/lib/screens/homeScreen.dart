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

  @override
  void initState() {
    super.initState();
    final provider = context.read<SensorProvider>();

    // Initial fetch
    // provider.fetchSensor();

    // Auto-fetch every 1 seconds
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      provider.fetchSensor();
      //provider.countDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Inter'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
          ),
          child: NavigationBar(
            indicatorColor: colors("second"),
            elevation: 20,
            backgroundColor: Color(0xFFF9FAFB),
            destinations: [
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(
                icon: Icon(Icons.sensors_rounded),
                label: "Sensors",
              ),
              NavigationDestination(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
            ],
          ),
        ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                //Top Card
                Card(
                  elevation: 4,
                  color: Color(0xFFE6F4EA),
                  margin: EdgeInsets.only(left: 35, right: 35, top: 5),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title Card
                        Text(
                          "Air Quality Status",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),

                        //OPTIMAL AND AIR ICON
                        Row(
                          spacing: 30,
                          children: [
                            Text(
                              "Optimal",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: colors("primary"),
                              ),
                            ),
                            Icon(
                              Icons.air_rounded,
                              color: colors("primary"),
                              size: 65,
                            ),
                          ],
                        ),

                        //Last part BELOW of card

                        //TEMP, HUMID, AMMON
                        Consumer<SensorProvider>(
                          builder: (context, provider, child) {
                            final sensorStatus = provider.topSensor;

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildStatusCard(
                                  "Temperature",
                                  sensorStatus["temp"] ?? "Cool",
                                ),
                                buildStatusCard(
                                  "Humidity",
                                  sensorStatus["humidity"] ?? "Moderate",
                                ),
                                buildStatusCard(
                                  "Ammonia",
                                  sensorStatus["ammon"] ?? "Low",
                                ),
                              ],
                            );
                          },
                        ),

                        //GOOD GOOD CARDS BELOW
                      ],
                    ),
                  ),
                ),

                //Sensor Cards Below Top Card
                Divider(
                  height: 35,
                  color: Color(0xFFE5E7EB),
                  indent: 35,
                  endIndent: 35,
                ),

                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 35.0),
                    child: Text(
                      "Current Sensor Readings",
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                        fontWeight: fontW("meduim"),
                      ),
                    ),
                  ),
                ),

                Consumer<SensorProvider>(
                  builder: (context, provider, child) {
                    final temperature = provider.latestSensor?.temperature ?? 0;
                    final humidity = provider.latestSensor?.humidity ?? 0;
                    final ammonia = provider.latestSensor?.ammonia ?? 0;

                    final tempStatus = provider.topSensor["temp"];
                    final humidStatus = provider.topSensor["humidity"];
                    final ammonStatus = provider.topSensor["ammon"];

                    //TEST COUNTDOWN
                    final count = provider.testing;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          spacing: 20,
                          children: [
                            sensorCards(
                              Icons.thermostat_rounded,
                              "Temperature",
                              temperature,
                              "temp",
                              tempStatus == "Cool"
                                  ? "primary"
                                  : tempStatus == "Comfot"
                                  ? "lGreen"
                                  : tempStatus == "Warm"
                                  ? "yellow"
                                  : tempStatus == "Hot"
                                  ? "red"
                                  : "primary",
                            ),

                            sensorCards(
                              Icons.science_rounded,
                              "Ammonia",
                              ammonia,
                              //count,
                              "ammonia",
                              ammonStatus == "Low"
                                  ? "primary"
                                  : ammonStatus == "Moderate"
                                  ? "lGreen"
                                  : ammonStatus == "High"
                                  ? "yellow"
                                  : ammonStatus == "Critical"
                                  ? "red"
                                  : "primary",
                            ),
                          ],
                        ),

                        Column(
                          spacing: 20,
                          children: [
                            sensorCards(
                              Icons.water_drop_rounded,
                              "Humidity",
                              humidity,
                              "humid",
                              humidStatus == "Low"
                                  ? "primary"
                                  : humidStatus == "Moderate"
                                  ? "lGreen"
                                  : humidStatus == "High"
                                  ? "yellow"
                                  : humidStatus == "Critical"
                                  ? "red"
                                  : "primary",
                            ),

                            sensorCards(
                              Icons.mode_fan_off_outlined,
                              "Fan",
                              20.0,
                              "fan",
                              "primary",
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sensorCards(
    IconData sensorIcon,
    String name,
    double value,
    String type,
    String color,
  ) {
    return Card(
      elevation: 5,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey.shade400,
          // border color
          width: 1, // thickness
        ),
      ),

      child: Container(
        width: 130,
        height: 112,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(sensorIcon, color: colors(color), size: 40),

              SizedBox(height: 10),
              Text(
                name,
                style: TextStyle(fontSize: 14, fontWeight: fontW("meduim")),
              ),
              Text(
                type == "temp"
                    ? "${value.toString()}°C"
                    : type == "humid"
                    ? "${value.toString()}%"
                    : type == "ammonia"
                    ? "${value.toString()}ppm"
                    : "Auto",
                style: TextStyle(fontWeight: fontW("semiBold"), fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Top Card Status Cards
  Widget buildStatusCard(String sensorType, String condition) {
    return Expanded(
      child: Column(
        spacing: 7,
        children: [
          Text(
            sensorType,
            style: TextStyle(fontSize: 14, fontWeight: fontW("meduim")),
          ),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 60,
                maxWidth: 100, // prevents overflow
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12, // slightly reduced for balance
                  vertical: 3,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    condition,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: 14,
                      color: getConditionColor(sensorType, condition),
                      fontWeight: fontW("meduim"),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getConditionColor(String sensorType, String condition) {
    final value = condition.toLowerCase().trim();

    //  TEMPERATURE GROUP
    if (sensorType == "Temperature") {
      if (value == "cool") return colors("primary"); // safe
      if (value == "comfort") return colors("lGreen"); // normal
      if (value == "warm") return colors("yellow"); // warning
      if (value == "hot") return colors("red"); // danger
    }

    //  HUMIDITY GROUP
    if (sensorType == "Humidity") {
      if (value == "low") return colors("primary"); // safe
      if (value == "moderate") return colors("lGreen"); // normal
      if (value == "high") return colors("yellow"); // warning
      if (value == "critical") return colors("red"); // danger
    }

    if (sensorType == "Ammonia") {
      if (value == "low") return colors("primary"); // safe
      if (value == "moderate") return colors("lGreen"); // normal
      if (value == "high") return colors("yellow"); // warning
      if (value == "critical") return colors("red"); // danger
    }

    // default fallback
    return colors("primary");
  }

  Color colors(String whatColor) {
    if (whatColor == "primary") {
      return Color(0xFF2F6B3F); // safe (cool / low)
    } else if (whatColor == "second") {
      return Color(0xFFE6F4EA); // KEEP AS IS
    } else if (whatColor == "yellow") {
      return Color(0xFFF59E0B); // darker / stronger warning (high)
    } else if (whatColor == "lGreen") {
      return Color(0xFF5FA46A); // new: soft / moderate state
    } else if (whatColor == "red") {
      return Color(0xFFDC2626); // critical
    }
    return Colors.white;
  }

  FontWeight fontW(String size) {
    if (size == "meduim")
      return FontWeight.w500;
    else if (size == "semiBold")
      return FontWeight.w600;
    else if (size == "bold")
      return FontWeight.bold;
    else
      return FontWeight.w400; //Regular
  }
}
