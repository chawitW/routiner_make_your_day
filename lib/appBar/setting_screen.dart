import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(home: SettingPage()));
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final user = FirebaseAuth.instance.currentUser;
  List<String> jarName = [
    "Need and dairy jar",
    "Self-learning jar",
    "Long-term saving jar",
    "Investment jar",
    "Self gift jar",
    "Donation jar"
  ];
  List<String> percentage = [
    "55",
    "10",
    "10",
    "10",
    "10",
    "5",
  ];
  List<String> updatePercentage = [
    "55",
    "10",
    "10",
    "10",
    "10",
    "5",
  ];

  _initPercentage() {
    for (int i = 0; i < jarName.length; i++) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(user.email)
          .doc(user.email)
          .collection("Percent")
          .doc(jarName[i]);
      Map<String, String> amount = {
        "percent": percentage[i],
        "jarNumber": i.toString(),
      };
      documentReference.set(amount);
    }
  }

  _updatePercent() {
    for (int i = 0; i < jarName.length; i++) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(user.email)
          .doc(user.email)
          .collection("Percent")
          .doc(jarName[i]);
      Map<String, String> amount = {
        "percent": updatePercentage[i],
        "jarNumber": i.toString(),
      };
      documentReference.set(amount);
    }
  }

  _showConfirmDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Confirm"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: Text("Dismiss"),
                        onPressed: () {
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Text(
                          "Save",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        onPressed: () {
                          _updatePercent();
                          Navigator.of(context).pop();
                          setState(() {
                            percentage = updatePercentage;
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
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
          child: Card(
            color: Color(0xffF6F4E6),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text("Partition jars"),
              children: [
                // FlatButton(
                //     onPressed: () {
                //       _initPercentage();
                //     },
                //     child: Text("Create and initial percentage of each jar")),

                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(user.email)
                        .doc(user.email)
                        .collection("Percent")
                        .orderBy("jarNumber")
                        .snapshots(),
                    builder: (context, snapshots) {
                      if (snapshots.data == null) {
                        return CircularProgressIndicator();
                      } else {
                        for (int i = 0; i < 6; i++) {
                          DocumentSnapshot documentSnapshot =
                              snapshots.data.docs[i];
                          percentage[i] = documentSnapshot["percent"];
                        }
                      }
                      return Container(
                        width: 0,
                        height: 0,
                      );
                    }),
                listOfEachJar(jarName[0], percentage[0], 0),
                listOfEachJar(jarName[1], percentage[1], 1),
                listOfEachJar(jarName[2], percentage[2], 2),
                listOfEachJar(jarName[3], percentage[3], 3),
                listOfEachJar(jarName[4], percentage[4], 4),
                listOfEachJar(jarName[5], percentage[5], 5),
                ListTile(
                  trailing: IconButton(
                    icon: Text(
                      "Save",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    onPressed: () {
                      _showConfirmDialog();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xff52575D),
    );
  }

  Widget listOfEachJar(jarName, percentage, i) {
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
                      onChanged: (input) {
                        updatePercentage[i] = input;
                      },
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
