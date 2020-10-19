import 'package:bake2home/functions/shop.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Shop shop;
  MySliverAppBar({@required this.expandedHeight, this.shop});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    print('RRRRR' + shop.rating.toString());
    return Material(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(border),
          bottomRight: Radius.circular(border)),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(border),
            bottomRight: Radius.circular(border)),
        child: Stack(
          fit: StackFit.expand,
          overflow: Overflow.visible,
          children: <Widget>[
            CachedNetworkImage(
                imageUrl: "${shop.coverPhoto}", fit: BoxFit.cover),
            Opacity(
                opacity: shrinkOffset / expandedHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider("${shop.profilePhoto}"),
                      radius: 50.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${shop.shopName}',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Sora',
                          ),
                        ),
                        Text(
                          '${shop.tagline}',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: white,
                          ),
                        ),
                        RatingBar(
                            initialRating: shop.rating,
                            itemSize: 15.0,
                            ignoreGestures: true,
                            itemCount: 5,
                            glow: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                              );
                            },
                            onRatingUpdate: (rating) {})
                      ],
                    )
                  ],
                )),
            Opacity(
                opacity: 1 - (shrinkOffset / expandedHeight),
                child: Container(
                  height: (1 - shrinkOffset / expandedHeight) * expandedHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider("${shop.profilePhoto}"),
                        radius: 50.0,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${shop.shopName}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.0,
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Sora',
                            ),
                          ),
                          Text(
                            '${shop.tagline}',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: white,
                            ),
                          ),
                          RatingBar(
                              initialRating: shop.rating,
                              itemSize: 22.0,
                              ignoreGestures: true,
                              itemCount: 5,
                              glow: true,
                              itemBuilder: (BuildContext context, int index) {
                                return Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                );
                              },
                              onRatingUpdate: (rating) {})
                        ],
                      )
                    ],
                  ),
                )),
            Positioned(
              top: (expandedHeight / 1 - shrinkOffset) - expandedHeight / 6,
              left: MediaQuery.of(context).size.width / 26,
              child: Opacity(
                opacity: (1 - shrinkOffset / expandedHeight),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.0),
                            blurRadius: 10.0)
                      ]),
                  child: SizedBox(
                    height: expandedHeight / 3,
                    width: 12 * MediaQuery.of(context).size.width / 13,
                    child: Column(children: <Widget>[
                      SizedBox(height: 10.0),
                      Text("Description",
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(height: 5.0),
                      SizedBox(
                        child: shop.bio.isEmpty
                            ? Text('No Description Provided')
                            : Text('${shop.bio}'),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
            Positioned(
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: white,
                    size: 40.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    print("suaysj");
                  }),
              top: 0,
              left: 0,
            ),
          ],
        ),
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
