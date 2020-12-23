import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: ToDoRoute()));
}

class ToDoRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("To Do Page"),
      backgroundColor: Color(0xff52575D),
    );
  }
}
