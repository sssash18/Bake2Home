import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/customisedItemModel.dart';
import 'package:bake2home/screens/ItemPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ItemTile extends StatelessWidget {
  CustomisedItemModel model;
  String shopId;
  String itemType;
  String category;
  ItemTile({this.category, this.itemType, this.model, this.shopId});
  @override
  Widget build(BuildContext context) {
    String itemName = model.itemName;
    if (itemName.length > 15) {
      itemName = '${itemName.substring(0, 15)}...';
    }
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ItemPage(
                    itemType: itemType,
                    category: category,
                    shopId: shopId,
                    model: model)));
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
          borderRadius: BorderRadius.circular(50),
        ),
        margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
        child: Stack(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.height / 8),
                  color: white,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                      child: Text('$itemName',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                            child: Text(
                                '\u20B9 ${model.variants[model.variants.keys.elementAt(0)]['price']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0)),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                            child: Image.asset(
                              model.veg == true
                                  ? "assets/images/veg.png"
                                  : "assets/images/noon.png",
                              height: 20,
                              width: 20,
                            ),
                          ),
                        ]),
                  ],
                ),
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 5, 15.0, 15.0, 15.0),
                height: 100.0,
                width: double.infinity),
            Container(
              margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              child: CircleAvatar(
                backgroundImage: model.photoUrl != null
                    ? CachedNetworkImageProvider('${model.photoUrl}')
                    : AssetImage("assets/images/cake.jpeg"),
                radius: 45.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
