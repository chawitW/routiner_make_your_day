import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: TheoryPage()));
}

class TheoryPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<TheoryPage> {
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
                  title: Text("6 Jars"),
                  children: [Text("This is completed task")],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Priority matrix"),
                  children: [Text("This is a graph")],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Time boxing"),
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
