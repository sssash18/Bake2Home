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
    return Container(
      height: MediaQuery.of(context).size.height/5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffeaafc8),Color(0xff654ea3)]
              ),
        borderRadius: BorderRadius.circular(50.0),
      ),
      margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: white,
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                    child: Text(
                    '${shop.shopName}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                    )
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
                    child: Text(
                    '${shop.tagline}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0
                    )
                  ),
                ),
                SizedBox(height: 15.0),
                RatingBar(
                    initialRating: 3.2,
                    itemSize: 15.0,
                    itemCount: 5,
                    ignoreGestures: true,
                    glow: true,
                    itemBuilder: (BuildContext context, int index){
                      return Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                    onRatingUpdate: (rating){}
                ),
               
              ],
            ),
            margin: EdgeInsets.fromLTRB(90.0, 15.0, 15.0, 15.0),
            height: MediaQuery.of(context).size.height/5.5,
            width: MediaQuery.of(context).size.width
          ),
          Container(
              margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              child: CircleAvatar(
              backgroundImage: shop.profilePhoto!=null ? CachedNetworkImageProvider(
                shop.profilePhoto,
                
              ) : AssetImage("assets/images/cake.jpeg"),
              radius: MediaQuery.of(context).size.width/6,
            ),
          ),
          
        ],
      ),
      
    );
  }
}