import 'package:bake2home/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VendorTile extends StatelessWidget {
  final Shop shop;
  VendorTile({this.shop});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 30;
    double height = MediaQuery.of(context).size.height * 0.2;
    String shopName = shop.shopName;
    String tagLine = shop.tagline;
    if (shopName.length > 14) {
      shopName = '${shopName.substring(0, 14)}...';
    }
    if (tagLine.length > 25) {
      tagLine = '${tagLine.substring(0, 25)}...';
    }
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: white,
              ),
              height: height * 0.8,
              width: width * 0.8,
              padding: EdgeInsets.only(right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text('$shopName',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                  Text('$tagLine',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 10.0)),
                  RatingBar(
                      initialRating: shop.rating,
                      itemSize: 15.0,
                      itemCount: 5,
                      ignoreGestures: true,
                      glow: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                      },
                      onRatingUpdate: (rating) {}),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: CircleAvatar(
              backgroundImage: shop.profilePhoto != null
                  ? CachedNetworkImageProvider(
                      shop.profilePhoto,
                    )
                  : AssetImage("assets/images/cake.jpeg"),
              radius: 50,
            ),
          ),
        ],
      ),
    );
  }
}
