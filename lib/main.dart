import 'package:flutter/material.dart';
// import 'package:flutkart/pages/home_screen.dart';
import 'package:project_1/six_jars_screen.dart';
import 'package:project_1/splash_screen.dart';

var routes = <String, WidgetBuilder>{
  // "/home": (BuildContext context) => HomeScreen(),
  // "/intro": (BuildContext context) => IntroScreen(),
};

void main() => runApp(new MaterialApp(
    theme:
        ThemeData(primaryColor: Colors.red, accentColor: Colors.yellowAccent),
    debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    routes: routes));
