import 'package:bake2home/functions/customisedItemModel.dart';
import 'package:bake2home/screens/ItemPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/MySliverAppBar.dart';
import 'package:bake2home/widgets/HomeHeading.dart';
import 'package:bake2home/screens/ItemList.dart';
import 'package:bake2home/functions/shop.dart';

class VendorProfile extends StatelessWidget {
  Shop shop;
  VendorProfile({this.shop});
  @override
  Widget build(BuildContext context) {
    // double exp = (double.parse(shop.experience) / 12);
    // print(exp);
     String experience = '1'; //exp.toStringAsFixed(1);
    // if (exp < 1) {
    //   experience = '0.5';
    // }
    final Shop args = ModalRoute.of(context).settings.arguments;
    if (shop == null) {
      shop = args;
      print('AAAAA' + args.toString());
    }
    return SafeArea(
        child: Material(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: MySliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height / 2,
                shop: shop),
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
                            height: MediaQuery.of(context).size.height / 4,
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
                                  'Experience\n(In Years)',
                                  style: TextStyle(color: white, fontSize: 10),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      experience.toString(),
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
                            height: MediaQuery.of(context).size.height / 4,
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
                                      shop.variety.toString(),
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
                            height: MediaQuery.of(context).size.height / 4,
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
            child: Homeheading(
              heading: 'Recently Added',
              showAll: false,
            ),
          ),
          recentlyAdded(context),
          SliverToBoxAdapter(
            child: Homeheading(
              heading: "Categories",
              showAll: false,
            ),
          ),
          allCategories()
        ],
      ),
    ));
  }

  SliverToBoxAdapter allCategories() {
    List<dynamic> categories = shop.items.keys.toList();
    print(categories);
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
                          builder: (BuildContext context) =>
                              ItemList(itemType: categories[i], shop: shop)));
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0),
                  height: MediaQuery.of(context).size.height / 3.7,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: categoryList
                                      .where((element) =>
                                          element.name == categories[i])
                                      .first
                                      .photoUrl !=
                                  null
                              ? CachedNetworkImageProvider(categoryList
                                  .where((element) =>
                                      element.name == categories[i])
                                  .first
                                  .photoUrl)
                              : AssetImage("assets/images/cake.jpeg"),
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

  SliverToBoxAdapter recentlyAdded(BuildContext context) {
    List<String> recent = shop.recent;
    if (recent.length > 5) {
      List<String> list = recent.sublist(recent.length - 5, recent.length);
      recent = list;
    }
    List<RecentModel> recentList = new List();
    Map<String, dynamic> items = shop.items;
    items.forEach((key, value) {
      Map<String, dynamic> category = Map.from(items[key]);
      // print(category);
      recent.forEach((element) {
        category.forEach((k, v) {
          Map<String, dynamic> type = Map.from(category[k]);
          if (type.containsKey(element)) {
            print('--------->${type[element]}');
            print(k);
            print(key);
            String id = element;
            Map<String, dynamic> value = type[element];
            Map<String, dynamic> dup = value['variants'];
            Map<String, dynamic> variants = Map();
            Map<String, dynamic> idtoprice = Map();
            print(shop.items);
            dup.forEach((key, value) {
              idtoprice.putIfAbsent(key, () => value['price']);
            });
            List<dynamic> prices = idtoprice.values.toList();
            prices.sort((a, b) {
              return a.compareTo(b);
            });
            prices.forEach((element) {
              idtoprice.forEach((key, value) {
                if (value == element) {
                  variants.putIfAbsent(key, () => dup[key]);
                }
              });
            });
            CustomisedItemModel model = CustomisedItemModel(
                itemId: value['itemId'],
                ingredients: List<String>.from(value['ingredients']),
                itemName: value['itemName'],
                itemCategory: value['itemCategory'],
                photoUrl: value['photoUrl'],
                recipe: value['recipe'],
                minTime: value['minTime'].toDouble(),
                variants: variants,
                veg: value['veg'],
                flavours: List<String>.from(value['flavours']));
            RecentModel recentModel = new RecentModel(
              customisedItemModel: model,
              itemType: key,
              itemCategory: k,
            );
            recentList.add(recentModel);
          }
        });
      });
    });
    print(recentList);
    return SliverToBoxAdapter(
        child: Container(
            height: MediaQuery.of(context).size.height / 4.6,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: recentList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemPage(
                                  itemType: recentList[index].itemType,
                                  category: recentList[index].itemCategory,
                                  shopId: shop.shopId,
                                  model:
                                      recentList[index].customisedItemModel)));
                    },
                    child: Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width / 4 + 5,
                        margin: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(border),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffeaafc8),
                                  Color(0xff654ea3)
                                ])),
                        child: Stack(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 4 + 5,
                              height: MediaQuery.of(context).size.width / 4 + 5,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: recentList[index]
                                                .customisedItemModel
                                                .photoUrl ==
                                            null
                                        ? AssetImage('assets/images/cake.jpeg')
                                        : NetworkImage(recentList[index]
                                            .customisedItemModel
                                            .photoUrl),
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
                              child: Text(
                                  recentList[index]
                                      .customisedItemModel
                                      .itemName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: white,
                                  )),
                            )
                          ],
                        )),
                  );
                })));
  }
}

class RecentModel {
  CustomisedItemModel customisedItemModel;
  String itemType;
  String itemCategory;
  RecentModel({this.customisedItemModel, this.itemCategory, this.itemType});
}
