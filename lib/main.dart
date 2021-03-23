// import 'dart:html';

import 'package:flutter/material.dart';
// import 'package:project_1/login.dart';
import 'package:project_1/planner_screen.dart';
// import 'package:project_1/presentation/my_flutter_app_icons.dart';
import 'package:project_1/six_jars_screen.dart';
import 'package:project_1/to_do_screen.dart';

import 'package:project_1/appBar/setting_screen.dart';
import 'package:project_1/appBar/analytic_screen.dart';
import 'package:project_1/appBar/theory_screen.dart';

import 'package:project_1/splash_screen.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:project_1/widget/logged_in_widget.dart';
import 'package:project_1/login.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// void main() => runApp(MaterialApp(
//       home: SplashScreen(),
//     ));

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: SplashScreen(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(initialPage: 1);
  int _currentPage = 1;
  final user = FirebaseAuth.instance.currentUser;

  final tabs = [
    ToDoRoute(),
    SixJarsRoute(),
    PlannerPage(),
  ];

  _showProfileDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Color(0xffF6F4E6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Center(child: Text("Profile")),
              content: Container(
                // alignment: Alignment.center,
                // color: Colors.blueGrey.shade900,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      maxRadius: 25,
                      backgroundImage: NetworkImage(user.photoURL),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Name: ' + user.displayName,
                      style: TextStyle(color: Color(0xff52575D)),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Email: ' + user.email,
                      style: TextStyle(color: Color(0xff52575D)),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffFDDB3A), // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: CircleAvatar(
                maxRadius: 25,
                backgroundImage: NetworkImage(user.photoURL),
              ),
              onPressed: () {
                //maybe change into _showDialog in future
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => LoggedInWidget()));
                _showProfileDialog();
              },
            ),
          ],
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
        ),
        // body: tabs[_currentPage],
        body: PageView(
          controller: pageController,
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
          },
          children: [
            ToDoRoute(),
            SixJarsRoute(),
            PlannerPage(),
          ],
        ),
        drawer: Theme(
          data: Theme.of(context).copyWith(canvasColor: Color(0xffF6F4E6)),
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.insert_chart),
                      Text(' Summary'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AnalyticsPage()));
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.book),
                      Text(' Theories'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TheoryPage()));
                  },
                ),
                ListTile(
                  title: Row(
                    children: [
                      Icon(Icons.settings),
                      Text(' Setting'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SettingPage()));
                  },
                ),
              ],
            ),
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFF41444B),
          // fixedColor: Color(0xffFDDB3A),
          items: [
            BottomNavigationBarItem(
                // icon: Image.asset('asset/icon/ToDo.png'),
                icon: Icon(Icons.check_box,
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
                icon: Icon(Icons.local_atm,
                    // icon: Icon(Icons.attach_money_rounded,
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
              icon: Icon(Icons.event,
                  color: _currentPage == 2
                      ? Color(0xffFDDB3A)
                      : Color(0xffF6F4E6)),
              title: Text("Planner",
                  style: TextStyle(
                      color: _currentPage == 2
                          ? Color(0xffFDDB3A)
                          : Color(0xffF6F4E6))),
            ),
          ],
          onTap: (index) {
            _currentPage = index;

            // pageController.animateToPage(index, duration: Duration(milliseconds:  200),
            // curve: Curves.linear); //decoration

            pageController.jumpToPage(index);
            setState(() {});
          },
        ),
      ),
    );
  }
}
