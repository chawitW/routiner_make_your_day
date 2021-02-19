import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

class _PlannerState extends State<PlannerPage> with TickerProviderStateMixin {
  CalendarController _controller;
  TabController dateController;
  String input = "";
  String activity = "";
  int activity_index;
  String _timeStart, _timeEnd;
  List activityList = [
    "Core responsibility",
    "Personal growth",
    "Managing people",
    "Free time",
    "Crisis",
    "Admin",
  ];

  createPlanners() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Planner")
        .doc(_controller.selectedDay.toString());

    documentReference.set({
      "selectedDate": _controller.selectedDay.toString(),
    });

    Map<String, String> planners = {
      "plannerDetails": input,
      "plannerActivityNumber": activity_index.toString(),
      "plannerTimeStart": _timeStart,
      "plannerTimeEnd": _timeEnd,
    };

    documentReference.collection("plannerList").doc(input).set(planners);
  }

  @override
  void initState() {
    activity = activityList.first;

    super.initState();
    dateController = TabController(vsync: this, length: 7, initialIndex: 0);
    _controller = CalendarController();
  }

  @override
  void dispose() {
    _controller.dispose();
    // ignore: unnecessary_statements
    dateController.dispose;
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _controller = this._controller;
    });
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
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (String value) {
                          input = value;
                        },
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                            isExpanded: true,
                            value: activity,
                            isDense: true,
                            onChanged: (newValue) {
                              setState(() {
                                activity = newValue;
                              });
                            },
                            items: activityList.map((valueItem) {
                              return DropdownMenuItem<String>(
                                value: valueItem,
                                child: Text(valueItem),
                              );
                            }).toList()),
                      ),
                      TextField(
                        onChanged: (String value) {
                          _timeStart = value;
                        },
                      ),
                      TextField(
                        onChanged: (String value) {
                          _timeEnd = value;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                              onPressed: () {
                                if (activity == activityList[0]) {
                                  activity_index = 1;
                                } else if (activity == activityList[1]) {
                                  activity_index = 2;
                                } else if (activity == activityList[2]) {
                                  activity_index = 3;
                                } else if (activity == activityList[3]) {
                                  activity_index = 4;
                                } else if (activity == activityList[4]) {
                                  activity_index = 5;
                                } else if (activity == activityList[5]) {
                                  activity_index = 6;
                                } else {
                                  activity_index = 0;
                                }
                                createPlanners();
                                Navigator.of(context).pop();
                                setState(() {});
                              },
                              child: Container(
                                // color: Colors.yellow,
                                child: Icon(
                                  Icons.add_circle_rounded,
                                  color: Color(0xffFDDB3A),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
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
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              color: Color(0xffF6F4E6),
              child: TableCalendar(
                onDaySelected: (context, date, events) {
                  setState(() {});
                },
                weekendDays: [6, 7],
                initialCalendarFormat: CalendarFormat.week,
                calendarStyle: CalendarStyle(
                    todayColor: Colors.white,
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
                  selectedDayBuilder: (context, date, events) {
                    return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xffFDDB3A), // current selected
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                              color: Color(0xffF6F4E6)), //selected date
                        ));
                  },
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
                // onDaySelected: (date,events,events){},
                calendarController: _controller,
              ),
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Planner")
                    .doc(_controller.selectedDay.toString())
                    .collection("plannerList")
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.data == null) {
                    return CircularProgressIndicator();
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshots.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot documentSnapshot =
                              snapshots.data.documents[index];
                          return Card(
                              color: Color(0xffF6F4E6),
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 4),
                              elevation: 4,
                              child: ListTile(
                                  title: Text(
                                      documentSnapshot["plannerDetails"])));
                        });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
