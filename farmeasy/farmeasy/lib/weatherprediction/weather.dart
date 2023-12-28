import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }

class weather extends StatefulWidget {
  @override
  _weatherState createState() => _weatherState();
}

class _weatherState extends State<weather> {
  String key = '1dabe72d31cd2618114b822f32f64422';
  WeatherFactory ws;
  List<Weather> _dataforecast = [];
  Weather weatherinfo;
  AppState _state = AppState.NOT_DOWNLOADED;
  double lat, lon;
  bool loading = true;
  int currTemp = 30; // current temperature
  int maxTemp = 30; // today max temperature
  int minTemp = 2; // today min temperature

  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
    getpermission();
  }

  Future<void> getpermission() async {
    final serviceStatusLocation = await Permission.locationWhenInUse.isGranted;

    final status = await Permission.locationWhenInUse.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
      getlocation();
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  Future<void> getlocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = position.latitude;
      lon = position.longitude;

      print("${lat}${lon}");
    });

    queryForecast();
  }

  void queryForecast() async {
    /// Removes keyboard
    print("hai");
    FocusScope.of(context).requestFocus(FocusNode());

    List<Weather> forecasts = await ws.fiveDayForecastByLocation(lat, lon);
    Weather weather = await ws.currentWeatherByLocation(lat, lon);
    print(weather);

    setState(() {
      _dataforecast = forecasts;
      weatherinfo = weather;
      print(_dataforecast.length);
      debugPrint(_dataforecast.toString(), wrapWidth: 10240000);
      loading = false;
    });
  }

  Weather data(number) {
    return _dataforecast[number];
  }

  String weekday(int week) {
    switch (week) {
      case 1:
        {
          return "Monday";
        }
        break;

      case 2:
        {
          return "Tuesday";
        }
        break;

      case 3:
        {
          return "Wednesday";
        }
        break;

      case 4:
        {
          return "Thursday";
        }
        break;
      case 5:
        {
          return "Friday";
        }
        break;
      case 6:
        {
          return "Saturday";
        }
        break;
      case 7:
        {
          return "Sunday";
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      Size size = MediaQuery.of(context).size;
      var brightness = MediaQuery.of(context).platformBrightness;
      if (loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Scaffold(
          body: Center(
            child: Container(
              height: size.height,
              width: size.height,
              decoration: BoxDecoration(),
              child: SafeArea(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: size.height * 0.01,
                              horizontal: size.width * 0.05,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: (() {
                                    Navigator.pop(context);
                                  }),
                                  child: FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                  ),
                                ),
                                Align(
                                  child: Text(
                                    'Weather', //TODO: change app name
                                    style: GoogleFonts.questrial(
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.plusCircle,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.03,
                            ),
                            child: Align(
                              child: Text(
                                weatherinfo.areaName,
                                style: GoogleFonts.questrial(
                                  fontSize: size.height * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.005,
                            ),
                            child: Align(
                              child: Text(
                                weekday(weatherinfo.date.weekday),
                                style: GoogleFonts.questrial(
                                  color: Colors.black54,
                                  fontSize: size.height * 0.035,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.03,
                            ),
                            child: Align(
                              child: Text(
                                "${weatherinfo.temperature.celsius.toInt()} ˚C ",
                                style: GoogleFonts.questrial(
                                  color: currTemp <= 0
                                      ? Colors.blue
                                      : currTemp > 0 && currTemp <= 15
                                          ? Colors.indigo
                                          : currTemp > 15 && currTemp < 30
                                              ? Colors.deepPurple
                                              : Colors.pink,
                                  fontSize: size.height * 0.13,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.25),
                            child: Divider(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.005,
                            ),
                            child: Align(
                              child: Text(
                                weatherinfo.weatherMain, // weather
                                style: GoogleFonts.questrial(
                                  color: Colors.black54,
                                  fontSize: size.height * 0.03,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: size.height * 0.03,
                              bottom: size.height * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${weatherinfo.tempMin.celsius.floor()} ˚C", // min temperature
                                  style: GoogleFonts.questrial(
                                    color: minTemp <= 0
                                        ? Colors.blue
                                        : minTemp > 0 && minTemp <= 15
                                            ? Colors.indigo
                                            : minTemp > 15 && minTemp < 30
                                                ? Colors.deepPurple
                                                : Colors.pink,
                                    fontSize: size.height * 0.03,
                                  ),
                                ),
                                Text(
                                  '/',
                                  style: GoogleFonts.questrial(
                                    color: Colors.black54,
                                    fontSize: size.height * 0.03,
                                  ),
                                ),
                                Text(
                                  "${weatherinfo.tempMax.celsius.ceil()} ˚C", //max temperature
                                  style: GoogleFonts.questrial(
                                    color: maxTemp <= 0
                                        ? Colors.blue
                                        : maxTemp > 0 && maxTemp <= 15
                                            ? Colors.indigo
                                            : maxTemp > 15 && maxTemp < 30
                                                ? Colors.deepPurple
                                                : Colors.pink,
                                    fontSize: size.height * 0.03,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.black.withOpacity(0.05),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.01,
                                        left: size.width * 0.03,
                                      ),
                                      child: Text(
                                        'Forecast for today',
                                        style: GoogleFonts.questrial(
                                          color: Colors.black,
                                          fontSize: size.height * 0.025,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(size.width * 0.005),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          //TODO: change weather forecast from local to api get
                                          buildForecastToday(
                                            data(0)
                                                .date
                                                .toString()
                                                .substring(11, 16), //hour
                                            data(0)
                                                .temperature
                                                .celsius
                                                .toInt(), //temperature
                                            data(0)
                                                .windSpeed
                                                .toInt(), //wind (km/h)
                                            0, //rain chance (%)
                                            FontAwesomeIcons.sun, //weather icon
                                            size,
                                          ),
                                          buildForecastToday(
                                            data(1)
                                                .date
                                                .toString()
                                                .substring(11, 16),
                                            data(1).temperature.celsius.toInt(),
                                            data(0).windSpeed.toInt(),
                                            40,
                                            FontAwesomeIcons.cloud,
                                            size,
                                          ),
                                          buildForecastToday(
                                            data(2)
                                                .date
                                                .toString()
                                                .substring(11, 16),
                                            data(2).temperature.celsius.toInt(),
                                            data(2).windSpeed.toInt(),
                                            80,
                                            FontAwesomeIcons.cloudRain,
                                            size,
                                          ),
                                          buildForecastToday(
                                            data(3)
                                                .date
                                                .toString()
                                                .substring(11, 16),
                                            data(3).temperature.celsius.toInt(),
                                            data(3).windSpeed.toInt(),
                                            60,
                                            FontAwesomeIcons.snowflake,
                                            size,
                                          ),
                                          buildForecastToday(
                                            data(4)
                                                .date
                                                .toString()
                                                .substring(11, 16),
                                            data(4).temperature.celsius.toInt(),
                                            data(4).windSpeed.toInt(),
                                            40,
                                            FontAwesomeIcons.cloudMoon,
                                            size,
                                          ),
                                          buildForecastToday(
                                            data(5)
                                                .date
                                                .toString()
                                                .substring(11, 16),
                                            data(5).temperature.celsius.toInt(),
                                            data(5).windSpeed.toInt(),
                                            60,
                                            FontAwesomeIcons.snowflake,
                                            size,
                                          ),
                                          buildForecastToday(
                                            data(6)
                                                .date
                                                .toString()
                                                .substring(11, 16),
                                            data(6).temperature.celsius.toInt(),
                                            data(6).windSpeed.toInt(),
                                            50,
                                            FontAwesomeIcons.snowflake,
                                            size,
                                          ),
                                          buildForecastToday(
                                            data(7)
                                                .date
                                                .toString()
                                                .substring(11, 16),
                                            data(7).temperature.celsius.toInt(),
                                            data(7).windSpeed.toInt(),
                                            40,
                                            FontAwesomeIcons.cloudMoon,
                                            size,
                                          ),
                                          buildForecastToday(
                                            data(8)
                                                .date
                                                .toString()
                                                .substring(11, 16),
                                            data(8).temperature.celsius.toInt(),
                                            data(8).windSpeed.toInt(),
                                            30,
                                            FontAwesomeIcons.moon,
                                            size,
                                          ),
                                          buildForecastToday(
                                            data(9)
                                                .date
                                                .toString()
                                                .substring(11, 16),
                                            data(9).temperature.celsius.toInt(),
                                            data(9).windSpeed.toInt(),
                                            20,
                                            FontAwesomeIcons.moon,
                                            size,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.05,
                              vertical: size.height * 0.02,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.white.withOpacity(0.05),
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.02,
                                        left: size.width * 0.03,
                                      ),
                                      child: Text(
                                        '7-day forecast',
                                        style: GoogleFonts.questrial(
                                          color: Colors.black,
                                          fontSize: size.height * 0.025,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: EdgeInsets.all(size.width * 0.005),
                                    child: Column(
                                      children: [
                                        //TODO: change weather forecast from local to api get
                                        buildSevenDayForecast(
                                          weekday(data(0).date.weekday), //day
                                          data(1)
                                              .tempMin
                                              .celsius
                                              .round(), //min temperature
                                          data(1)
                                              .tempMax
                                              .celsius
                                              .round(), //max temperature
                                          FontAwesomeIcons.cloud, //weather icon
                                          size,
                                        ),
                                        buildSevenDayForecast(
                                          weekday(data(5).date.weekday), //day
                                          data(5)
                                              .tempMin
                                              .celsius
                                              .round(), //min temperature
                                          data(5).tempMax.celsius.round(),
                                          FontAwesomeIcons.sun,
                                          size,
                                        ),
                                        buildSevenDayForecast(
                                          weekday(data(15).date.weekday), //day
                                          data(15)
                                              .tempMin
                                              .celsius
                                              .round(), //min temperature
                                          data(15).tempMax.celsius.round(),
                                          FontAwesomeIcons.cloudRain,
                                          size,
                                        ),
                                        buildSevenDayForecast(
                                          weekday(data(20).date.weekday), //day
                                          data(20)
                                              .tempMin
                                              .celsius
                                              .round(), //min temperature
                                          data(20).tempMax.celsius.round(),
                                          FontAwesomeIcons.sun,
                                          size,
                                        ),
                                        buildSevenDayForecast(
                                          weekday(data(30).date.weekday), //day
                                          data(30)
                                              .tempMin
                                              .celsius
                                              .round(), //min temperature
                                          data(30).tempMax.celsius.round(),
                                          FontAwesomeIcons.sun,
                                          size,
                                        ),
                                        buildSevenDayForecast(
                                          weekday(data(39).date.weekday), //day
                                          data(39)
                                              .tempMin
                                              .celsius
                                              .round(), //min temperature
                                          data(39).tempMax.celsius.round(),
                                          FontAwesomeIcons.cloud,
                                          size,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

Widget buildForecastToday(String time, int temp, int wind, int rainChance,
    IconData weatherIcon, size) {
  return Padding(
    padding: EdgeInsets.all(size.width * 0.025),
    child: Column(
      children: [
        Text(
          time,
          style: GoogleFonts.questrial(
            color: Colors.black,
            fontSize: size.height * 0.02,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.005,
              ),
              child: FaIcon(
                weatherIcon,
                color: Colors.black,
                size: size.height * 0.03,
              ),
            ),
          ],
        ),
        Text(
          '$temp˚C',
          style: GoogleFonts.questrial(
            color: Colors.black,
            fontSize: size.height * 0.025,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
              ),
              child: FaIcon(
                FontAwesomeIcons.wind,
                color: Colors.grey,
                size: size.height * 0.03,
              ),
            ),
          ],
        ),
        Text(
          '$wind km/h',
          style: GoogleFonts.questrial(
            color: Colors.grey,
            fontSize: size.height * 0.02,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
              ),
              child: FaIcon(
                FontAwesomeIcons.umbrella,
                color: Colors.blue,
                size: size.height * 0.03,
              ),
            ),
          ],
        ),
        Text(
          '$rainChance %',
          style: GoogleFonts.questrial(
            color: Colors.blue,
            fontSize: size.height * 0.02,
          ),
        ),
      ],
    ),
  );
}

Widget buildSevenDayForecast(
    String time, int minTemp, int maxTemp, IconData weatherIcon, size) {
  return Padding(
    padding: EdgeInsets.all(
      size.height * 0.005,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.02,
              ),
              child: Text(
                time,
                style: GoogleFonts.questrial(
                  color: Colors.black,
                  fontSize: size.height * 0.025,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.25,
              ),
              child: FaIcon(
                weatherIcon,
                color: Colors.black,
                size: size.height * 0.03,
              ),
            ),
            Align(
              child: Padding(
                padding: EdgeInsets.only(
                  left: size.width * 0.15,
                ),
                child: Text(
                  '$minTemp˚C',
                  style: GoogleFonts.questrial(
                    color: Colors.black38,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                ),
                child: Text(
                  '$maxTemp˚C',
                  style: GoogleFonts.questrial(
                    color: Colors.black,
                    fontSize: size.height * 0.025,
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    ),
  );
}
