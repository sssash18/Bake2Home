import 'package:bake2home/screens/router.dart';
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
        tabBarTheme: TabBarTheme(
          unselectedLabelColor: Colors.black,
          labelColor: white,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator : BoxDecoration(
               color: base,
               borderRadius: BorderRadius.circular(40),
               gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffeaafc8),Color(0xff654ea3)]
              )
          )
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Sora'
      ),
      home: Router(),
    );
  }
}
