import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(PlannerPage());

// class PlannerRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: PlannerPage(),
//     );
//   }
// }

class PlannerPage extends StatefulWidget {
  @override
  _PlannerState createState() => _PlannerState();
}

class _PlannerState extends State<PlannerPage> with TickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  TimeOfDay _time;
  CalendarController _controller;
  TabController dateController;
  bool addToTodo = false;
  bool isTimeStart = false;
  String input = "";

  int activity_index;
  String _timeStart, _timeEnd;

  var priority_index;
  String groupTag = "";
  TabController priorityController;
  String priority;
  List listMatrix = [
    "Urgent and important",
    "Not urgent and important",
    "Urgent and not important",
    "Not urgent and not important"
  ];
  List listColour = [
    Color(0xffFA7F72),
    Color(0xff7FDBDA),
    Color(0xff8675A9),
    Color(0xffADE498),
    Color(0xffF6F4E6),
  ];
  List<Color> activityColors = [
    Color(0xff7FDBDA),
    Color(0xffFFD5CD),
    Color(0xff8675A9),
    Color(0xffADE498),
    Color(0xffFA7F72),
    Color(0xffF6F4E6),
  ];
  String activity = "";
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
        .collection(user.email)
        .doc(user.email)
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

  _pickTime(isTimeStart) async {
    TimeOfDay time = await showTimePicker(
        initialTime: _time,
        context: context,
        builder: (BuildContext context, Widget child) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Theme(
                data: ThemeData(),
                child: child,
              );
            },
          );
        });
    if (time != null)
      setState(() {
        _time = time;
        isTimeStart
            ? _timeStart = _timeFormatter(_time)
            : _timeEnd = _timeFormatter(_time);
      });
  }

  double _timeCalculate(_startTime, _endTime) {
    int startTime, endTime;
    double diffTime;
    var arrStart = _startTime.split(":");
    var arrEnd = _endTime.split(":");

    startTime = int.parse(arrStart[0]) * 60 + int.parse(arrStart[1]);
    endTime = int.parse(arrEnd[0]) * 60 + int.parse(arrEnd[1]);
    diffTime = endTime - startTime >= 60 ? (endTime - startTime) / 60 : 1;
    return diffTime;
  }

  String _timeFormatter(_time) {
    return int.parse(_time.hour.toString()) < 10
        ? int.parse(_time.minute.toString()) < 10
            ? "0" + _time.hour.toString() + ":" + "0" + _time.minute.toString()
            : "0" + _time.hour.toString() + ":" + _time.minute.toString()
        : int.parse(_time.minute.toString()) < 10
            ? _time.hour.toString() + ":" + "0" + _time.minute.toString()
            : _time.hour.toString() + ":" + _time.minute.toString();
  }

  createTodos() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(user.email)
        .doc(user.email)
        .collection("TodoList")
        .doc(groupTag);

    Map<String, String> todos = {
      "todoTitle": input,
      "todoPriority": priority,
      "todoPriority_index": priority_index.toString(),
      "todoGroupTag": documentReference.id,
    };

    documentReference.set({
      "groupTag": groupTag,
    });

    documentReference
        .collection("groupList")
        .doc(input)
        .set(todos)
        .whenComplete(() {
      print("$input created");
    });
  }

  @override
  void initState() {
    activity = activityList.first;
    priority = listMatrix.first;

    super.initState();
    _time = TimeOfDay.now();
    dateController = TabController(vsync: this, length: 7, initialIndex: 0);
    _controller = CalendarController();
  }

  @override
  void dispose() {
    _controller.dispose();
    // ignore: unnecessary_statements
    priorityController.dispose();
    // dateController.dispose;
    super.dispose();
  }

  _showEditDialog(_actNum, _start, _end, _details) {
    activity = activityList[int.parse(_actNum) - 1];
    input = _details;
    _timeStart = _start;
    _timeEnd = _end;
    priorityController = TabController(vsync: this, length: 4, initialIndex: 0);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Color(0xffF6F4E6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text(input),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                          child: DropdownButton<String>(
                              isExpanded: true,
                              value: activity,
                              isDense: true,
                              hint: Text("HINT"),
                              onChanged: (newValue) {
                                setState(() {
                                  activity = newValue;
                                });
                                // print(activity);
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
                    Container(
                      // margin: EdgeInsets.only(top: 10),
                      decoration: ShapeDecoration(
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text(_timeStart, style: TextStyle(fontSize: 16)),
                        onTap: () {
                          isTimeStart = true;
                          _pickTime(isTimeStart).then((value) {
                            if (value == null) setState(() {});
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: ShapeDecoration(
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                      child: ListTile(
                        dense: true,
                        title: Text(_timeEnd, style: TextStyle(fontSize: 16)),
                        onTap: () {
                          isTimeStart = false;
                          _pickTime(isTimeStart).then((value) {
                            if (value == null) setState(() {});
                          });
                        },
                      ),
                    ),
                    ListTile(
                      // dense: true,

                      title: Text("Also add this"),
                      subtitle: Text("into To do list"),
                      trailing: Switch(
                        value: addToTodo,
                        onChanged: (state) {
                          setState(() {
                            addToTodo = !addToTodo;
                          });
                        },
                      ),
                    ),
                    if (addToTodo)
                      Column(
                        children: [
                          //additional required To do form. //priority and group
                          Container(
                            decoration: ShapeDecoration(
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)),
                            ),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Container(
                              margin: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Text(
                                    priority,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  TabBar(
                                    unselectedLabelColor: Color(0xFF41444B),
                                    indicatorColor: Color(0xffFDDB3A),
                                    controller: priorityController,
                                    tabs: <Tab>[
                                      for (int i = 0; i < 4; i++)
                                        Tab(
                                            icon: Icon(
                                          Icons.circle,
                                          color: listColour[i],
                                        )),
                                    ],
                                    onTap: (index) {
                                      priority = listMatrix[index];
                                      priority_index = index + 1;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              hintText: 'Enter a group name.',
                              // helperText:
                              //     'Keep it short, this is just a demo.',
                              labelText: 'Group',
                            ),
                            onChanged: (String value) {
                              groupTag = value;
                            },
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              for (int i = 0; i < activityList.length; i++) {
                                if (activity == activityList[i]) {
                                  activity_index = i + 1;
                                }
                              }

                              createPlanners();
                              if (addToTodo) createTodos();
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 40,
                                  decoration: ShapeDecoration(
                                    color: Color(0xffFDDB3A),
                                    shape: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                    "Save change",
                                    style: TextStyle(color: Colors.black87),
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
  }

  _showFormDialog() {
    priorityController = TabController(vsync: this, length: 4, initialIndex: 0);
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
                          child: DropdownButton<String>(
                              isExpanded: true,
                              value: activity,
                              isDense: true,
                              hint: Text("HINT"),
                              onChanged: (newValue) {
                                setState(() {
                                  activity = newValue;
                                });
                                // print(activity);
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
                    Container(
                      // margin: EdgeInsets.only(top: 10),
                      decoration: ShapeDecoration(
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                      child: ListTile(
                        dense: true,
                        title: _timeStart == null ?? _timeStart == ""
                            ? Text("Select start time.",
                                style: TextStyle(fontSize: 16))
                            : Text(_timeStart, style: TextStyle(fontSize: 16)),
                        onTap: () {
                          isTimeStart = true;
                          _pickTime(isTimeStart).then((value) {
                            if (value == null) setState(() {});
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: ShapeDecoration(
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal)),
                      ),
                      child: ListTile(
                        dense: true,
                        title: _timeEnd == null ?? _timeEnd == ""
                            ? Text("Select end time.",
                                style: TextStyle(fontSize: 16))
                            : Text(_timeEnd, style: TextStyle(fontSize: 16)),
                        onTap: () {
                          isTimeStart = false;
                          _pickTime(isTimeStart).then((value) {
                            if (value == null) setState(() {});
                          });
                        },
                      ),
                    ),
                    ListTile(
                      // dense: true,

                      title: Text("Also add this"),
                      subtitle: Text("into To do list"),
                      trailing: Switch(
                        value: addToTodo,
                        onChanged: (state) {
                          setState(() {
                            addToTodo = !addToTodo;
                          });
                        },
                      ),
                    ),
                    if (addToTodo)
                      Column(
                        children: [
                          //additional required To do form. //priority and group
                          Container(
                            decoration: ShapeDecoration(
                              shape: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)),
                            ),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Container(
                              margin: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Text(
                                    priority,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  TabBar(
                                    unselectedLabelColor: Color(0xFF41444B),
                                    indicatorColor: Color(0xffFDDB3A),
                                    controller: priorityController,
                                    tabs: <Tab>[
                                      for (int i = 0; i < 4; i++)
                                        Tab(
                                            icon: Icon(
                                          Icons.circle,
                                          color: listColour[i],
                                        )),
                                    ],
                                    onTap: (index) {
                                      priority = listMatrix[index];
                                      priority_index = index + 1;
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.teal)),
                              hintText: 'Enter a group name.',
                              // helperText:
                              //     'Keep it short, this is just a demo.',
                              labelText: 'Group',
                            ),
                            onChanged: (String value) {
                              groupTag = value;
                            },
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              for (int i = 0; i < activityList.length; i++) {
                                if (activity == activityList[i]) {
                                  activity_index = i + 1;
                                }
                              }

                              createPlanners();
                              if (addToTodo) createTodos();
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10),
                              // color: Colors.yellow,
                              child: Icon(
                                Icons.add_circle_rounded,
                                color: Color(0xffFDDB3A),
                                size: 50,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffFDDB3A),
        onPressed: () {
          // setState(() {
          _timeStart = null;
          _timeEnd = null;
          // });
          _showFormDialog();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xff52575D),
      body: SingleChildScrollView(
        // physics: NeverScrollableScrollPhysics(),
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
                      .collection(user.email)
                      .doc(user.email)
                      .collection("Planner")
                      .doc(_controller.selectedDay.toString())
                      .collection("plannerList")
                      .orderBy("plannerTimeStart")
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (snapshots.data == null) {
                      return CircularProgressIndicator();
                    } else {
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.only(top: 4),
                          shrinkWrap: true,
                          itemCount: snapshots.data.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot =
                                snapshots.data.docs[index];
                            double _diffTime = _timeCalculate(
                                documentSnapshot["plannerTimeStart"],
                                documentSnapshot["plannerTimeEnd"]);
                            return Card(
                                color: activityColors[int.parse(
                                        documentSnapshot[
                                            "plannerActivityNumber"]) -
                                    1],
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, top: 4),
                                elevation: 4,
                                child: Center(
                                  heightFactor: 0.6 * _diffTime,
                                  child: ListTile(
                                      onTap: () {
                                        _showEditDialog(
                                            documentSnapshot[
                                                "plannerActivityNumber"],
                                            documentSnapshot[
                                                "plannerTimeStart"],
                                            documentSnapshot["plannerTimeEnd"],
                                            documentSnapshot["plannerDetails"]);
                                      },
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(documentSnapshot[
                                              "plannerTimeStart"]),
                                          Text(documentSnapshot[
                                              "plannerDetails"]),
                                          Text(documentSnapshot[
                                              "plannerTimeEnd"]),
                                        ],
                                      )),
                                ));
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
