// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/WeatherScreen.dart';

import 'PermissionScreen.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: new Color(0xffffffff),
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [new Color(0xff6671e5), new Color(0xff4852d9)]),
            ),
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(image: AssetImage('icons/cloud-sun.png')),
                Padding(padding: EdgeInsets.only(top: 25.0)),
                Text(
                  Strings.appTitle,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 42.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Text(
                  'Aplikacja do dostarczania \n informacji o pogodzie.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle:
                          TextStyle(fontSize: 16.0, color: Colors.white)),
                ),
              ],
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 35,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Ładuje dane...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  )),
                ),
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  void checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PermissionScreen()));
    } else {
      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
        executeOnceAfterBuild();
      });
    }
  }

  void executeOnceAfterBuild() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.lowest,
            forceAndroidLocationManager: true,
            timeLimit: Duration(seconds: 5))
        .then((value) => {loadLocationData(value)})
        .onError((error, stackTrace) => {
              Geolocator.getLastKnownPosition(forceAndroidLocationManager: true)
                  .then((value) => {loadLocationData(value)})
            });
  }

  loadLocationData(Position? value) async {
    var lat = value!.latitude;
    var lon = value.longitude;

    WeatherFactory weatherFactory = WeatherFactory(
        "cda73e7394d9d764227e382efd2d864a",
        language: Language.POLISH);
    Weather weather = await weatherFactory.currentWeatherByLocation(lat, lon);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WeatherScreen(weather: weather)));
  }
}
