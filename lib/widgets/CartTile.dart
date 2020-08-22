import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

class CartTile extends StatelessWidget {

  Map item;
  CartTile({this.item});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      height: 90.0,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(border),
        boxShadow: [BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0),
            blurRadius: 3.0
        )]
      ),
      
      child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(110.0, 0.0, 0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: Text(
                    item['itemName'],
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                    child: Text(
                    'by The Bakery',
                    style: TextStyle(
                      fontSize: 10.0
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                    child: Text(
                    item['price'].toString(),
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            )
          ),
          Container(
            height: 90.0,
            width: 90.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(border),
              image: DecorationImage(
                image: AssetImage("assets/images/cookie.jpeg"),
                fit: BoxFit.fill
              )
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 8, 20, 0),
            alignment: Alignment.centerRight,
            height: 90.0,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.add_circle_outline,
                  color: base,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                  child: Text("2")
                ),
                Icon(
                  Icons.remove_circle_outline,
                  color: base,
                ),
              ]
            ),
          )

        ]
      ),
      
    );
  }
}