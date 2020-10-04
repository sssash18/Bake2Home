import 'package:bake2home/constants.dart';
import 'package:flutter/material.dart';

class RecipeTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      alignment: Alignment.center,
      height: 200.0,
      width: 250.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(70.0),
        image: DecorationImage(
          image: AssetImage("assets/images/cake.jpeg"),
        ) 
      ),
      child: Text(
        'Cookie',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: white,
          fontSize: head

        )
      ),
      
    );
  }
}