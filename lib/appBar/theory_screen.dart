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
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                              "     Basically, in the 6 jar money management system, you split your money up into six different accounts.  You have a certain percentage of your money to put into each account.  You can use bank accounts or actual jars.  Think of it as a self-induced tax system. Necessities Accounts (NEC – 50%) This account is to manage your everyday expenses.  This includes your rent, debt, food, clothes, gas etc. This was a gamechanger because before, I only had one jar.  All my necessities were coming out of my one bank account; whenever I was travelling around the world, I depleted that one bank account completely.  The Idea that I need to give 50% of my income away was super radical to me, but I made the decision to do everything this course was teaching me."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Priority matrix"),
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(
                          "     An action priority matrix is a diagram that helps people determine which tasks to focus on, and in which order. You create this matrix using two components. First, draw a graph that measures effort along the x-axis and impact along the y-axis. Next, add four boxes to the graph, two stacked on top of the others. With the finished diagram, you can plot all of your initiatives to see if they are high impact and low effort, high impact and high effort, low impact and low effort, or high impact and low effort."),
                    )
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Time boxing"),
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(
                          "     Timeboxing is an approach to task and time management that sets rigid constraints on how long a given task or project can take to complete. Extensions are not permitted. The term comes from agile software development, in which a time box is defined period during which a task must be accomplished."),
                    )
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("50/30/20 Rule"),
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                              "     Most people save too little, and unknowingly spend too much. The 50/30/20 rule of thumb is a way to become aware of your financial habits and limit overspending and under-saving. By spending less on the things that don’t matter that much to you, you can save more for the things that do. 50% needs, 30% wants, 20% goals"),
                          Text(
                              "      80/20 Rule: With this method, you immediately set aside 20% of your income into savings. The other 80% is yours to spend on whatever you want, no tracking involved. "),
                          Text(
                              "      70/20/10 Rule: This rule is similar to the 50/30/20 rule of thumb, but you instead parse out your budget as follows: 70% to living expenses, 20% to debt payments, and 10% to savings.")
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("The Inventory System"),
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                              "     As we undertake activities, we learn from them and are in a position to do them better subsequently. The inventory system is a results-oriented approach that is based on the premise that one learns the most by reviewing how they handled the day and applying these lessons to the next day’s behavior (Forsyth 2010)."),
                          Text(
                              "      This theory argues that a retrospective analysis of activities done represents a more behavior changing approach to dealing with situations in life. Mancini (2003, p.162) declares that “behavior modification is a significant time management strategy”. As such, while the inventory system is not in itself a time-saving measure, it results in the establishment of time-saving behavioral changes in a person.")
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Card(
                color: Color(0xffF6F4E6),
                child: ExpansionTile(
                  // initiallyExpanded: true,
                  title: Text("Pomodoro Technique"),
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "     The Pomodoro Technique is probably one of the simplest productivity methods to implement. All you’ll need is a timer. Beyond that, there are no special apps, books, or tools required (though plenty of them out there if you’d like to go that route—more on that later). Cirillo’s book, The Pomodoro Technique, is a helpful read, but Cirillo himself doesn’t hide the core of the method behind a purchase. Here’s how to get started with Pomodoro, in five steps:"),
                          Text("1. Choose a task to be accomplished."),
                          Text(
                              "2. Set the Pomodoro to 25 minutes (the Pomodoro is the timer)"),
                          Text(
                              "3. Work on the task until the Pomodoro rings, then put a check on your sheet of paper"),
                          Text("4. Take a short break (5 minutes is OK)"),
                          Text("5. Every 4 Pomodoros take a longer break"),
                          Text(
                              "      That “longer break” is usually on the order of 15-30 minutes, whatever it takes to make you feel recharged and ready to start another 25-minute work session. Repeat that process a few times over the course of a workday, and you actually get a lot accomplished—and took plenty of breaks to grab a cup of coffee or refill your water bottle in the process.")
                        ],
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
