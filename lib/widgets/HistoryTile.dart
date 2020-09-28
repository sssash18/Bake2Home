import 'package:bake2home/services/PushNotification.dart';
import 'package:bake2home/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/order.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class HistoryTile extends StatefulWidget {
  final Order order;
  HistoryTile({this.order});

  @override
  _HistoryTileState createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {


  Widget _cancelButton(){
    return FlatButton.icon(
      onPressed: (){
        DatabaseService().cancelOrder(widget.order).then((value){
        });
        
      },
      color: Colors.red[700],
      icon: Icon(Icons.cancel), 
      shape: RoundedRectangleBorder(
        borderRadius : BorderRadius.circular(border),
      ),
      label: Text("Cancel"));
  }

  @override
  Widget build(BuildContext context) {
    
    Shop shop  = shopMap[shopMap.keys.where((element) => shopMap[element].shopId == widget.order.shopId).elementAt(0)];
    String itemList="";
    widget.order.items.keys.where((element) => element!='shopId').forEach((element) { 
      itemList += '${widget.order.items[element]['quantity']} X ${widget.order.items[element]['itemName']}, ';
    });
    Color _decisionColor;
    switch (widget.order.status) {
      case "PENDING" : _decisionColor = Colors.amber[400];
        break;
      case "ACCEPTED" : _decisionColor = Colors.blue;
      break;
      case "COMPLETED" : _decisionColor = Colors.green;
      break;
      case "CANCELLED" : _decisionColor = Colors.red;
      break;
    }
    return Stack(
          children: [
            Container(
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
                  borderRadius: BorderRadius.circular(border),
                        gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffeaafc8),
                          Color(0xff654ea3)
                      ])
                ),
                child: Stack(
                children: <Widget>[
                  Container(
                    height: 70.0,
                    width : 70.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(border),
                        gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffeaafc8),
                          Color(0xff654ea3)
                      ]),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(shop.profilePhoto),
                          fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 70.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(border),
                        gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffeaafc8),
                          Color(0xff654ea3)
                      ])),
                    margin: EdgeInsets.fromLTRB(70.0,0.0, 0.0, 0.0),
                    child: Text(
                      shop.shopName,
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
                     itemList,
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
                      widget.order.orderTime.toDate().toString(),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "DELIVERY ON",
                      style: TextStyle(
                        color: Colors.grey[700]
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.order.deliveryTime.toDate().toString()
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "AMOUNT" ,
                      style: TextStyle(
                        color: Colors.grey[700]
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                    '\u20B9 ${widget.order.amount}' ,
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "OTP" ,
                      style: TextStyle(
                        color: Colors.grey[700]
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                    '${widget.order.otp}' ,
                    ),
                  ),
                ],

              ),
            )
          ]
        ),
      ),
      Positioned(
        right: MediaQuery.of(context).size.width/10,
        top: MediaQuery.of(context).size.height/7,
        child: Container(
          height:MediaQuery.of(context).size.height/35,
          width: MediaQuery.of(context).size.width/5,
          decoration: BoxDecoration(
            color: _decisionColor,
            borderRadius: BorderRadius.circular(border),
          ),
          alignment: Alignment.center,
          child: Text(widget.order.status ?? "",style: TextStyle(fontSize:10.0,fontWeight: FontWeight.bold)),
        ),
      ),
      Positioned(
        right: MediaQuery.of(context).size.width/10,
        bottom: MediaQuery.of(context).size.height/70,
        child: Container(
          alignment: Alignment.center,
          child: (widget.order.status == "PENDING" || widget.order.status == "ACCEPTED") ? _cancelButton() : Text(""),
        ),
      ),
      
      ],
    );
  }
}