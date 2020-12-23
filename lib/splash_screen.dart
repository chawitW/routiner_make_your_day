import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_1/main.dart';

void main() => runApp(MaterialApp(
      theme:
          ThemeData(primaryColor: Colors.red, accentColor: Colors.yellowAccent),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ));

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        // () => MyNavigator.goToHome(context));

        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage())));

    // () => print("\n\n\nSplahScreen!!!!\n\n\n")); //after SplashSceen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xff52575D)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              'asset/icon/Rountiner_logo.png',
                              width: MediaQuery.of(context).size.width * 0.35,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 20.0))
                        ]),
                  )),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      "Routiner",
                      style: TextStyle(
                          color: Color(0xffFDDB3A),
                          fontSize: 20.0,
                          fontFamily: 'BPeople'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20.0),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
