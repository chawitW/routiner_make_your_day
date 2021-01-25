import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SixJarsRoute()));
}

class SixJarsRoute extends StatefulWidget {
  @override
  _SixJarsRouteState createState() => _SixJarsRouteState();
}

class _SixJarsRouteState extends State<SixJarsRoute>
    with SingleTickerProviderStateMixin {
  // PageController pageController = PageController(initialPage: 0);
  // int _currentPage = 0;
  TabController jarController;
  int _currentJar=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jarController = TabController(vsync: this, length: 6, initialIndex: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    jarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff52575D),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffFDDB3A),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add to do list"),
                  content: TextField(
                    onChanged: (String value) {},
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
          Icons.attach_money_rounded,
          color: Colors.white,
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(top: 10, bottom: 4, left: 8, right: 8),
          color: Color(0xffF6F4E6),
          child: Column(
            children: <Widget>[
              ListTile(title: Center(child: Text("Name of jar"))),
              ListTile(
                  title: Center(
                      child: Text(
                "0.00",
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 3.0),
              ))),
              ListTile(title: Center(child: Text("Bath"))),
              TabBar(
                unselectedLabelColor: Color(0xFF41444B),
                indicatorColor: Color(0xffFDDB3A),
                controller: jarController,
                tabs: <Tab>[
                  Tab(
                      icon: Icon(Icons.account_balance_wallet_rounded,
                          color: _currentJar == 0
                              ? Color(0xffFDDB3A)
                              : Color(0xFF41444B))),
                  Tab(
                      icon: Icon(Icons.school_rounded,
                          color: _currentJar == 1
                              ? Color(0xffFDDB3A)
                              : Color(0xFF41444B))),
                  Tab(icon: Icon(Icons.account_balance_rounded,color:
                              _currentJar == 2 ? Color(0xffFDDB3A) : Color(0xFF41444B))),
                  Tab(icon: Icon(Icons.trending_up_rounded,color:
                              _currentJar == 3 ? Color(0xffFDDB3A) : Color(0xFF41444B))),
                  Tab(icon: Icon(Icons.card_travel_rounded,color:
                              _currentJar == 4 ? Color(0xffFDDB3A) : Color(0xFF41444B))),
                  Tab(icon: Icon(Icons.card_giftcard_rounded,color:
                              _currentJar == 5 ? Color(0xffFDDB3A) : Color(0xFF41444B))),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
          color: Color(0xffF6F4E6),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text("Statement"),
              ),
              ListTile(),
              ListTile(),
            ],
          ),
        ),
      ]),
    );
  }
}

// Column(
//               children: <Widget>[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     IconButton(
//                       icon: Icon(Icons.account_balance_wallet_rounded),
//                       onPressed: () {
//                         print("Pressed");
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.school_rounded),
//                       onPressed: () {
//                         print("Pressed");
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         print("Pressed");
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         print("Pressed");
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         print("Pressed");
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         print("Pressed");
//                       },
//                     ),
//                   ],
//                 ),
//                 ListTile(title: Center(child: Text("Name of JAR"),),),
//                 Container(
//                   // margin: EdgeInsets.only(top: 5),
//                   child: Text(
//                     "0.00",
// style: DefaultTextStyle.of(context)
//     .style
//     .apply(fontSizeFactor: 3.0),
//                   ),
//                 ),
//                 Container(
//                   margin: EdgeInsets.only(bottom: 10, top: 10),
//                   child: Text(
//                     "BAHT",
//                     style: DefaultTextStyle.of(context)
//                         .style
//                         .apply(fontSizeFactor: 1.5),
//                   ),
//                 ),
//               ],
//             )
