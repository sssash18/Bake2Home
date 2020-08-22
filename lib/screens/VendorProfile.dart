import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/MySliverAppBar.dart';
import 'package:bake2home/widgets/HomeHeading.dart';
import 'package:bake2home/screens/ItemList.dart';
import 'package:bake2home/functions/shop.dart';

class VendorProfile extends StatelessWidget {
  final Shop shop;
  VendorProfile({this.shop});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: MySliverAppBar(expandedHeight: 350, shop: shop),
            pinned: true,
          ),
          SliverToBoxAdapter(
              child: Container(
                  height: 150.0,
                  margin: EdgeInsets.fromLTRB(15.0, 350 / 6 + 15.0, 15.0, 0.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 4 + 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(border),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xffeaafc8),
                                      Color(0xff654ea3)
                                    ])),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  5.0, 10.0, 5.0, 10.0),
                              child: Column(children: <Widget>[
                                Text(
                                  'Experience',
                                  style: TextStyle(
                                    color: white,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${shop.experience}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: white,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                            )),
                        Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 4 + 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(border),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xffeaafc8),
                                      Color(0xff654ea3)
                                    ])),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  5.0, 10.0, 5.0, 10.0),
                              child: Column(children: <Widget>[
                                Text(
                                  'Variety',
                                  style: TextStyle(
                                    color: white,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '29+',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: white,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                            )),
                        Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width / 4 + 5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(border),
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xffeaafc8),
                                      Color(0xff654ea3)
                                    ])),
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  5.0, 10.0, 5.0, 10.0),
                              child: Column(children: <Widget>[
                                Text(
                                  'Orders',
                                  style: TextStyle(
                                    color: white,
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${shop.numOrders}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: white,
                                          fontSize: 30.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ]),
                            )),
                      ]))),
          SliverToBoxAdapter(
            child: Homeheading(heading: 'Recently Added'),
          ),
          recentlyAdded(),
          SliverToBoxAdapter(
            child: Homeheading(heading: "Categories"),
          ),
          allCategories()
        ],
      ),
    ));
  }

  SliverToBoxAdapter allCategories() {
    List<dynamic> categories = shop.items.values.toList();

    return SliverToBoxAdapter(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int i) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => ItemList(
                              itemType: categories[i]['itemType'],
                              shop: shop)));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                  height: 180,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/cake.jpeg"),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(border)),
                  alignment: Alignment.center,
                  child: Text(
                    "${shop.items.keys.elementAt(i)}",
                    style: TextStyle(
                        color: white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              );
            }));
  }

  SliverToBoxAdapter recentlyAdded() {
    return SliverToBoxAdapter(
        child: Container(
            height: 150.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width / 4 + 5,
                      margin: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(border),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xffeaafc8), Color(0xff654ea3)])),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 4 + 5,
                            height: MediaQuery.of(context).size.width / 4 + 5,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/cookie.jpeg"),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(border)),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                0.0,
                                MediaQuery.of(context).size.width / 4 + 10,
                                0.0,
                                0),
                            alignment: Alignment.center,
                            child: Text("Red Velvet Cake",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: white,
                                )),
                          )
                        ],
                      ));
                })));
  }
}
