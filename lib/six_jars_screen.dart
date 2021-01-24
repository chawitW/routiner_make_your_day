import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: SixJarsRoute()));
}

class SixJarsRoute extends StatefulWidget {
  @override
  _SixJarsRouteState createState() => _SixJarsRouteState();
}

class _SixJarsRouteState extends State<SixJarsRoute> {
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
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            clipBehavior: Clip.antiAlias,
            margin:
                const EdgeInsets.only(top: 10, bottom: 4, left: 8, right: 8),
            color: Color(0xffF6F4E6),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.wallet_giftcard),
                      onPressed: () {
                        print("Pressed");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.wallet_travel),
                      onPressed: () {
                        print("Pressed");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        print("Pressed");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        print("Pressed");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        print("Pressed");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        print("Pressed");
                      },
                    ),
                  ],
                ),
                // ListTile(),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    "0.00",
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 4.0),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10, top: 10),
                  child: Text(
                    "BAHT",
                    style: DefaultTextStyle.of(context)
                        .style
                        .apply(fontSizeFactor: 2.0),
                  ),
                ),
              ],
            )),
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
