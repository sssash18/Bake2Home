import 'package:bake2home/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class ItemTile extends StatelessWidget {

  final Map item;
  ItemTile({this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
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
                    item['itemName'],
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
                    'Rs ${item['variants'][item['variants'].keys.elementAt(0)]['price']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0
                    )
                  ),
                ),
            
                
                
              ],
            ),
            margin: EdgeInsets.fromLTRB(90.0, 15.0, 15.0, 15.0),
            height: 100.0,
            width: double.infinity
          ),
          Container(
              margin: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15.0),
              child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider('${item['photoUrl']}'),
              radius: 45.0,
            ),
          ),
          
        ],
      ),
      
    );
  }
}