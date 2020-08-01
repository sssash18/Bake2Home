import 'package:bake2home/constants.dart';
import 'package:flutter/material.dart';
class HomeTile extends StatefulWidget {
  final double height,width,radius;
  HomeTile({this.height,this.width,this.radius}) ;
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
              borderRadius: BorderRadius.circular(border),
            ),
            margin: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 0.0),
            height: widget.height,
            width: widget.width,
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.fromLTRB(0.0, 65.0, 0.0, 0.0),
              child: Column(
                children:<Widget>[
                  Text(
                    'Arijit Singh',
                    style: TextStyle(
                      color: white,
                      fontSize: 20.0,
                    )
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '4.5 star',
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
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                height:widget.height,
                width: widget.width,
                child:Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: widget.radius,
                    backgroundImage: AssetImage("assets/images/profile.jpg"),
                  ),
                )
              ),
        ],
    );
  }
}