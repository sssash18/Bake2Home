import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';


class HistoryTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey[300],
        boxShadow: [BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 6.0
        )]
      ),
      margin: EdgeInsets.fromLTRB(15.0, 15.0,15.0,0.0),
      child: Column(
        children: <Widget> [
          Container(
              margin: EdgeInsets.fromLTRB(0.0,0.0, 0.0, 0.0),
              decoration: BoxDecoration(
                color: base,
                borderRadius: BorderRadius.circular(20.0)
              ),
              child: Stack(
              children: <Widget>[
                Container(
                  height: 70.0,
                  width : 70.0,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(border),
                    image: DecorationImage(
                        image: AssetImage("assets/images/cookie.jpeg"),
                        fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: base,
                    borderRadius: BorderRadius.circular(border),
                  ),
                  margin: EdgeInsets.fromLTRB(70.0,0.0, 0.0, 0.0),
                  child: Text(
                    'The Bakery',
                    style : TextStyle(
                      fontSize: head,
                      color: white,
                    )
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 200.0,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ITEMS",
                    style: TextStyle(
                      color: Colors.grey[700]
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "1 x Red Velvet Cake, 2 x Choco Delight, 1 x Cookies",
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ORDERED ON",
                    style: TextStyle(
                      color: Colors.grey[700]
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "August 2 2020 at 3:05 PM",
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "AMOUNT",
                    style: TextStyle(
                      color: Colors.grey[700]
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Rs. 860",
                  ),
                ),
              ],

            ),
          )
        ]
      ),
    );
  }
}