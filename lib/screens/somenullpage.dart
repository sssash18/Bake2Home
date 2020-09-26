import 'package:flutter/material.dart';

class SomeNullPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My null page"),
      ),
      body: Container(
        child: Text("Goli marduga banduk nhi h mere pas"),
      ),
    );
  }
}
