// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather.dart';

class WeatherScreen extends StatefulWidget {
  var weather;

  WeatherScreen({Key? key, this.weather}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: new Color(0xffffffff),
              gradient: getGradientByMood(widget.weather),
            ),
          ),
          Align(
            alignment: FractionalOffset.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 45.0)),
                Image(
                    image: AssetImage(
                        'icons/${getIconByMood(widget.weather)}.png')),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                Text('${widget.weather.areaName.toString()}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        fontSize: 32.0,
                        height: 1.2,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                Text(
                  "${DateFormat.MMMMEEEEd('pl').format(DateTime.now())}, ${widget.weather.weatherDescription}",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      fontSize: 14.0,
                      height: 1.2,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
                Padding(padding: EdgeInsets.only(top: 32.0)),
                Text(
                    '${widget.weather.temperature!.celsius!.floor().toString()}°C',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        fontSize: 64.0,
                        height: 1.2,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Text(
                    'Odczuwalna ${widget.weather.tempFeelsLike!.celsius!.floor().toString()}°C',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        fontSize: 14.0,
                        height: 1.2,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
                Padding(padding: EdgeInsets.only(top: 45.0)),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Ciśnienie',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    fontSize: 14.0,
                                    height: 1.2,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),
                            Text(
                                '${widget.weather.pressure!.floor().toString()} hPa',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    fontSize: 26.0,
                                    height: 1.2,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        width: 48,
                        thickness: 1,
                        color: Colors.white,
                      ),
                      Container(
                        width: 130,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text('Wiatr',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    fontSize: 14.0,
                                    height: 1.2,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),
                            Text('${widget.weather.windSpeed} m/s',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    fontSize: 26.0,
                                    height: 1.2,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 24.0)),
                if (widget.weather.rainLastHour != null)
                  Text('Opady: ${widget.weather.rainLastHour} mm/1h',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                          fontSize: 14.0,
                          height: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                Padding(padding: EdgeInsets.only(top: 38.0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool havePermission() {
    return true;
  }

  String getIconByMood(Weather weather) {
    var main = weather.weatherMain;
    print(main);
    if (isNight(weather)) {
      return 'weather-moonny';
    } else if (main == 'Clouds' || main == 'Drizzle' || main == 'Snow' || main == 'Rain') {
      return 'weather-rain';
    } else if (main == 'Thunderstorm') {
      return 'weather-lightning';
    } else {
      return 'weather-sunny';
    }
  }

  bool isNight(Weather weather) {
    return DateTime.now().isAfter(weather.sunset!) ||
        DateTime.now().isBefore(weather.sunrise!);
  }

  LinearGradient getGradientByMood(Weather weather) {
    var main = weather.weatherMain;
    print(isNight(weather));
    if (main == 'Thunderstorm' || isNight(weather)) {
      return LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [new Color(0xff313545), new Color(0xff121118)]);
    } else if (main == 'Clouds' || main == 'Drizzle' || main == 'Snow' || main == 'Rain') {
      return LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            new Color(0xff6E6CD8),
            new Color(0xff40A0EF),
            new Color(0xff77E1EE)
          ]);
    } else {
      return LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [new Color(0xff5283F0), new Color(0xffCDEDD4)]);
    }
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }
}
