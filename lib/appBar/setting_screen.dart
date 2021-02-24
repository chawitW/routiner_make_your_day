import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SettingPage()));
}

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
                listOfEachJar(jarName[0], percentage[0]),
                listOfEachJar(jarName[1], percentage[1]),
                listOfEachJar(jarName[2], percentage[2]),
                listOfEachJar(jarName[3], percentage[3]),
                listOfEachJar(jarName[4], percentage[4]),
                listOfEachJar(jarName[5], percentage[5]),
                ListTile(
                  trailing: IconButton(
                    icon: Text(
                      "Save",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                    onPressed: () {
                      print("save");
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
