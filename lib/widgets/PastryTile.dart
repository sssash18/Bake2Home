import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';


class PastryTile extends StatefulWidget {
  String itemName,photoUrl;
  PastryTile({this.itemName,this.photoUrl});

  @override
  _PastryTileState createState() => _PastryTileState();
}

class _PastryTileState extends State<PastryTile> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      height: 70.0,
      width: 180.0,
      decoration: BoxDecoration(
        color: pastry,
        borderRadius: BorderRadius.circular(border),
      ),
      child: Stack(
        children:<Widget>[
          Container(
          height: 70.0,
          width: 70.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(border),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: widget.photoUrl!=null ? CachedNetworkImageProvider(widget.photoUrl) : AssetImage("assets/images/cake.jpeg")
            ),
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(70.0, 0, 0, 0),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget>[ 
              Text(
                '${widget.itemName}',
                style: TextStyle(
                color: base,
                fontWeight: FontWeight.bold,
                )
              ),
              // Text(
              //   '\u20B9 ${widget.itemPrice}',
              //   style: TextStyle(
              //   color: text,
              //   )
              // ),
              ]
            ),
          )
        ]
      ),
    );

        
    
  }
}