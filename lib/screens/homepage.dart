import 'package:bake2home/screens/SellerTile.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/HomeTile.dart';
import 'package:bake2home/widgets/HomeHeading.dart';

import 'package:bake2home/widgets/PastryTile.dart';

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
      body: SingleChildScrollView(
          child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(25.0, 25.0, 0, 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                  child: Text(
                  'Hello\nSuyash',
                  style: TextStyle(
                    color: text,
                    fontSize: 45.0,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              height: 200.0,
              color: white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index){
                  return HomeTile(height: 200.0,width: 105.0,radius: 40.0,);
                }
              ),
            ),
            Homeheading(heading: "Delicious Chocolates"),
            Container(
              height: 70.0,
              margin: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context,int index){
                  return PastryTile();
                }
              ),
            ),
            Homeheading(heading:'Top Picks For You'),
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              height: 200.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context,int index){
                  return HomeTile(height: 140,width:120,radius: 50.0,);
                }
              )
            )
            
          ],
        ),
      )
    );
  }
}

