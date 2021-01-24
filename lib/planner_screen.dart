import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() => runApp(PlannerRoute());

class PlannerRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PlannerPage(),
    );
  }
}

class PlannerPage extends StatefulWidget {
  @override
  _PlannerState createState() => _PlannerState();
}

class _PlannerState extends State<PlannerPage> {
  CalendarController _controller;
  String input = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffFDDB3A),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add a plan"),
                  content: TextField(
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Add"),
                    )
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xff52575D),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(8.0),
              color: Color(0xffF6F4E6),
              child: TableCalendar(
                weekendDays: [6, 7],
                initialCalendarFormat: CalendarFormat.week,
                calendarStyle: CalendarStyle(
                    todayColor: Colors.white,
                    // selectedColor: Theme.of(context).primaryColor,
                    selectedColor: Colors.orange,
                    todayStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.pink)),
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonDecoration: BoxDecoration(
                    color: Color(0xffFDDB3A), //box of type
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  formatButtonTextStyle:
                      TextStyle(color: Color(0xffF6F4E6)), //type of table
                  formatButtonShowsNext: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.sunday,
                builders: CalendarBuilders(
                  selectedDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Color(0xffFDDB3A), // current selected
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        date.day.toString(),
                        style:
                            TextStyle(color: Color(0xffF6F4E6)), //selected date
                      )),
                  todayDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.all(4.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.red, //today box
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white), //today char
                      )),
                ),
                calendarController: _controller,
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              // elevation: 4,
              margin:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              color: Color(0xff7FDBDA),
              child: ListTile(
                title: Text("Core responsibility"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("Hello");
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              margin:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              color: Color(0xffADE498),
              child: ListTile(
                title: Text("Free time"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("Hello");
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              margin:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              color: Color(0xffffd5cd),
              child: ListTile(
                title: Text("Personal growth"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("Hello");
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              margin:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              color: Color(0xff8675A9),
              child: ListTile(
                title: Text("Managing people"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("Hello");
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              margin:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              color: Color(0xffFA7F72),
              child: ListTile(
                title: Text("Crisis"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("Hello");
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              margin:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              color: Color(0xffF6F4E6),
              child: ListTile(
                title: Text("Admin"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("Hello");
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              margin:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              color: Color(0xffF6F4E6),
              child: ListTile(
                title: Text("Admin"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("Hello");
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              margin:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              color: Color(0xffF6F4E6),
              child: ListTile(
                title: Text("Admin"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("Hello");
                  },
                ),
              ),
            ),
            Card(
              shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              margin:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              color: Color(0xffF6F4E6),
              child: ListTile(
                title: Text("Admin"),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    print("Hello");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
