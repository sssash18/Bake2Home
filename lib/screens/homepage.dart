import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/HomeTile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: (){},
            color: base,
          ),
          Container(
              margin: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
              child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: base,
              ), 
              onPressed: (){},
            ),
          )
        ],
      ),
      body: Column(

        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(25.0, 25.0, 0, 30.0),
            child: Align(
              alignment: Alignment.centerLeft,
                child: Text(
                'Hello\nSuyash',
                style: TextStyle(
                  color: base,
                  fontSize: 45.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            height: 200.0,
            color: white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index){
                return HomeTile();
              }
            ),
          )
          
        ],
      )
    );
  }
}