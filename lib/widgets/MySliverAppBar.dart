import 'package:bake2home/functions/shop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';


class MySliverAppBar extends SliverPersistentHeaderDelegate{

    final double expandedHeight;
    final Shop shop;
    MySliverAppBar({ @required this.expandedHeight,this.shop});
    @override
    Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
      return Material(
          child: Stack(
          fit: StackFit.expand,
          overflow: Overflow.visible,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: "${shop.coverPhoto}",
              fit: BoxFit.fill,
            ),
            
            Opacity(
              opacity: shrinkOffset/expandedHeight,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(25.0,20, 0, 0),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider("${shop.profilePhoto}"),
                      radius: 50.0,
                    ),
                  ),
                  Container(
                  height: 150.0,
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.fromLTRB(10, 50, 30, 0),
                  child: 
                    Column(
                    children: <Widget>[
                      Text(
                        '${shop.shopName}',
                        style: TextStyle(
                          fontSize:20.0,
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sora',
                        ),
                      ),
                      Text(
                        '${shop.tagline}',
                        style: TextStyle(
                          fontSize:10.0,
                          color: white,
                          
                        ),
                      ),
                      
                    ],
                ),
                  
              )
                ],
              )
            ),
            Center(
              child: Opacity(
                opacity: 1- (shrinkOffset/expandedHeight),
                child: Container(
                    height: (1 - shrinkOffset/expandedHeight)*expandedHeight,
                    child: Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.fromLTRB(0, 40.0, 0, 20),
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider("${shop.profilePhoto}"),
                          radius: 50.0,
                        ),
                      ),
                      SizedBox(height: 30),
                      Text(  
                        '${shop.shopName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:30.0,
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Sora',
                        ),
                      ),
                      Text(
                        '${shop.tagline}',
                        style: TextStyle(
                          fontSize:15.0,
                          color: white,
                          
                        ),
                      ),
                      
                    ],
                  ),
                )
              )
            ),
          Positioned(
          top: (expandedHeight / 1 - shrinkOffset)- expandedHeight/6,
          left: MediaQuery.of(context).size.width / 26,
          child: Opacity(
            opacity: (1 - shrinkOffset / expandedHeight),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:white,
                boxShadow: [BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0),
                blurRadius: 10.0
                )]
              )
              ,
              child: SizedBox(
                height: expandedHeight/3,
                width: 12 * MediaQuery.of(context).size.width / 13,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18.0,
                        
                      )
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0),
                      alignment: Alignment.center,
                      child: Text('${shop.bio}'),
                    ),
                  ]
                ),
              ),
            ),
          ),
          ),         
          ],
        ),
      );
      
    }
  
    @override
    double get maxExtent => expandedHeight;
  
    @override
    double get minExtent => 150;
  
    @override
    bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
      return true;
    }
  
}