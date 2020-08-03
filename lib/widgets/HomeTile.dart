import 'package:bake2home/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffeaafc8),Color(0xff654ea3)]
              )
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
                      fontSize: 16.0,
                    )
                  ),
                  SizedBox(
                    height: 5.0,
                  ),   
                  RatingBar(
                    initialRating: 3.2,
                    itemSize: 15.0,
                    itemCount: 5,
                    glow: true,
                    itemBuilder: (BuildContext context, int index){
                      return Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                    onRatingUpdate: (rating){}
                  )
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