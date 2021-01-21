import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: TheoryPage()));
}

class TheoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF41444B),
        title: Text(
          'Routiner',
          style: TextStyle(
            color: Color(0xffFDDB3A),
            fontSize: 20.0,
            fontFamily: 'BPeople',
          ),
        ),
      ),

      body: Text("Theories Page"),
      backgroundColor: Color(0xff52575D),
    );
  }
}
