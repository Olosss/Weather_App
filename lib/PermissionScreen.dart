// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/SplashScreen.dart';

import 'main.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({Key? key}) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
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
                Image(image: AssetImage('icons/hand-wave.png')),
                Padding(padding: EdgeInsets.only(top: 25.0)),
                Text(
                  'Cześć!',
                  style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 42.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                Padding(padding: EdgeInsets.only(top: 5.0)),
                Padding(
                  padding: EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                  child: Text(
                    'Aplikacja ${Strings.appTitle} potrzebuje do działania przybliżonej lokalizacji urządzenia',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 16.0, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 25,
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          padding: MaterialStateProperty.all(
                              EdgeInsets.only(top: 12.0, bottom: 12.0))),
                      onPressed: () async {
                        LocationPermission permission =
                            await Geolocator.requestPermission();

                        if (permission == LocationPermission.always ||
                            permission == LocationPermission.whileInUse) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SplashScreen()));
                        }
                      },
                      child: Text(
                        'Zgoda!',
                        style: TextStyle(fontSize: 16.0, color: Colors.black),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }
}
