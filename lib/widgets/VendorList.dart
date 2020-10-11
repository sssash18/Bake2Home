import 'package:bake2home/screens/VendorProfile.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/VendorTile.dart';
import 'package:bake2home/functions/shop.dart';

class VendorList extends StatefulWidget {
  final String category;
  final bool rated;
  VendorList({this.category, this.rated});
  @override
  _VendorListState createState() => _VendorListState();
}

class _VendorListState extends State<VendorList> {
  Map<String, Shop> shopList = Map();
  @override
  Widget build(BuildContext context) {
    shopMap.keys.forEach((element) {
      if (shopMap[element].items.keys.contains(widget.category)) {
        shopList.putIfAbsent(element, () => shopMap[element]);
      }
    });
    if (widget.rated) {
      shopList = shopMap;
    }
    return ListView.builder(
        itemCount: shopList.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          VendorProfile(shop: shopList.values.elementAt(index)),
                    ));
              },
              child: VendorTile(
                shop: shopList.values.elementAt(index),
              ));
        });
  }
}
