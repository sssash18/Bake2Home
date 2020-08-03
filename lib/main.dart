import 'package:flutter/material.dart';
import 'package:bake2home/screens/homepage.dart';
import 'package:bake2home/constants.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bake2Home',
      theme: ThemeData(
        primaryColor: base,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Sora'
      ),
      home: HomePage(),
    );
  }
}
