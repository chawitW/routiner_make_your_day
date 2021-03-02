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
                  children: [
                    Text(
                        "Basically, in the 6 jar money management system, you split your money up into six different accounts.  You have a certain percentage of your money to put into each account.  You can use bank accounts or actual jars.  Think of it as a self-induced tax system."),
                    Text(
                        "Necessities Accounts (NEC – 50%) This account is to manage your everyday expenses.  This includes your rent, debt, food, clothes, gas etc."),
                    Text(
                        "This was a gamechanger because before, I only had one jar.  All my necessities were coming out of my one bank account; whenever I was travelling around the world, I depleted that one bank account completely.  The Idea that I need to give 50% of my income away was super radical to me, but I made the decision to do everything this course was teaching me."),
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Priority matrix"),
                  children: [
                    Text(
                        "An action priority matrix is a diagram that helps people determine which tasks to focus on, and in which order. You create this matrix using two components. First, draw a graph that measures effort along the x-axis and impact along the y-axis. Next, add four boxes to the graph, two stacked on top of the others. With the finished diagram, you can plot all of your initiatives to see if they are high impact and low effort, high impact and high effort, low impact and low effort, or high impact and low effort.")
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Time boxing"),
                  children: [
                    Text(
                        "Timeboxing is an approach to task and time management that sets rigid constraints on how long a given task or project can take to complete. Extensions are not permitted. The term comes from agile software development, in which a time box is defined period during which a task must be accomplished.")
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
