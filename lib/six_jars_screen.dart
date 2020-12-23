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
        backgroundColor: Color(0xFF000000),
        title: Text('First Route'),
      ),
    );
  }
}
