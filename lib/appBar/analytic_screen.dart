import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(home: AnalyticsPage()));
}

class AnalyticsPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<AnalyticsPage> {
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
                                itemCount: snapshots.data.documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot documentSnapshot =
                                      snapshots.data.documents[index];
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
                                                      .data.documents.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                         DocumentSnapshot
                                                  documentSnapshot = snapshots
                                                      .data.documents[index];
                                                    return Text(documentSnapshot[
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
                  children: [Text("This is a graph")],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Time boxing pie chart"),
                  children: [Text("This is a chart")],
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
