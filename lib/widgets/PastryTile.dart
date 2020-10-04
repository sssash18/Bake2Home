import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';


class PastryTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      height: 70.0,
      width: 180.0,
      decoration: BoxDecoration(
        color: pastry,
        borderRadius: BorderRadius.circular(border),
      ),
      child: Stack(
        children:<Widget>[
          Container(
          height: 70.0,
          width: 70.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(border),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/cake.jpeg")
            ),
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(70.0, 0, 0, 0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget>[ 
              Text(
                'Bournville',
                style: TextStyle(
                color: base,
                fontWeight: FontWeight.bold,
                )
              ),
              Text(
                'Rs. 60',
                style: TextStyle(
                color: text,
                )
              ),
              ]
            ),
          )
        ]
      ),
    );

        
    
  }
}