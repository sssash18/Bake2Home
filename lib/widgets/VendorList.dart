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
  List<Shop> list = new List();
  @override
  Widget build(BuildContext context) {
    list.clear();
    if (widget.rated) {
      shopMap.keys.forEach((element) {
        list.add(shopMap[element]);
      });
    } else {
      shopMap.keys.forEach((element) {
        if (shopMap[element].items.keys.contains(widget.category)) {
          list.add(shopMap[element]);
        }
      });
    }

    list.sort((a, b) {
      if (a.rating > b.rating) {
        return -1;
      } else if (a.rating == b.rating) {
        return 0;
      } else {
        return 1;
      }
    });
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          VendorProfile(shop: list[index]),
                    ));
              },
              child: VendorTile(
                shop: list[index],
              ));
        });
  }
}
