import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

void main() {
  runApp(MaterialApp(home: ToDoRoute()));
}

class ToDoRoute extends StatefulWidget {
  @override
  _ToDoRouteState createState() => _ToDoRouteState();
}

class _ToDoRouteState extends State<ToDoRoute> with TickerProviderStateMixin {
  // TabController dateController;
  bool addToPlanner = false;
  String input = "";

  String groupTag = "";
  var priority_index;
  final user = FirebaseAuth.instance.currentUser;
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
  String activity = "";
  List activityList = [
    "Core responsibility",
    "Personal growth",
    "Managing people",
    "Free time",
    "Crisis",
    "Admin",
  ];
  bool expand = false;
  String _timeStart, _timeEnd;
  bool isTimeStart = false;
  TimeOfDay _time;
  String dateForm;
  DateTime _date;
  int activity_index;

  @override
  void initState() {
    activity = activityList.first;
    priority = listMatrix.first;
    super.initState();
    _time = TimeOfDay.now();
  }

  @override
  void dispose() {
    priorityController.dispose();
    super.dispose();
  }

  updateTodos(oldIndex, newIndex) {
    print("do sth");

    setState(() {});
  }

  _completedTask(documentSnapshot) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(user.email)
        .doc(user.email)
        .collection("CompletedTodo")
        .doc(documentSnapshot["todoGroupTag"]);

    Map<String, String> todos = {
      "todoTitle": documentSnapshot["todoTitle"],
      "todoPriority": documentSnapshot["todoPriority"],
      "todoPriority_index": documentSnapshot["todoPriority_index"],
      "todoGroupTag": documentSnapshot["todoGroupTag"],
    };

    documentReference.set({
      "groupTag": documentSnapshot["todoGroupTag"],
    });

    documentReference
        .collection("groupList")
        .doc(documentSnapshot["todoTitle"])
        .set(todos);
  }

  _addToPlanner() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(user.email)
        .doc(user.email)
        .collection("Planner")
        .doc(dateForm);

    documentReference.set({
      "selectedDate": dateForm,
    });

    Map<String, String> planners = {
      "plannerDetails": input,
      "plannerActivityNumber": activity_index.toString(),
      "plannerTimeStart": _timeStart,
      "plannerTimeEnd": _timeEnd,
    };

    documentReference.collection("plannerList").doc(input).set(planners);
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

  deleteTodos(item, tag) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(user.email)
        .doc(user.email)
        .collection("TodoList")
        .doc(tag);

    documentReference
        .collection("groupList")
        .doc(item)
        .delete()
        .whenComplete(() {});
  }

  _pickTime(isTimeStart) async {
    TimeOfDay time = await showTimePicker(
        initialTime: TimeOfDay.now(),
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

  String _timeFormatter(_time) {
    return int.parse(_time.hour.toString()) < 10
        ? int.parse(_time.minute.toString()) < 10
            ? "0" + _time.hour.toString() + ":" + "0" + _time.minute.toString()
            : "0" + _time.hour.toString() + ":" + _time.minute.toString()
        : int.parse(_time.minute.toString()) < 10
            ? _time.hour.toString() + ":" + "0" + _time.minute.toString()
            : _time.hour.toString() + ":" + _time.minute.toString();
  }

  _showConfirmDialog(documentSnapshot) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Remove " + documentSnapshot["groupTag"] + " ?"),
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
                          "Remove",
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection(user.email)
                              .doc(user.email)
                              .collection("TodoList")
                              .doc(documentSnapshot["groupTag"])
                              .delete();
                          Navigator.of(context).pop();
                          setState(() {});
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

  _showFormDialog() {
    priority = listMatrix.first;
    addToPlanner = false;
    _timeStart = null;
    _timeEnd = null;
    priorityController = TabController(vsync: this, length: 4, initialIndex: 0);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Color(0xffF6F4E6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: Center(child: Text("Add to do list")),
                content: SingleChildScrollView(
                  child: Container(
                    // margin: EdgeInsets.all(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.teal)),
                              hintText: 'Enter a thing to do',
                              labelText: 'To do task',
                            ),
                            onChanged: (String value) {
                              input = value;
                            },
                          ),
                        ),
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
                                borderSide: new BorderSide(color: Colors.teal)),
                            hintText: 'Enter a group name.',
                            // helperText:
                            //     'Keep it short, this is just a demo.',
                            labelText: 'Group',
                          ),
                          onChanged: (String value) {
                            groupTag = value;
                          },
                        ),
                        ListTile(
                          // dense: true,

                          title: Text("Add this task"),
                          subtitle: Text("to Planner"),
                          trailing: Switch(
                            value: addToPlanner,
                            onChanged: (state) {
                              setState(() {
                                addToPlanner = !addToPlanner;
                              });
                            },
                          ),
                        ),
                        if (addToPlanner)
                          Column(
                            children: [
                              //additional required Planner form. //activity and time
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                height: 50,
                                decoration: ShapeDecoration(
                                  shape: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
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
                                decoration: ShapeDecoration(
                                  shape: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: _timeStart == null ?? _timeStart == ""
                                      ? Text(
                                          "Select start time.",
                                          style: TextStyle(fontSize: 16),
                                        )
                                      : Text(_timeStart,
                                          style: TextStyle(fontSize: 16)),
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
                                      borderSide:
                                          BorderSide(color: Colors.teal)),
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: _timeEnd == null ?? _timeEnd == ""
                                      ? Text("Select end time.",
                                          style: TextStyle(fontSize: 16))
                                      : Text(_timeEnd,
                                          style: TextStyle(fontSize: 16)),
                                  onTap: () {
                                    isTimeStart = false;
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
                                      borderSide:
                                          BorderSide(color: Colors.teal)),
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: _date == null
                                      ? Text(
                                          "Date: " +
                                              DateFormat.yMMMMd()
                                                  .format(DateTime.now()),
                                          style: TextStyle(fontSize: 16))
                                      : Text(
                                          "Date: " +
                                              DateFormat.yMMMd().format(_date),
                                          style: TextStyle(fontSize: 16)),
                                  onTap: () {
                                    _pickDate().then((value) {
                                      if (value == null) setState(() {});
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  if (addToPlanner) {
                                    for (int i = 0;
                                        i < activityList.length;
                                        i++) {
                                      if (activity == activityList[i]) {
                                        activity_index = i + 1;
                                      }
                                    }
                                    _addToPlanner();
                                  }
                                  createTodos();
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  // color: Colors.yellow,
                                  margin: EdgeInsets.only(top: 10),
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
                ),
              );
            },
          );
        });
  }

  _pickDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2222),
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
    if (date != null)
      setState(() {
        _date = date;
        String month = _date.month.toString();
        if (_date.month < 10) month = "0" + month;
        dateForm = _date.year.toString() +
            "-" +
            month +
            "-" +
            _date.day.toString() +
            " 12:00:00.000Z";
      });
  }

  _showEditDialog(_priority_index, _details, _grouptag) {
    priority = listMatrix[_priority_index];
    priority_index = _priority_index+1;
    priorityController =
        TabController(vsync: this, length: 4, initialIndex: _priority_index);
    addToPlanner = false;
    _timeStart = null;
    _timeEnd = null;
    groupTag = _grouptag;
    input = _details;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Color(0xffF6F4E6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                title: Center(child: Text(input)),
                content: SingleChildScrollView(
                  child: Container(
                    // margin: EdgeInsets.all(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(groupTag)
                        ),
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
                        
                        ListTile(
                          // dense: true,

                          title: Text("Add this task"),
                          subtitle: Text("to Planner"),
                          trailing: Switch(
                            value: addToPlanner,
                            onChanged: (state) {
                              setState(() {
                                addToPlanner = !addToPlanner;
                              });
                            },
                          ),
                        ),
                        if (addToPlanner)
                          Column(
                            children: [
                              //additional required Planner form. //activity and time
                              Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                height: 50,
                                decoration: ShapeDecoration(
                                  shape: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
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
                                decoration: ShapeDecoration(
                                  shape: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey)),
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: _timeStart == null ?? _timeStart == ""
                                      ? Text(
                                          "Select start time.",
                                          style: TextStyle(fontSize: 16),
                                        )
                                      : Text(_timeStart,
                                          style: TextStyle(fontSize: 16)),
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
                                      borderSide:
                                          BorderSide(color: Colors.teal)),
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: _timeEnd == null ?? _timeEnd == ""
                                      ? Text("Select end time.",
                                          style: TextStyle(fontSize: 16))
                                      : Text(_timeEnd,
                                          style: TextStyle(fontSize: 16)),
                                  onTap: () {
                                    isTimeStart = false;
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
                                      borderSide:
                                          BorderSide(color: Colors.teal)),
                                ),
                                child: ListTile(
                                  dense: true,
                                  title: _date == null
                                      ? Text(
                                          "Date: " +
                                              DateFormat.yMMMMd()
                                                  .format(DateTime.now()),
                                          style: TextStyle(fontSize: 16))
                                      : Text(
                                          "Date: " +
                                              DateFormat.yMMMd().format(_date),
                                          style: TextStyle(fontSize: 16)),
                                  onTap: () {
                                    _pickDate().then((value) {
                                      if (value == null) setState(() {});
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  if (addToPlanner) {
                                    for (int i = 0;
                                        i < activityList.length;
                                        i++) {
                                      if (activity == activityList[i]) {
                                        activity_index = i + 1;
                                      }
                                    }
                                    _addToPlanner();
                                  }

                                  createTodos();
                                  Navigator.of(context).pop();
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
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Padding(padding: const EdgeInsets.all(20),);
    return Scaffold(
        backgroundColor: Color(0xff52575D),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(360.0)),
              side: BorderSide(color: Color(0xffF6F4E6), width: 1.0)),
          backgroundColor: Color(0xffFDDB3A),
          onPressed: () {
            priority = listMatrix.first;
            _date = DateTime.now();
            _showFormDialog();
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: Container(
          margin: EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(user.email)
                  .doc(user.email)
                  .collection("TodoList")
                  // .orderBy("groupTag")
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.data == null) {
                  return CircularProgressIndicator();
                } else {
                  return ReorderableListView(
                      onReorder: (oldIndex, newIndex) {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        print("$oldIndex  $newIndex");

                        setState(() {
                          // Map<String, String> todos =
                          //     snapshots.data.document[oldIndex];

                          // snapshots.data.document[oldIndex].delete();
                          // snapshots.data.document[newIndex].set(todos);
                        });
                      },
                      children:
                          List.generate(snapshots.data.docs.length, (index) {
                        DocumentSnapshot documentSnapshot =
                            snapshots.data.docs[index];
                        return Container(
                          key: ValueKey(index),
                          child: Card(
                            color: Color(0xffF6F4E6),
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              title: Text(
                                documentSnapshot["groupTag"],
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 20),
                              ),
                              children: [
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection(user.email)
                                      .doc(user.email)
                                      .collection("TodoList")
                                      .doc(documentSnapshot["groupTag"])
                                      .collection("groupList")
                                      .orderBy("todoPriority_index")
                                      .snapshots(),
                                  builder: (context, snapshots) {
                                    if (snapshots.data == null) {
                                      return CircularProgressIndicator();
                                    } else {
                                      return Container(
                                        margin:
                                            EdgeInsets.only(bottom: 10, top: 5),
                                        child: ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshots.data.docs.length,
                                            itemBuilder: (context, index) {
                                              DocumentSnapshot
                                                  documentSnapshot =
                                                  snapshots.data.docs[index];
                                              return Container(
                                                child: Dismissible(
                                                  direction: DismissDirection
                                                      .startToEnd,
                                                  key: ValueKey(index),
                                                  onDismissed: (directoin) {
                                                    _completedTask(
                                                        documentSnapshot);
                                                  },
                                                  child: Card(
                                                    color: listColour[int.parse(
                                                            documentSnapshot[
                                                                "todoPriority_index"]) -
                                                        1],
                                                    elevation: 4,
                                                    margin: EdgeInsets.only(
                                                      right: 15,
                                                      left: 15,
                                                      top: 4,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8)),
                                                    child: ListTile(
                                                      onTap: () {
                                                        _showEditDialog(
                                                            int.parse(documentSnapshot[
                                                                    "todoPriority_index"]) -
                                                                1,
                                                            documentSnapshot[
                                                                "todoTitle"],
                                                            documentSnapshot[
                                                                "todoGroupTag"]);
                                                      },
                                                      dense: true,
                                                      title: Text(
                                                          documentSnapshot[
                                                              "todoTitle"]),
                                                      trailing: IconButton(
                                                        icon:
                                                            Icon(Icons.delete),
                                                        onPressed: () {
                                                          deleteTodos(
                                                              documentSnapshot[
                                                                  "todoTitle"],
                                                              documentSnapshot[
                                                                  "todoGroupTag"]);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      );
                                    }
                                  },
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    // alignment: Alignment.centerRight,
                                    child: Center(
                                      heightFactor: 0.5,
                                      child: FlatButton(
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            _showConfirmDialog(
                                                documentSnapshot);
                                            print("object");
                                          },
                                          child: Text("delete this group")),
                                    ))
                              ],
                            ),
                          ),
                        );
                      }));
                }
              }),
        ));
  }
}
