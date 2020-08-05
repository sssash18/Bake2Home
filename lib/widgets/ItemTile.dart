import 'package:bake2home/constants.dart';
import 'package:flutter/material.dart';


class ItemTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffeaafc8),Color(0xff654ea3)]
              ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: white,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                    child: Text(
                    'Chocolate Cake',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                    )
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                    child: Text(
                    'Rs 500',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0
                    )
                  ),
                ),
            
                
                
              ],
            ),
            margin: EdgeInsets.fromLTRB(90.0, 15.0, 15.0, 15.0),
            height: 100.0,
            width: double.infinity
          ),
          Container(
              margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              child: CircleAvatar(
              backgroundImage: AssetImage("assets/images/cake.jpeg"),
              radius: 45.0,
            ),
          ),
          
        ],
      ),
      
    );
  }
}