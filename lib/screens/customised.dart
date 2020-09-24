import 'package:bake2home/functions/customisedItemModel.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/widgets/ItemTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomisedItem extends StatefulWidget {
  String itemType,category;
  Shop shop;
  CustomisedItem({this.itemType, this.shop,this.category});
  @override
  _CustomisedItemState createState() => _CustomisedItemState();
}

class _CustomisedItemState extends State<CustomisedItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('************** ${widget.shop.shopId}');
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Shops')
            .doc(widget.shop.shopId)
            .snapshots(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
           Map<String, dynamic> allItems =
                Map.from(snapshot.data.data()['items'][widget.itemType][widget.category]);
            List<CustomisedItemModel> list = List();
            print(snapshot.data.data().toString());
            if (allItems != null ){
              allItems.forEach((key, value) {
              CustomisedItemModel model = CustomisedItemModel(
                //availability: value['availability'],
                itemId: value['itemId'],
               // ingPrice: value['ingPrice'].toDouble(),
                ingredients: List<String>.from(value['ingredients']),
                itemName: value['itemName'],
                itemCategory : value['itemCategory'],
                photoUrl: value['photoUrl'],
                recipe: value['recipe'],
                variants: Map.from(value['variants']),
                flavours: List<String>.from(value['flavours'])
                
              );
              list.add(model);
              });
            }
            
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int i) {
                  return ItemTile(model: list[i],shopId:this.widget.shop.shopId);
                });
          } else {
            return Center(
              child: Text("Loading......"),
            );
          }
          
        });
  }
}
