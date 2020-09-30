import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:bake2home/constants.dart';

class Temp extends StatefulWidget {
  final double size;
  Temp({this.size});
  @override
  _TempState createState() => _TempState(
        size: size,
      );
}

class _TempState extends State<Temp> {
  final double size;
  _TempState({this.size});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 50,
        height: 50,
        child: SpinKitChasingDots(
          size: size,
          color: black,
        ),
      ),
    );
  }
}
