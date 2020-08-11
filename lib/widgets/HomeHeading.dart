import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

class Homeheading extends StatelessWidget {
  final String heading;
  Homeheading({this.heading});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 20.0),
        alignment: Alignment.topLeft,
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
          this.heading,
          style : TextStyle(
            color: text,
            fontSize: head,
            fontWeight: FontWeight.bold
          )
          ),
          Align(
              alignment: Alignment.centerRight,
              child: FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Text(
                'view all',
                style: TextStyle(
                  color: button,
                  fontSize: sideButton,
                )
              ),
              onPressed: (){},
              color: white,
            ),
          )
        ]
        ),
    );
  }
}