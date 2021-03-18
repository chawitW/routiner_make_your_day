import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  runApp(MaterialApp(home: ToDoRoute()));
}

class ToDoRoute extends StatefulWidget {
  @override
  _ToDoRouteState createState() => _ToDoRouteState();
}

class _ToDoRouteState extends State<ToDoRoute> with TickerProviderStateMixin {
  TabController dateController;
  bool addToPlanner = false;
  String input = "";
  String priority;
  String groupTag = "";
  var priority_index;
  final user = FirebaseAuth.instance.currentUser;
  List listMatrix = [
    "Urgent and important",
    "Not urgent and important",
    "Urgent and not important",
    "Not urgent and not important"
  ];
  bool expand = false;

  @override
  void initState() {
    priority = listMatrix.first;
    super.initState();
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
                                          borderSide:
                                              BorderSide(color: Colors.teal)),
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
                                        borderSide:
                                            BorderSide(color: Colors.teal)),
                                  ),
                                  margin: EdgeInsets.only(top: 10, bottom: 10),
                                  child: Container(
                                    margin: EdgeInsets.all(15),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                          isExpanded: true,
                                          value: priority,
                                          isDense: true,
                                          onChanged: (newValue) {
                                            setState(() {
                                              priority = newValue;
                                            });
                                            print(priority);
                                          },
                                          items: listMatrix.map((valueItem) {
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
                                    ],
                                  ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          if (priority == listMatrix[0]) {
                                            priority_index = 1;
                                          } else if (priority ==
                                              listMatrix[1]) {
                                            priority_index = 2;
                                          } else if (priority ==
                                              listMatrix[2]) {
                                            priority_index = 3;
                                          } else if (priority ==
                                              listMatrix[3]) {
                                            priority_index = 4;
                                          } else {
                                            priority_index = 0;
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
                  // print(user.email);
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
                                                  key: ValueKey(index),
                                                  onDismissed: (directoin) {
                                                    _completedTask(
                                                        documentSnapshot);
                                                  },
                                                  child: Card(
                                                    color: documentSnapshot[
                                                                "todoPriority"] ==
                                                            listMatrix[0]
                                                        ? Color(0xffFA7F72)
                                                        : documentSnapshot[
                                                                    "todoPriority"] ==
                                                                listMatrix[1]
                                                            ? Color(0xff7FDBDA)
                                                            : documentSnapshot[
                                                                        "todoPriority"] ==
                                                                    listMatrix[
                                                                        2]
                                                                ? Color(
                                                                    0xff8675A9)
                                                                : documentSnapshot["todoPriority"] ==
                                                                        listMatrix[
                                                                            3]
                                                                    ? Color(
                                                                        0xffADE498)
                                                                    : Color(
                                                                        0xffF6F4E6),
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
