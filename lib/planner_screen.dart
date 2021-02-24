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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffFDDB3A),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    backgroundColor: Color(0xffF6F4E6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    title: Text("Add a plan"),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal)),
                                hintText: 'Activity details',
                                labelText: 'Activity details',
                              ),
                              onChanged: (String value) {
                                input = value;
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            height: 50,
                            decoration: ShapeDecoration(
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                    isExpanded: true,
                                    value: activity,
                                    isDense: true,
                                    onChanged: (newValue) {
                                      setState(() {
                                        activity = newValue;
                                      });
                                      print(activity);
                                    },
                                    items: activityList.map((valueItem) {
                                      return DropdownMenuItem<String>(
                                        value: valueItem,
                                        child: Text(valueItem),
                                      );
                                    }).toList()),
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)),
                              hintText: 'Start Time',
                              labelText: 'Start Time',
                            ),
                            onChanged: (String value) {
                              _timeStart = value;
                            },
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal)),
                                hintText: 'End Time',
                                labelText: 'End Time',
                              ),
                              onChanged: (String value) {
                                _timeEnd = value;
                              },
                            ),
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
                    ),
                  );
                });
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xff52575D),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.only(top: 10, left: 10, right: 10),
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
                          padding: EdgeInsets.only(top: 4),
                          shrinkWrap: true,
                          itemCount: snapshots.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                snapshots.data.documents[index];
                            return Card(
                                color: activityColors[int.parse(
                                        documentSnapshot[
                                            "plannerActivityNumber"]) -
                                    1],
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 4),
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
      ),
    );
  }
}
