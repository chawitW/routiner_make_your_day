import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp(home: ToDoRoute()));
}

class ToDoRoute extends StatefulWidget {
  @override
  _ToDoRouteState createState() => _ToDoRouteState();
}

class _ToDoRouteState extends State<ToDoRoute> {
  String input = "";
  String priority;
  String groupTag = "";
  var priority_index;
  List listMatrix = [
    "Urgent and important",
    "Not urgent and important",
    "Urgent and not important",
    "Not urgent and not important"
  ];

  @override
  void initState() {
    priority = listMatrix.first;
    super.initState();
  }

  createTodos() {
    DocumentReference documentReference =
        // FirebaseFirestore.instance.collection("MyTodos").doc(groupTag).collection("groupList").doc(input);
        FirebaseFirestore.instance.collection("MyTodos").doc(groupTag);

    Map<String, String> todos = {
      "todoTitle": input,
      "todoPriority": priority,
      "todoPriority_index": priority_index.toString(),
      "todoGroupTag": groupTag,
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

  deleteTodos(item, tag) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(tag);

    documentReference
        .collection("groupList")
        .doc(item)
        .delete()
        .whenComplete(() {
      // if (documentReference.collection("groupList").limit(1).get() == null) {
      //   // documentReference.delete();
      //   print("NULL");
      // }

      // documentReference.delete(); //can use this in right condition

      print("deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    // Padding(padding: const EdgeInsets.all(20),);
    return Scaffold(
        backgroundColor: Color(0xff52575D),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffFDDB3A),
          onPressed: () {
            priority = listMatrix.first;
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      // var height = MediaQuery.of(context).size.height;
                      // var width = MediaQuery.of(context).size.width;
                      return AlertDialog(
                        backgroundColor: Color(0xffF6F4E6),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        title: Text("Add to do list"),
                        content: Container(
                          // height: height*0.22,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                onChanged: (String value) {
                                  input = value;
                                },
                              ),
                              Container(
                                margin: EdgeInsets.all(15.0),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      isExpanded: true,
                                      // hint: Text("Choose"),
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
                              TextField(
                                onChanged: (String value) {
                                  groupTag = value;
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        if (priority == listMatrix[0]) {
                                          priority_index = 1;
                                        } else if (priority == listMatrix[1]) {
                                          priority_index = 2;
                                        } else if (priority == listMatrix[2]) {
                                          priority_index = 3;
                                        } else if (priority == listMatrix[3]) {
                                          priority_index = 4;
                                        } else {
                                          priority_index = 0;
                                        }
                                        createTodos();
                                        Navigator.of(context).pop();
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
          // color: Color(0xffF6F4E6),
          margin: EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 4.0),
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("MyTodos").snapshots(),
              builder: (context, snapshots) {
                // if(snapshots.data.documents.ex){
                // }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot =
                          snapshots.data.documents[index];
                      return Card(
                        color: Color(0xffF6F4E6),
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(documentSnapshot["groupTag"]),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("MyTodos")
                                  .doc(documentSnapshot["groupTag"])
                                  .collection("groupList")
                                  .snapshots(),
                              builder: (context, snapshots) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: snapshots.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot documentSnapshot =
                                          snapshots.data.documents[index];
                                      return Dismissible(
                                        onDismissed: (direction) {
                                          deleteTodos(
                                              documentSnapshot["todoTitle"],
                                              documentSnapshot["todoGroupTag"],
                                              );
                                        },
                                        key: Key(documentSnapshot["todoTitle"]),
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
                                                          listMatrix[2]
                                                      ? Color(0xff8675A9)
                                                      : documentSnapshot[
                                                                  "todoPriority"] ==
                                                              listMatrix[3]
                                                          ? Color(0xffADE498)
                                                          : Color(0xffF6F4E6),
                                          elevation: 4,
                                          margin: EdgeInsets.all(2),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: ListTile(
                                            title: Text(
                                                documentSnapshot["todoTitle"]),
                                            trailing: IconButton(
                                              icon: Icon(Icons.delete),
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
                                      );
                                    });
                              },
                            ),
                          ],
                        ),
                      );
                    });
              }),
        ));
  }
}
