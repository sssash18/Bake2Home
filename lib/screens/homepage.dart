import 'package:bake2home/screens/ProfilePage.dart';
import 'package:bake2home/screens/VendorListPage.dart';
import 'package:bake2home/screens/mainPage.dart';
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
 
  void _incrementTab(index) {
    setState(() {
      print('tapped');
      _index = index;
    });
  }

  final List<Widget> _children = [
    MainPage(),
    Center(
      child: Text("NotAvailable"),
    ),
    Cart(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        body: _children[_index],
        bottomNavigationBar: FloatingNavbar(
          onTap: (index) {
            _incrementTab(index);
          },
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
              title: '',
            ),
<<<<<<< HEAD
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
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> VendorProfile(shop: topPickMap[topPickMap.keys.elementAt(index)],)));
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
            
=======
            FloatingNavbarItem(icon: Icons.receipt, title: ''),
            FloatingNavbarItem(icon: Icons.shopping_cart, title: ''),
            FloatingNavbarItem(icon: Icons.person, title: ''),
>>>>>>> 5051cc4325eb5b0711fc8d7b3abf0e0721f0c90c
          ],
        ));
  }
}
