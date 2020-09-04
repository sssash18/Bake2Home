import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/ItemPage.dart';
import 'package:bake2home/services/searchDelegate.dart';
import 'package:bake2home/screens/TrendingPage.dart';
import 'package:bake2home/screens/VendorProfile.dart';
import 'package:bake2home/widgets/HomeHeading.dart';
import 'package:bake2home/widgets/HomeTile.dart';
import 'package:bake2home/widgets/PastryTile.dart';
import 'package:bake2home/widgets/RecipeTile.dart';
import 'package:bake2home/widgets/VendorList.dart';
import 'package:bake2home/screens/VendorListPage.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Icon icon = Icon(
    Icons.search,
    color: base,
  );
  Widget appBarTitle = Text('BakeMyCake');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.only(left: 10.0),
          child: Image.asset("assets/images/logo.png",height: 20.0,)
        ),
        backgroundColor: white,
        title: Text('BakeMyCake',style: TextStyle(color : base,fontWeight: FontWeight.bold),),
        elevation: 0.0,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 100,
                0, MediaQuery.of(context).size.width / 80, 0),
            child: IconButton(
              icon: icon,
              onPressed: () {
                showSearch(context: context, delegate: searchDelegate());
              },
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height/40,),
            CarouselSlider(
              options: CarouselOptions(
              height: MediaQuery.of(context).size.height/3,
              enableInfiniteScroll: true,
              autoPlay: true,
              autoPlayInterval: Duration(seconds : 2),
              ),
              items: [1,2,3,4,5].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: 
                      BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
                        borderRadius: BorderRadius.circular(border),
                        image: DecorationImage(image: AssetImage('assets/images/cake.jpeg'),fit: BoxFit.fill),
                      ),
          
                    );
                  },
                );
              }).toList(),
            ),
            Homeheading(heading: 'Categories',showAll: false,),
            Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 30, 0.0, 0.0, 0.0),
                height: MediaQuery.of(context).size.height / 4,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: HomeTile(
                          showRating: false,
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 3.3,
                          radius: MediaQuery.of(context).size.width / 8,
                          title: categoryList.elementAt(index).name[0].toUpperCase() + categoryList.elementAt(index).name.substring(1),
                          photo: categoryList.elementAt(index).photoUrl
                        ),
                        onTap: () {
             
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      VendorListPage(title : categoryList.elementAt(index).name[0].toUpperCase() + categoryList.elementAt(index).name.substring(1),rated: false,),
                              )
                          );
                        },
                      );
                    })),
            Homeheading(heading: "Trend in Town",showAll: true,showPage: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => TrendingPage()));
            },),
            Container(
              height: MediaQuery.of(context).size.height / 10,
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 30, 0, 0, 0),
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: PastryTile(),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    Container()
                                )
                            );
                      },
                    );
                  }),
            ),
            
            Homeheading(heading: 'Top Picks For You',showAll: true,showPage: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VendorListPage(title: 'Top Picks',rated: true,)));
            },),
            Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 30, 0.0, 0.0, 0.0),
                height: MediaQuery.of(context).size.height / 4,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: topPickMap.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: HomeTile(
                          showRating: true,
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width / 3.3,
                          radius: MediaQuery.of(context).size.width / 8,
                          title: topPickMap[topPickMap.keys.elementAt(index)]
                              .shopName,
                          photo: topPickMap[topPickMap.keys.elementAt(index)]
                              .profilePhoto,
                        ),
                        onTap: () {
                          
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      VendorProfile(
                                        shop: shopMap[
                                            shopMap.keys.elementAt(index)],
                                      )));
                        },
                      );
                    })),
            
          ],
        ),
      ),
    );
  }
}
