import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

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
            padding: EdgeInsets.fromLTRB(25.0, 25.0, 0, 0.0),
            child: Text(
              'Hello Suyash',
              style: TextStyle(
                color: text,
                fontSize: 50.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      )
    );
  }
}