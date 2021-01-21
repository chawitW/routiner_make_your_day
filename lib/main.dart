// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:project_1/planner_screen.dart';
import 'package:project_1/presentation/my_flutter_app_icons.dart';
import 'package:project_1/six_jars_screen.dart';
import 'package:project_1/to_do_screen.dart';

import 'package:project_1/appBar/setting_screen.dart';
import 'package:project_1/appBar/about_screen.dart';
import 'package:project_1/appBar/analytic_screen.dart';
import 'package:project_1/appBar/theory_screen.dart';


import 'package:project_1/splash_screen.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


// void main() => runApp(MaterialApp(
//       home: SplashScreen(),
//     ));

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MaterialApp(
      home: SplashScreen(),));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(initialPage: 1);
  int _currentPage = 0;

  final tabs = [
    ToDoRoute(),
    SixJarsRoute(),
    PlannerRoute(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xffF6F4E6)),
        centerTitle: true,
        backgroundColor: Color(0xFF41444B),
        title: Text(
          'Routiner',
          style: TextStyle(
            color: Color(0xffFDDB3A),
            fontSize: 20.0,
            fontFamily: 'BPeople',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Color(0xffF6F4E6),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SettingPage()
                )
              );
            },
          )
        ],
      ),
      // body: tabs[_currentPage],
      body: PageView(
        controller: pageController,
        children: [
          // pageController.page==0? tabs[0]:_currentPage=0,
          // pageController.page==1? tabs[1]:_currentPage=1,
          // pageController.page==2? tabs[2]:_currentPage=2,

          ToDoRoute(),
          SixJarsRoute(),
          PlannerRoute(),
          //stuck on SLIDE and TOUCH to change pages
          //will leave it for now
        ],
      ),
      drawer: Drawer(
        child: ListView(
         padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: Text('Analytics'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AnalyticsPage()
                )
              );
              },
            ),
            ListTile(
              title: Text('Theories'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TheoryPage()
                )
              );
              },
            ),
            ListTile(
              title: Text('About us'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AboutUsPage()
                )
              );
                },
              ),
            ],
          ),
        ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF41444B),
        // fixedColor: Color(0xffFDDB3A),
        items: [
          BottomNavigationBarItem(
              // icon: Image.asset('asset/icon/ToDo.png'),
              icon: Icon(Icons.check_circle,
                  color: _currentPage == 0
                      ? Color(0xffFDDB3A)
                      : Color(0xffF6F4E6)),
              title: Text("To do",
                  style: TextStyle(
                      color: _currentPage == 0
                          ? Color(0xffFDDB3A)
                          : Color(0xffF6F4E6)))),
          BottomNavigationBarItem(
              // icon: Image.asset('asset/icon/Ledger.png'),
              icon: Icon(MyFlutterApp.money,
                  color: _currentPage == 1
                      ? Color(0xffFDDB3A)
                      : Color(0xffF6F4E6)),
              title: Text("Ledger",
                  style: TextStyle(
                      color: _currentPage == 1
                          ? Color(0xffFDDB3A)
                          : Color(0xffF6F4E6)))),
          BottomNavigationBarItem(
            // icon: Image.asset('asset/icon/Planner.png'),
            icon: Icon(MyFlutterApp.calendar,
                color:
                    _currentPage == 2 ? Color(0xffFDDB3A) : Color(0xffF6F4E6)),
            title: Text("Planner",
                style: TextStyle(
                    color: _currentPage == 2
                        ? Color(0xffFDDB3A)
                        : Color(0xffF6F4E6))),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
        },
      ),
    );
  }
}

