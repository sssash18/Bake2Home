import 'package:bake2home/constants.dart';
import 'package:flutter/material.dart';

class HomeTile extends StatefulWidget {
  @override
  _HomeTileState createState() => _HomeTileState();
}

class _HomeTileState extends State<HomeTile> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(30.0),
            ),
            margin: EdgeInsets.fromLTRB(5.0, 40.0, 5.0, 0.0),
            height: 200.0,
            width: 120.0,
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
              child: Column(
                children:<Widget>[
                  Text(
                    'Cookies',
                    style: TextStyle(
                      color: white,
                      fontSize: 20.0,
                    )
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    '(20)',
                    style: TextStyle(
                      color: white,
                      fontSize: 20.0,
                    )
                  ),
                ]
              ),
            ), 
            ),
            Container(
                margin: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                height:200.0,
                width: 120.0,
                child:Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage("assets/images/cookie.jpeg"),
                  ),
                )
              ),
        ],
    );
  }
}