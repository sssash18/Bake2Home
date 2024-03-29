import 'dart:async';

import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/ItemPage.dart';
import 'package:bake2home/screens/NoInternet.dart';
import 'package:bake2home/services/database.dart';
import 'package:bake2home/services/searchDelegate.dart';
import 'package:bake2home/screens/TrendingPage.dart';
import 'package:bake2home/screens/VendorProfile.dart';
import 'package:bake2home/widgets/HomeHeading.dart';
import 'package:bake2home/widgets/HomeTile.dart';
import 'package:bake2home/widgets/PastryTile.dart';
import 'package:bake2home/widgets/RecipeTile.dart';
import 'package:bake2home/widgets/Review.dart';
import 'package:bake2home/widgets/VendorList.dart';
import 'package:bake2home/screens/VendorListPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Icon icon = Icon(
    Icons.search,
    color: base,
  );

  StreamSubscription<ConnectivityResult> subs;
  Connectivity _connectivity;
  bool internetStatus = true;
  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _connectivity.checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        internetStatus = false;
      }
    });
    subs =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult event) {
      setState(() {
        if (event == ConnectivityResult.none) {
          internetStatus = false;
        } else {
          internetStatus = true;
        }
      });
    });
  }

  Widget appBarTitle = Text('BakeMyCake');
  @override
  Widget build(BuildContext context) {
    return internetStatus == true
        ? Scaffold(
            appBar: AppBar(
              leading: Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 20.0,
                  )),
              backgroundColor: white,
              title: Text(
                'BakeMyCake',
                style: TextStyle(color: base, fontWeight: FontWeight.bold),
              ),
              elevation: 0.0,
              actions: <Widget>[
                // IconButton(
                //   icon: Icon(
                //     Icons.skip_next,
                //     color: black,
                //   ),
                //   onPressed: () {
                //     cartMap.update('shopId', (value) => 'aaja');
                //     print(cartMap);
                //   },
                // ),
                IconButton(
                  icon: icon,
                  onPressed: () {
                    showSearch(context: context, delegate: searchDelegate());
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                  CarouselSlider(
                    options: CarouselOptions(
                        height: MediaQuery.of(context).size.height / 3,
                        enableInfiniteScroll: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        enlargeCenterPage: true),
                    items: slidesUrl.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Material(
                            elevation: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xffeaafc8),
                                      Color(0xff654ea3)
                                    ]),
                                borderRadius: BorderRadius.circular(border),
                                image: DecorationImage(
                                    image: CachedNetworkImageProvider(i),
                                    fit: BoxFit.fill),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  Homeheading(
                    heading: 'Categories',
                    showAll: false,
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 30,
                          0.0,
                          0.0,
                          0.0),
                      height: MediaQuery.of(context).size.height / 4,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categoryList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: HomeTile(
                                  showRating: false,
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  width:
                                      MediaQuery.of(context).size.width / 3.3,
                                  radius: MediaQuery.of(context).size.width / 8,
                                  title: categoryList
                                          .elementAt(index)
                                          .name[0]
                                          .toUpperCase() +
                                      categoryList
                                          .elementAt(index)
                                          .name
                                          .substring(1),
                                  photo:
                                      categoryList.elementAt(index).photoUrl),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          VendorListPage(
                                        title: categoryList
                                                .elementAt(index)
                                                .name[0]
                                                .toUpperCase() +
                                            categoryList
                                                .elementAt(index)
                                                .name
                                                .substring(1),
                                        rated: false,
                                      ),
                                    ));
                              },
                            );
                          })),
                  Homeheading(
                    heading: "Trending in Town",
                    showAll: false,
                    showPage: (context) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TrendingPage()));
                    },
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 10,
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 30, 0, 0, 0),
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: trendingList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            child: PastryTile(
                              itemName:
                                  trendingList.elementAt(index).model.itemName,
                              shopId: trendingList.elementAt(index).shopId,
                              photoUrl: ((trendingList
                                          .elementAt(index)
                                          .model
                                          .photoUrl) !=
                                      null
                                  ? trendingList.elementAt(index).model.photoUrl
                                  : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/Artboard%20%E2%80%93%201%20(5).png?alt=media&token=e48e0063-6727-47c7-82e8-df2d02c07b57'),
                            ),
                            onTap: () {
                              print(trendingList.elementAt(index).model.recipe);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ItemPage(
                                            model: trendingList
                                                .elementAt(index)
                                                .model,
                                            shopId: trendingList
                                                .elementAt(index)
                                                .shopId,
                                          )));
                            },
                          );
                        }),
                  ),
                  Homeheading(
                    heading: "Top Picks for You",
                    showAll: true,
                    showPage: (context) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => VendorListPage(
                                  title: "Top Rated", rated: true)));
                    },
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 30,
                          0.0,
                          0.0,
                          0.0),
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
                                title:
                                    topPickMap[topPickMap.keys.elementAt(index)]
                                        .shopName,
                                photo:
                                    topPickMap[topPickMap.keys.elementAt(index)]
                                        .profilePhoto,
                                rating:
                                    topPickMap[topPickMap.keys.elementAt(index)]
                                        .rating,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            VendorProfile(
                                              shop: shopMap[topPickMap[
                                                      topPickMap.keys
                                                          .elementAt(index)]
                                                  .shopId],
                                            )));
                              },
                            );
                          })),
                ],
              ),
            ),
          )
        : NoInternet();
  }

  @override
  void dispose() {
    super.dispose();
    subs.cancel();
  }
}
