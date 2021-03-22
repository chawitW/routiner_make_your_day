import 'dart:convert';
import 'indicator.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:pie_chart/pie_chart.dart';

void main() {
  runApp(MaterialApp(home: AnalyticsPage()));
}

class AnalyticsPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<AnalyticsPage>
    with TickerProviderStateMixin {
  TabController jarController;
  int _currentJar = 0;
  TabController rangeController;
  int _currentRange = 0;
  List jarIcon = [
    Icons.account_balance_wallet_rounded,
    Icons.school_rounded,
    Icons.account_balance_rounded,
    Icons.trending_up_rounded,
    Icons.card_travel_rounded,
    Icons.card_giftcard_rounded,
  ];
  final user = FirebaseAuth.instance.currentUser;

  List listMatrix = [
    "Urgent and important",
    "Not urgent and important",
    "Urgent and not important",
    "Not urgent and not important"
  ];
  List<Color> activityColors = [
    Color(0xff7FDBDA),
    Color(0xffFFD5CD),
    Color(0xff8675A9),
    Color(0xffADE498),
    Color(0xffFA7F72),
    Color(0xffF6F4E6),
  ];
  List activityList = [
    "Core responsibility",
    "Personal growth",
    "Managing people",
    "Free time",
    "Crisis",
    "Admin",
  ];
  List _amountTime = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];

  Widget _buildCompletedTask() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(user.email)
          .doc(user.email)
          .collection("CompletedTodo")
          .snapshots(),
      builder: (context, snapshots) {
        if (snapshots.data == null) {
          return CircularProgressIndicator();
        } else {
          return Container(
            margin: EdgeInsets.only(bottom: 10, top: 5),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: snapshots.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshots.data.docs[index];
                  return Card(
                    color: Color(0xffF6F4E6),
                    margin: EdgeInsets.only(left: 10, right: 10, top: 4),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(documentSnapshot["groupTag"],
                          style: TextStyle(fontSize: 15)),
                      children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection(user.email)
                              .doc(user.email)
                              .collection("CompletedTodo")
                              .doc(documentSnapshot["groupTag"])
                              .collection("groupList")
                              .snapshots(),
                          builder: (context, snapshots) {
                            if (snapshots.data == null) {
                              return CircularProgressIndicator();
                            } else {
                              return Container(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshots.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot documentSnapshot =
                                        snapshots.data.docs[index];
                                    return Text(documentSnapshot["todoTitle"]);
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }),
          );
        }
      },
    );
  }

  int touchedIndex;

  List<String> range = [
    "Week",
    "Month",
    "Year",
  ];
  List<String> jarName = [
    "Need jar",
    "Education jar",
    "Long-term saving jar",
    "Investment jar",
    "Self reward jar",
    "Donation jar",
  ];
  double _amountIncome = 0.0;
  double _amountOutgo = 0.0;

  List<double> _arrIncome = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> _arrOutgo = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

  Widget _buildFinancialGraph() {
    return Container(
      // margin: EdgeInsets.all(10),
      child: Column(
        children: [
          // TabBar(
          //   unselectedLabelColor: Color(0xFF41444B),
          //   indicatorColor: Color(0xffFDDB3A),
          //   controller: rangeController,
          //   tabs: <Tab>[
          //     for (int i = 0; i < 3; i++)
          //       Tab(
          //           icon: Text(range[i],
          //               style: TextStyle(
          //                   color: _currentRange == i
          //                       ? Color(0xffFDDB3A)
          //                       : Color(0xFF41444B))))
          //   ],
          //   onTap: (index) {
          //     _currentRange = index;
          //     setState(() {});
          //   },
          // ),
          SizedBox(
            height: 10,
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(user.email)
                  .doc(user.email)
                  .collection("Ledger")
                  .doc(jarName[_currentJar])
                  .collection("statementDate")
                  .snapshots(),
              builder: (context, snapshots) {
                // print(snapshots.data.docs[0]["statementList"]);
                // List amount = [];
                if (!snapshots.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return Column(
                    children: [
                      for (int i = 0; i < snapshots.data.docs.length; i++)
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(user.email)
                                .doc(user.email)
                                .collection("Ledger")
                                .doc(jarName[_currentJar])
                                .collection("statementDate")
                                .doc(snapshots.data.docs[i]["date"])
                                .collection("statementList")
                                .orderBy("ledgerDate")
                                .snapshots(),
                            builder: (context, snapshots) {
                              if (!snapshots.hasData) {
                                return CircularProgressIndicator();
                              } else {
                                _amountIncome = 0.0;
                                _amountOutgo = 0.0;
                                for (int i = 0;
                                    i < snapshots.data.docs.length;
                                    i++) {
                                  if (snapshots.data.docs[i]["ledgerType"] ==
                                      "Income") {
                                    _amountIncome += double.parse(
                                        snapshots.data.docs[i]["ledgerAmount"]);
                                  } else {
                                    _amountOutgo += double.parse(
                                        snapshots.data.docs[i]["ledgerAmount"]);
                                  }
                                }
                                _arrIncome[i] = _amountIncome;
                                _arrOutgo[i] = _amountOutgo;

                                return Container(
                                  width: 0,
                                  height: 0,
                                );
                                // Text("Income: " +
                                //     _amountIncome.toString() +
                                //     " Outgo: " +
                                //     _amountOutgo.toString());
                              }
                            }),
                      BarChart(BarChartData(barGroups: [
                        for (int j = 0; j < snapshots.data.docs.length; j++)
                          BarChartGroupData(x: j + 1, barRods: [
                            BarChartRodData(
                                y: _arrIncome[j],
                                colors: [
                                  Colors.greenAccent
                                  // Colors.greenAccent
                                ],
                                width: 3),
                            BarChartRodData(
                                y: _arrOutgo[j],
                                colors: [
                                  // Colors.redAccent
                                  Colors.redAccent
                                ],
                                width: 3)
                          ])
                      ])),
                    ],
                  );
                }
              }),
          TabBar(
            unselectedLabelColor: Color(0xFF41444B),
            indicatorColor: Color(0xffFDDB3A),
            controller: jarController,
            tabs: <Tab>[
              for (int i = 0; i < jarIcon.length; i++)
                Tab(
                    icon: Icon(jarIcon[i],
                        color: _currentJar == i
                            ? Color(0xffFDDB3A)
                            : Color(0xFF41444B))),
            ],
            onTap: (index) {
              _currentJar = index;
              // _amountIncome = (index + 1) * 2.0;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  _buildPieChart() {
    _amountTime = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Color(0xff52575D),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 18,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(user.email)
                        .doc(user.email)
                        .collection("Planner")
                        .orderBy("selectedDate", descending: false)
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (!snapshots.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        var _countDay = snapshots.data.docs.length;
                        _amountTime = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
                        return Column(
                          children: [
                            for (int i = 0; i < snapshots.data.docs.length; i++)
                              _drawPieChart(snapshots, _countDay, i),
                          ],
                        );
                      }
                    }),
              ),
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  _drawPieChart(snapshots, _countDay, i) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(user.email)
          .doc(user.email)
          .collection("Planner")
          .doc(snapshots.data.docs[i]["selectedDate"])
          .collection("plannerList")
          .snapshots(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return CircularProgressIndicator();
        } else {
          print(snapshots.data.docs.length);
          for (int j = 0; j < snapshots.data.docs.length; j++) {
            _amountTime[
                int.parse(snapshots.data.docs[j]["plannerActivityNumber"]) -
                    1] += _timeCalculate(
                snapshots.data.docs[j]["plannerTimeStart"],
                snapshots.data.docs[j]["plannerTimeEnd"]);
          }
          if (i == _countDay - 1) {
            return Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                PieChart(
                  PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections()),
                ),
              ],
            );
          }
          return Text("");
        }
      },
    );
  }

  double _timeCalculate(_startTime, _endTime) {
    int startTime, endTime;
    double diffTime;
    var arrStart = _startTime.split(":");
    var arrEnd = _endTime.split(":");

    startTime = int.parse(arrStart[0]) * 60 + int.parse(arrStart[1]);
    endTime = int.parse(arrEnd[0]) * 60 + int.parse(arrEnd[1]);
    diffTime = (endTime - startTime) / 60;
    return diffTime;
  }

  @override
  void initState() {
    _amountTime = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
    super.initState();
    // TODO: implement initState

    jarController = TabController(vsync: this, length: 6, initialIndex: 0);
    rangeController = TabController(vsync: this, length: 3, initialIndex: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    jarController?.dispose();
    rangeController?.dispose();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Completed task"),
                  children: [
                    _buildCompletedTask(),
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Financial graph"),
                  children: [
                    _buildFinancialGraph(),
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Time boxing pie chart"),
                  children: [
                    _buildPieChart(),
                    Card(
                      color: Color(0xffF6F4E6),
                      margin: EdgeInsets.only(
                          left: 15, right: 15, top: 15, bottom: 10),
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            for (int i = 0; i < 6; i++)
                              Indicator(
                                color: activityColors[i],
                                text: activityList[i],
                                isSquare: false,
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
      backgroundColor: Color(0xff52575D),
    );
  }

  Widget listOfEachJar(jarName, percentage) {
    return ListTile(
      title: Text(jarName),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: percentage,
                      ),
                      onChanged: (input) {},
                    ),
                  ),
                ],
              ),
            ),
            Container(margin: EdgeInsets.only(right: 10), child: Text("%")),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    var _sumTime = 0.0;
    for (int i = 0; i < 6; i++) {
      _sumTime += _amountTime[i];
      print(_sumTime);
    }
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 14;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: activityColors[i],
        value: _amountTime[i],
        title: ((_amountTime[i] / _sumTime) * 100).toStringAsFixed(0) + "%",
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Color(0xff52575D)),
      );
    });
  }
}
