import 'package:bake2home/screens/ProfilePage.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/HomeTile.dart';
import 'package:bake2home/widgets/HomeHeading.dart';
import 'package:bake2home/widgets/RecipeTile.dart';


import 'package:bake2home/widgets/PastryTile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

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
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sora'
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
            ),
            Homeheading(heading: 'Try these Recipes'),
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
              height: 180.0,
              child: ListView.builder(
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index){
                  return RecipeTile();
                }
              )
            )
            
          ],
        ),
      ),
      bottomNavigationBar: FloatingNavbar(
        onTap: (int val) => setState((){
          _index = val;
          if(_index == 3){
            Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
          }
        } ),
        currentIndex: _index,
        fontSize: 0.0,
        borderRadius: 40.0,
        itemBorderRadius: 80.0,
        backgroundColor: base,
        selectedBackgroundColor: white,
        unselectedItemColor: white,
        iconSize: 25.0,
        items: [
          FloatingNavbarItem(
            icon: Icons.home,
            title: ''
          ),
          FloatingNavbarItem(
            icon: Icons.receipt,
            title: ''
          ),
          FloatingNavbarItem(
            icon: Icons.shopping_cart,
            title: ''
          ),
          FloatingNavbarItem(
            icon: Icons.person,
            title: ''
          ),

        ],
      )
    );
  }
}

