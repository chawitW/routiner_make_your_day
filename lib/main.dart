// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:project_1/planner_screen.dart';
import 'package:project_1/presentation/my_flutter_app_icons.dart';
import 'package:project_1/six_jars_screen.dart';
import 'package:project_1/to_do_screen.dart';

void main() => runApp(MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(initialPage: 1);
  int _currentPage = 2;

  final tabs = [
    ToDoRoute(),
    SixJarsRoute(),
    PlannerRoute(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: PageView(
        controller: pageController,
        // body: tabs[_currentPage],
        children: [
          tabs[_currentPage],
          ToDoRoute(),
          SixJarsRoute(),
          PlannerRoute(),
          //stuck on SLIDE and TOUCH to change pages
          //will leave it for now
        ],
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
