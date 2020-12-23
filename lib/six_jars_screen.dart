import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: SixJarsRoute(),
  ));
}

class SixJarsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff52575D),
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
    );
  }
}
