import 'package:bake2home/screens/ProfilePage.dart';
import 'package:bake2home/screens/VendorListPage.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/HomeTile.dart';
import 'package:bake2home/widgets/HomeHeading.dart';
import 'package:bake2home/widgets/RecipeTile.dart';
import 'package:bake2home/widgets/PastryTile.dart';
import 'package:bake2home/screens/Cart.dart';
import 'package:bake2home/screens/VendorProfile.dart';
import 'package:bake2home/screens/TrendingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bake2home/functions/shop.dart';

class HomePage extends StatefulWidget {
  
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  
  

  int _index = 0;
  Icon icon  = Icon(Icons.search,color: base,);
  Widget appBarTitle = Text('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        title: appBarTitle,
        elevation: 0.0,
        actions: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/100, 0, MediaQuery.of(context).size.width/80, 0),
              child: IconButton(
              icon: icon,
              onPressed: (){
                setState((){
                  if(this.icon.icon == Icons.search){
                    this.icon = Icon(Icons.close,color: base);
                    this.appBarTitle = new TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,color: base,),
                        hintText: "Search....",
                      ),
                      
                    );

                  }else{
                    this.icon = Icon(Icons.search,color: base,);
                    this.appBarTitle = Text('');
                  }
                  
                });
              },
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
            // Container(
            //   margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/30, 0.0, 0.0, 0.0),
            //   height: MediaQuery.of(context).size.height/4,
            //   color: white,
            //   child: ListView.builder(
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 5,
            //     itemBuilder: (BuildContext context, int index){
            //       return GestureDetector(
            //         child: HomeTile(height: MediaQuery.of(context).size.height/4,width:MediaQuery.of(context).size.width/3.3,radius: MediaQuery.of(context).size.width/10,),
            //         onTap: (){
            //           Navigator.push(context, MaterialPageRoute(builder: (context) => VendorListPage()));                      
            //         },
            //       );
            //     }
            //   ),
            // ),
            Homeheading(heading: "Delicious Chocolates"),
            Container(
              height: MediaQuery.of(context).size.height/10,
              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/30, 0, 0, 0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context,int index){
                  return GestureDetector(
                    child: PastryTile(),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TrendingPage()));
                    },
                  );
                }
              ),
            ),
            Homeheading(heading:'Top Picks For You'),
            Container(
              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/30, 0.0, 0.0, 0.0),
              height: MediaQuery.of(context).size.height/4,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topPickMap.length,
                itemBuilder: (BuildContext context,int index){
                  return GestureDetector(
                    child: HomeTile(height: MediaQuery.of(context).size.height/5,width: MediaQuery.of(context).size.width/3.3,radius: MediaQuery.of(context).size.width/8,title: topPickMap[topPickMap.keys.elementAt(index)].shopName,photo: topPickMap[topPickMap.keys.elementAt(index)].profilePhoto,),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> VendorProfile(shop: shopMap[shopMap.keys.elementAt(index)],)));
                    },
                  );
                }
              )
            ),
            Homeheading(heading: 'Try these Recipes'),
            Container(
              margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/30, 0.0, 0.0, 0.0),
              height: MediaQuery.of(context).size.height/5,
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
          if(_index == 2){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Cart()));
          }
        } 
        ),
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

