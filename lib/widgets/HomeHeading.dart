import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

class Homeheading extends StatelessWidget {
  final String heading;
  final bool showAll;
  final Function showPage;
  Homeheading({this.heading, this.showAll, this.showPage});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(25.0, 20.0, 0.0, 20.0),
      alignment: Alignment.topLeft,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(this.heading,
                style: TextStyle(
                    color: text, fontSize: head, fontWeight: FontWeight.bold)),
            showAll ? _showAllitems(context) : Container()
          ]),
    );
  }

  Widget _showAllitems(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Text('view all',
            style: TextStyle(
              color: button,
              fontSize: sideButton,
            )),
        onPressed: showPage,
        color: white,
      ),
    );
  }
}
