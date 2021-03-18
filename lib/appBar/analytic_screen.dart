import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(home: AnalyticsPage()));
}

class AnalyticsPage extends StatefulWidget {
  
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<AnalyticsPage> {
   final user = FirebaseAuth.instance.currentUser;
  List<String> jarName = [
    "Need and dairy jar",
    "Self-learning jar",
    "Long-term saving jar",
    "Investment jar",
    "Self gift jar",
    "Donation jar"
  ];
  List listMatrix = [
    "Urgent and important",
    "Not urgent and important",
    "Urgent and not important",
    "Not urgent and not important"
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
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                      .collection(user.email).doc(user.email)
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
                                    margin: EdgeInsets.only(
                                        left: 10, right: 10, top: 4),
                                    child: ExpansionTile(
                                      initiallyExpanded: true,
                                      title: Text(documentSnapshot["groupTag"],
                                          style: TextStyle(fontSize: 15)),
                                      children: [
                                        StreamBuilder(
                                          stream: FirebaseFirestore.instance
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
                                                  itemCount: snapshots
                                                      .data.docs.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    DocumentSnapshot
                                                        documentSnapshot =
                                                        snapshots.data
                                                            .docs[index];
                                                    return Text(
                                                        documentSnapshot[
                                                            "todoTitle"]);
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
                    ),
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Financial graph"),
                  children: [
                    BarChart(BarChartData(barGroups: [
                      for (int j = 0; j < 7; j++)
                        BarChartGroupData(x: j + 1, barRods: [
                          BarChartRodData(
                              y: (j + 1) * 5.0,
                              colors: [
                                Colors.redAccent
                                // Colors.greenAccent
                              ],
                              width: 3),
                          BarChartRodData(
                              y: (j + 2) * 4.0,
                              colors: [
                                // Colors.redAccent
                                Colors.greenAccent
                              ],
                              width: 3)
                        ])
                    ]))
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Time boxing pie chart"),
                  children: [
                    Text("PieChart is below"),
                    Center(
                      heightFactor: 10,
                      child: ListTile(
                        title: PieChart(PieChartData(
                            startDegreeOffset: 180,
                            sectionsSpace: 1,
                            centerSpaceRadius: 0,
                            // centerSpaceColor: Colors.white,
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sections: [
                              PieChartSectionData(
                                title: '30%',
                                value: 30,
                                radius: 80,
                                color: Colors.redAccent.withOpacity(0.7),
                                titleStyle: TextStyle(color: Colors.black12),
                                titlePositionPercentageOffset: 0.55,
                              ),
                              PieChartSectionData(
                                  title: '20%',
                                  radius: 80,
                                  value: 20,
                                  color: Colors.blueAccent),
                              PieChartSectionData(
                                  title: '10%',
                                  radius: 80,
                                  value: 10,
                                  color: Colors.greenAccent),
                              PieChartSectionData(
                                  title: '40%',
                                  radius: 80,
                                  value: 40,
                                  color: Colors.yellowAccent),
                            ])),
                      ),
                    )
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
}
