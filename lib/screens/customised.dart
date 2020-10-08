import 'package:bake2home/functions/customisedItemModel.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/services/database.dart';
import 'package:bake2home/widgets/ItemTile.dart';
import 'package:bake2home/widgets/emptyList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomisedItem extends StatefulWidget {
  String itemType, category;
  Shop shop;
  CustomisedItem({this.itemType, this.shop, this.category});
  @override
  _CustomisedItemState createState() => _CustomisedItemState();
}

class _CustomisedItemState extends State<CustomisedItem> {
  List<CustomisedItemModel> list;
  @override
  void initState() {
    super.initState();
    list = new List();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DatabaseService()
            .getItemList(widget.shop.shopId, widget.itemType, widget.category)
            .stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            list = List.from(snapshot.data);
            return list.isNotEmpty
                ? ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext context, int i) {
                      return ItemTile(
                          itemType: widget.itemType,
                          category: widget.category,
                          model: list[i],
                          shopId: this.widget.shop.shopId);
                    })
                : EmptyList();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
