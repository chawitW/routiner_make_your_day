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
  bool isShowingMainData = true;
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
  List listColour = [
    Color(0xffFA7F72),
    Color(0xff7FDBDA),
    Color(0xff8675A9),
    Color(0xffADE498),
    Color(0xffF6F4E6),
  ];
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
                    margin: EdgeInsets.only(left: 10, right: 10, top: 2),
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
                                    return Card(
                                        color: listColour[int.parse(
                                                documentSnapshot[
                                                    "todoPriority_index"]) -
                                            1],
                                        child: Text(
                                            documentSnapshot["todoTitle"]));
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
  List<Color> jarColors = [
    Color(0xff7FDBDA),
    Color(0xffFFD5CD),
    Color(0xffFA7F72),
    Color(0xffF6F4E6),
    Color(0xffADE498),
    Color(0xff8675A9),
    Color(0xffFDDB3A),
  ];

  List<bool> jarSelected = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ];

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

  List<double> _arrIncome = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
  ];
  List<double> _arrOutgo = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0
  ];

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
                                for (int j = 0;
                                    j < snapshots.data.docs.length;
                                    j++) {
                                  if (snapshots.data.docs[j]["ledgerType"] ==
                                      "Income") {
                                    _amountIncome += double.parse(
                                        snapshots.data.docs[j]["ledgerAmount"]);
                                  } else {
                                    _amountOutgo += double.parse(
                                        snapshots.data.docs[j]["ledgerAmount"]);
                                  }
                                }
                                _arrIncome[i] = _amountIncome;
                                _arrOutgo[i] = _amountOutgo;

                                return Container(
                                  width: 0,
                                  height: 0,
                                );
                              }
                            }),
                      BarChart(BarChartData(barGroups: [
                        for (int k = 0; k < snapshots.data.docs.length; k++)
                          BarChartGroupData(x: 15 + k, barRods: [
                            BarChartRodData(
                                y: _arrIncome[k],
                                colors: [Colors.greenAccent],
                                width: 3),
                            BarChartRodData(
                                y: _arrOutgo[k],
                                colors: [Colors.redAccent],
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
                // if(isLineChecked)
                Tab(
                    icon: Icon(jarIcon[i],
                        color: _currentJar == i
                            ? Color(0xffFDDB3A)
                            : Color(0xFF41444B))),
            ],
            onTap: (index) {
              // _amountIncome = (index + 1) * 2.0;
              setState(() {
                _currentJar = index;
              });
            },
          ),
        ],
      ),
    );
  }

  // _buildGraph() {
  //   return StatefulBuilder(builder: (context, setState) {

  //   });
  // }

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

  // FlSpot

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
          // print(snapshots.data.docs.length);
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
                  height: 105,
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
          return Container(
            width: 0,
            height: 0,
          );
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
    super.initState();
    isShowingMainData = true;
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

  LineChartData sampleData2() {
    return LineChartData(
      lineTouchData: LineTouchData(
        enabled: false,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            // switch (value.toInt()) {
            //   case 2:
            //     return 'SEPT';
            //   case 7:
            //     return 'OCT';
            //   case 12:
            //     return 'DEC';
            // }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2000:
                return '2k';
              case 4000:
                return '4k';
              case 6000:
                return '6k';
              case 8000:
                return '8k';
              case 10000:
                return '10k';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
          show: true,
          border: const Border(
            bottom: BorderSide(
              color: Color(0xff4e4965),
              width: 4,
            ),
            left: BorderSide(
              color: Colors.transparent,
            ),
            right: BorderSide(
              color: Colors.transparent,
            ),
            top: BorderSide(
              color: Colors.transparent,
            ),
          )),
      minX: 0,
      maxX: 14,
      maxY: 10100,
      minY: 0,
      lineBarsData: linesBarData2(),
    );
  }

  List<LineChartBarData> linesBarData2() {
    return [
      LineChartBarData(
        spots: [
          FlSpot(1, 6000),
          FlSpot(3, 5400),
          FlSpot(5, 4400),
          FlSpot(7, 9200),
          FlSpot(10, 8600),
          FlSpot(12, 8200),
          FlSpot(13, 7100),
        ],
        isCurved: true,
        curveSmoothness: 0,
        colors: [
          jarColors[6],
        ],
        barWidth: 4,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: false,
        ),
      ),
    ];
  }

  LineChartData sampleData1() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
        touchCallback: (LineTouchResponse touchResponse) {},
        handleBuiltInTouches: true,
      ),
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff72719b),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          margin: 10,
          getTitles: (value) {
            // switch (value.toInt()) {
            //   case 2:
            //     return 'SEPT';
            //   case 7:
            //     return 'OCT';
            //   case 12:
            //     return 'DEC';
            // }
            return '';
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Color(0xff75729e),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 2000:
                return '2k';
              case 4000:
                return '4k';
              case 6000:
                return '6k';
              case 1000:
                return '1k';
              case 5000:
                return '5k';
              case 3000:
                return '3k';
            }
            return '';
          },
          margin: 8,
          reservedSize: 30,
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(
            color: Color(0xff4e4965),
            width: 4,
          ),
          left: BorderSide(
            color: Colors.transparent,
          ),
          right: BorderSide(
            color: Colors.transparent,
          ),
          top: BorderSide(
            color: Colors.transparent,
          ),
        ),
      ),
      minX: 0,
      maxX: 12,
      maxY: jarSelected[0]? 6000:1000,
      minY: 0,
      lineBarsData: linesBarData1(),
    );
  }

  List jarLines = [
    [
      FlSpot(0, 3500),
      FlSpot(2, 3400),
      FlSpot(4, 3000),
      FlSpot(6, 5500),
      FlSpot(8, 4800),
      FlSpot(10, 4000),
    ],
    [
      FlSpot(0, 600),
      FlSpot(2, 400),
      FlSpot(4, 400),
      FlSpot(6, 600),
      FlSpot(8, 600),
      FlSpot(10, 300),
    ],
    [
      FlSpot(0, 600),
      FlSpot(2, 600),
      FlSpot(4, 600),
      FlSpot(6, 800),
      FlSpot(8, 800),
      FlSpot(10, 800),
    ],
    [
      FlSpot(0, 600),
      FlSpot(2, 100),
      FlSpot(4, 100),
      FlSpot(6, 300),
      FlSpot(8, 300),
      FlSpot(10, 300),
    ],
    [
      FlSpot(0, 600),
      FlSpot(2, 100),
      FlSpot(4, 100),
      FlSpot(6, 300),
      FlSpot(8, 200),
      FlSpot(10, 0),
    ],
    [
      FlSpot(0, 300),
      FlSpot(2, 300),
      FlSpot(4, 300),
      FlSpot(6, 500),
      FlSpot(8, 200),
      FlSpot(10, 0),
    ]
  ];


  List<LineChartBarData> linesBarData1() {
    final List<LineChartBarData> lineChartBarData = [
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ];
    for (int i = 0; i < 6; i++) {
      if (jarSelected[i]) {
        lineChartBarData[i] = LineChartBarData(
          spots: jarLines[i],
          isCurved: true,
          colors: [jarColors[i]],
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        );
      } else {
        lineChartBarData[i] = LineChartBarData(
          spots: [
            FlSpot(0, 0),
            FlSpot(0, 0),
          ],
          isCurved: true,
          colors: [Colors.black87],
          barWidth: 6,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        );
      }
    }

    return [
      lineChartBarData[0],
      lineChartBarData[1],
      lineChartBarData[2],
      lineChartBarData[3],
      lineChartBarData[4],
      lineChartBarData[5],
    ];
  }

  List<LineChartBarData> linesBarData3() {
    final List<LineChartBarData> lineChartBarData = [
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ];

    lineChartBarData[6] = LineChartBarData(
      spots: [
        FlSpot((6 / 2 + 1) * 10.0, 2000),
      ],
      isCurved: true,
      colors: [jarColors[6]],
      barWidth: 6,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [
      lineChartBarData[6],
    ];
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
                  onExpansionChanged: (isExpanded) {
                    setState(() {});
                  },
                  // initiallyExpanded: true,
                  title: Text("Financial graph"),
                  children: [
                    // _buildFinancialGraph(),
                    AspectRatio(
                      aspectRatio: 1.23,
                      child: Container(
                        margin: EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff2c274c),
                              Color(0xff46426c),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const SizedBox(
                                  height: 37,
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                const Text(
                                  'Summary financial',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 37,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16.0, left: 6.0),
                                    child: LineChart(
                                      isShowingMainData
                                          ? sampleData1()
                                          : sampleData2(),
                                      swapAnimationDuration:
                                          const Duration(milliseconds: 250),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                            IconButton(
                              icon: isShowingMainData
                                  ? Text(
                                      "All",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text("Each",
                                      style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                setState(() {
                                  print(isShowingMainData);
                                  isShowingMainData = !isShowingMainData;
                                });
                              },
                            ),
                            if (isShowingMainData)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                    child: Row(
                                  children: [
                                    for (int i = 0; i < 6; i++)
                                      Expanded(
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  jarSelected[i] =
                                                      !jarSelected[i];
                                                });
                                              },
                                              icon: Icon(
                                                jarIcon[i],
                                                color: jarSelected[i]
                                                    ? jarColors[i]
                                                    : Colors.grey,
                                              )))
                                  ],
                                )),
                              ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                    // _buildGraph(),
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
      // print(_sumTime);
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
