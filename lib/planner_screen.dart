import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: PlannerRoute()));
}

class PlannerRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Planner Page"),
      backgroundColor: Color(0xff52575D),
    );
  }
}
