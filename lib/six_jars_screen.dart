import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:intl/date_symbol_data_local.dart';
// initializeDateFormatting('fr_FR', null) async .then((_) => runMyCode());

void main() {
  runApp(MaterialApp(home: SixJarsRoute()));
}

class SixJarsRoute extends StatefulWidget {
  @override
  _SixJarsRouteState createState() => _SixJarsRouteState();
}

class _SixJarsRouteState extends State<SixJarsRoute>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Animation degOneTranslationAnimation;
  Animation rotationAnimation;

  String details = "";
  String date = "";
  String time = "";

  // var now = new DateTime.now();
  // var berlinWallFell = new DateTime.utc(1989, 11, 9);
  // var moonLanding = DateTime.parse("1969-07-20 20:18:04Z");

  double getRadainsFormDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  // PageController pageController = PageController(initialPage: 0);
  // int _currentPage = 0;
  TabController jarController;
  int _currentJar = 0;
  // var stmType_index = 0;
  String amount = "0.00";
  String stmType = "";
  List jarName = [
    "Need jar",
    "Education jar",
    "Long-term saving jar",
    "Investment jar",
    "Self reward jar",
    "Donation jar",
  ];

  // _asyncMethod() async {
  //   animationController = await AnimationController(vsync: this, duration: Duration(microseconds: 250));
  //   degOneTranslationAnimation =
  //       Tween(begin: 0.0, end: 1.0).animate(animationController);
  // }

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    degOneTranslationAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
    jarController = TabController(vsync: this, length: 6, initialIndex: 0);

    animationController.addListener(() {
      setState(() {});
    });
    //  _asyncMethod();
  }

  @override
  void dispose() {
    jarController.dispose();
    animationController.dispose();
    super.dispose();
  }
  

  createLedgers() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Ledger")
        .doc(jarName[_currentJar]);

    // Map<String, String> amount = {
    //   "jarAmount": "6.00",
    //   "jarNumber": _currentJar.toString(),
    // };
    // documentReference.set(amount);
    //mock data

    Map<String, String> statement = {
      "ledgerDetails": details,
      "ledgerDate": date,
      "ledgerTime": time,
      "ledgerType": stmType,
      "ledgerAmount": amount,
    };

    documentReference.collection("statementList").doc(details).set(statement);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xff52575D),
        body: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 4, left: 8, right: 8),
                          color: Color(0xffF6F4E6),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title:
                                    Center(child: Text(jarName[_currentJar])),
                              ),
                              ListTile(
                                  title: Center(
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection("Ledger")
                                              .orderBy("jarNumber")
                                              .snapshots(),
                                          builder: (context, snapshots) {
                                            if (snapshots.data == null)
                                              return CircularProgressIndicator();
                                            return Text(
                                              snapshots.data
                                                      .documents[_currentJar]
                                                  ["jarAmount"],
                                              style: TextStyle(fontSize: 36),
                                            );
                                            // return;
                                          }))),
                              ListTile(title: Center(child: Text("Baht"))),
                              TabBar(
                                unselectedLabelColor: Color(0xFF41444B),
                                indicatorColor: Color(0xffFDDB3A),
                                controller: jarController,
                                tabs: <Tab>[
                                  Tab(
                                      icon: Icon(
                                          Icons.account_balance_wallet_rounded,
                                          color: _currentJar == 0
                                              ? Color(0xffFDDB3A)
                                              : Color(0xFF41444B))),
                                  Tab(
                                      icon: Icon(Icons.school_rounded,
                                          color: _currentJar == 1
                                              ? Color(0xffFDDB3A)
                                              : Color(0xFF41444B))),
                                  Tab(
                                      icon: Icon(Icons.account_balance_rounded,
                                          color: _currentJar == 2
                                              ? Color(0xffFDDB3A)
                                              : Color(0xFF41444B))),
                                  Tab(
                                      icon: Icon(Icons.trending_up_rounded,
                                          color: _currentJar == 3
                                              ? Color(0xffFDDB3A)
                                              : Color(0xFF41444B))),
                                  Tab(
                                      icon: Icon(Icons.card_travel_rounded,
                                          color: _currentJar == 4
                                              ? Color(0xffFDDB3A)
                                              : Color(0xFF41444B))),
                                  Tab(
                                      icon: Icon(Icons.card_giftcard_rounded,
                                          color: _currentJar == 5
                                              ? Color(0xffFDDB3A)
                                              : Color(0xFF41444B))),
                                ],
                                onTap: (index) {
                                  _currentJar = index;
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          clipBehavior: Clip.antiAlias,
                          margin: const EdgeInsets.only(
                              top: 4, bottom: 4, left: 8, right: 8),
                          color: Color(0xffF6F4E6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          top: 10, left: 10, bottom: 5),
                                      child: Text(
                                        "Statement",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("Ledger")
                                    .doc(jarName[_currentJar])
                                    .collection("statementList")
                                    .snapshots(),
                                builder: (context, snapshots) {
                                  if (snapshots.data == null) {
                                    return CircularProgressIndicator();
                                  } else {
                                    return Container(
                                      margin:
                                          EdgeInsets.only(bottom: 5, top: 10),
                                      child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              snapshots.data.documents.length,
                                          itemBuilder: (context, index) {
                                            DocumentSnapshot documentSnapshot =
                                                snapshots.data.documents[index];
                                            return Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 5),
                                              child: Card(
                                                color: documentSnapshot[
                                                            "ledgerType"] ==
                                                        "Income"
                                                    ? Color(0xffADE498)
                                                    : Color(0xffFA7F72),
                                                // elevation: 4,
                                                margin: EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: ListTile(
                                                  title: Container(
                                                    height: 30,
                                                    child: Text(documentSnapshot[
                                                                "ledgerDetails"] ==
                                                            ""
                                                        ? documentSnapshot[
                                                            "ledgerType"]
                                                        : documentSnapshot[
                                                            "ledgerDetails"]),
                                                  ),
                                                  trailing: Container(
                                                    height: 30,
                                                    child: Text(documentSnapshot[
                                                                "ledgerType"] ==
                                                            "Income"
                                                        ? "+" +
                                                            documentSnapshot[
                                                                "ledgerAmount"]
                                                        : "-" +
                                                            documentSnapshot[
                                                                "ledgerAmount"]),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    IgnorePointer(
                      child: Container(
                        color: Colors.transparent,
                        height: 150.0,
                        width: 150.0,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadainsFormDegree(270),
                          degOneTranslationAnimation.value * 80),
                      child: Transform(
                        transform: Matrix4.rotationZ(
                            getRadainsFormDegree(rotationAnimation.value)),
                        alignment: Alignment.center,
                        child: CircularButton(
                          color: Color(0xffFA7F72),
                          width: 50,
                          height: 50,
                          icon: Icon(
                            Icons.remove,
                            color: Color(0xffF6F4E6),
                          ),
                          onClick: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      stmType = "Outgo";
                                      return AlertDialog(
                                        backgroundColor: Color(0xffF6F4E6),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        title: Center(child: Text("OUTGO")),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.teal)),
                                                    hintText:
                                                        'amount statement',
                                                    labelText: 'Amount',
                                                  ),
                                                  onChanged: (String value) {
                                                    amount = value;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.teal)),
                                                    hintText:
                                                        'amount statement',
                                                    labelText: 'Details',
                                                  ),
                                                  onChanged: (String value) {
                                                    details = value;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.teal)),
                                                    hintText:
                                                        'amount statement',
                                                    labelText: 'Date',
                                                  ),
                                                  onChanged: (String value) {
                                                    date = value;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: TextField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                Colors.teal)),
                                                    hintText:
                                                        'amount statement',
                                                    labelText: 'Time',
                                                  ),
                                                  onChanged: (String value) {
                                                    time = value;
                                                  },
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        createLedgers()();
                                                      },
                                                      child: Container(
                                                        child: Icon(
                                                          Icons
                                                              .add_circle_rounded,
                                                          color:
                                                              Color(0xffFDDB3A),
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
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset.fromDirection(getRadainsFormDegree(180),
                          degOneTranslationAnimation.value * 80),
                      child: CircularButton(
                        color: Color(0xffADE498),
                        width: 50,
                        height: 50,
                        icon: Icon(
                          Icons.add,
                          color: Color(0xffF6F4E6),
                        ),
                        onClick: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    stmType = "Income";
                                    return AlertDialog(
                                      backgroundColor: Color(0xffF6F4E6),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      title: Center(child: Text("INCOME")),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.teal)),
                                                  hintText: 'amount statement',
                                                  labelText: 'Amount',
                                                ),
                                                onChanged: (String value) {
                                                  amount = value;
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.teal)),
                                                  hintText: 'amount statement',
                                                  labelText: 'Details',
                                                ),
                                                onChanged: (String value) {
                                                  details = value;
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.teal)),
                                                  hintText: 'amount statement',
                                                  labelText: 'Date',
                                                ),
                                                onChanged: (String value) {
                                                  date = value;
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.teal)),
                                                  hintText: 'amount statement',
                                                  labelText: 'Time',
                                                ),
                                                onChanged: (String value) {
                                                  time = value;
                                                },
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                FlatButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      createLedgers()();
                                                    },
                                                    child: Container(
                                                      child: Icon(
                                                        Icons
                                                            .add_circle_rounded,
                                                        color:
                                                            Color(0xffFDDB3A),
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
                      ),
                    ),
                    CircularButton(
                      color: Color(0xffFDDB3A),
                      width: 60,
                      height: 60,
                      icon: Icon(
                        Icons.attach_money_rounded,
                        color: Color(0xffF6F4E6),
                      ),
                      onClick: () {
                        animationController.isCompleted
                            ? animationController.reverse()
                            : animationController.forward();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class CircularButton extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Icon icon;
  final Function onClick;

  CircularButton(
      {this.width, this.height, this.color, this.icon, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Color(0xffF6F4E6))),
      width: width,
      height: height,
      child: IconButton(
        icon: icon,
        enableFeedback: true,
        onPressed: onClick,
      ),
    );
  }
}
