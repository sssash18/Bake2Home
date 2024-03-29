import 'package:bake2home/chatApp/screens/chatwithfriend.dart';
import 'package:bake2home/services/PushNotification.dart';
import 'package:bake2home/services/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/order.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryTile extends StatefulWidget {
  final Order order;
  final GlobalKey<ScaffoldState> historyKey;
  HistoryTile({this.order, this.historyKey});

  @override
  _HistoryTileState createState() => _HistoryTileState();
}

class _HistoryTileState extends State<HistoryTile> {
  ProgressDialog pr;

   Widget routeButton(double width,String address) {
    return InkWell(
      onTap: () async{
        double lat,longi;
        pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
        pr.style(
        message: 'Locating on Map...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Center(child: CircularProgressIndicator()),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
        await pr.show();
        await Geolocator().placemarkFromAddress(address).then((value){
          lat = value.first.position.latitude;
          longi = value.first.position.longitude;
          String url = "https://maps.google.com/?q=${lat},${longi}";
          launch(url).then((value)  => pr.hide()).catchError((e) async{
            await pr.hide();
          });
        }).catchError((e)async{ await pr.hide();});
      },
      child: Container(
          height: width * 0.08,
          width: width * 0.25,
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.location_on,
                color: white,
              ),
              Text("Route", style: TextStyle(color: white)),
            ],
          )),
    );
  }


  Widget chatButton(double width) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatWithFriend(
            order: this.widget.order,
          );
        }));
      },
      child: Container(
          height: width * 0.08,
          width: width * 0.25,
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            color: base,
            borderRadius: BorderRadius.circular(border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.message,
                color: white,
              ),
              Text("Chat", style: TextStyle(color: white)),
            ],
          )),
    );
  }

  Widget _cancelButton(width) {
    return InkWell(
      onTap: () async {
        double refundAmount =
            await DatabaseService().getRefundAmount(this.widget.order);
        if(DateTime.now().hour < 10 || DateTime.now().hour > 21){
          showGenDialog(context, "Cancellation of Orders is allowed only between 10 AM and 10 PM");
        }else{
          bool rs = await genDialog(
            context,
            "Are you sure to cancel the order \n Amount to be refunded is\n \u20B9 ${refundAmount.round()}",
            "Yes",
            "No");
            if (rs) {
              await pr.show();
              await DatabaseService().cancelOrder(widget.order).then((value) async {
                await pr.hide();
                showSnackBar(this.widget.historyKey, "Order cancelled ..");
              }).catchError((e) async {
                await pr.hide();
                showSnackBar(this.widget.historyKey, "Cannot cancel order ..");
                print(e.toString());
              });
            }
        }

      },
      child: Container(
          height: width * 0.08,
          width: width * 0.25,
          padding: EdgeInsets.symmetric(horizontal: 2.0),
          decoration: BoxDecoration(
            color: Colors.red[700],
            borderRadius: BorderRadius.circular(border),
          ),
          child: Row(
            children: [
              Icon(
                Icons.cancel,
                color: white,
              ),
              Text("Cancel", style: TextStyle(color: white)),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 30;
    double height = MediaQuery.of(context).size.height;
    pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    pr.style(
        message: 'Cancelling order....',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: Center(child: CircularProgressIndicator()),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));

    Shop shop = shopMap[shopMap.keys
        .where((element) => shopMap[element].shopId == widget.order.shopId)
        .elementAt(0)];
    String itemList = "";
    widget.order.items.keys
        .where((element) => element != 'shopId')
        .forEach((element) {
      itemList +=
          '${widget.order.items[element]['quantity']} X ${widget.order.items[element]['itemName']}, ';
    });
    Color _decisionColor;
    switch (widget.order.status) {
      case "PENDING":
        _decisionColor = Colors.amber[400];
        break;
      case "ACCEPTED":
        _decisionColor = Colors.blue;
        break;
      case "COMPLETED":
        _decisionColor = Colors.green[300];
        break;
      case "PAID":
        _decisionColor = Colors.green[400];
        break;
      case "MISSED":
        _decisionColor = Colors.teal;
        break;
      case "CANCELLED":
        _decisionColor = Colors.red;
        break;
      case "REJECTED":
        _decisionColor = Colors.teal;
        break;
    }
    return Container(
      width: width,
      height: width* (widget.order.pickUp==true ? 1.1 : 0.8 ),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          shopDetails(width, shop),
          itemDetails(width, _decisionColor, itemList),
        ],
      ),
    );
  }

  Container itemDetails(double width, Color _decisionColor, String itemList) {
    return Container(
        height: width * (widget.order.pickUp==true ?0.85 : 0.55),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(border),
              bottomLeft: Radius.circular(border)),
          color: Colors.grey[300],
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: width * 0.08,
                  width: width * 0.25,
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  decoration: BoxDecoration(
                    color: _decisionColor,
                    borderRadius: BorderRadius.circular(border),
                  ),
                  alignment: Alignment.center,
                  child: Text(widget.order.status ?? "",
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: white)),
                ),
                (widget.order.status == "PAID" )
                    ? chatButton(width)
                    : SizedBox.shrink(),
                (widget.order.status == "PAID" )
                    ? _cancelButton(width)
                    : Text(""),
                
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ITEMS",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    itemList,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "ORDERED ON",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    readTimestamp(widget.order.orderTime),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "DELIVERY ON",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(readTimestamp(widget.order.deliveryTime)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "AMOUNT",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\u20B9 ${widget.order.amount.toInt()}',
                  ),
                ),
              ],
            ),
            widget.order.status=="CANCELLED" ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "REFUND AMOUNT",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\u20B9 ${widget.order.refund.toInt()}',
                  ),
                ),
              ],
            ):Container(),

            widget.order.status=="PAID" ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "OTP",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${widget.order.otp}',
                  ),
                ),
              ],
            ):Container(),
            widget.order.status=="PAID" ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "COD (To Pay)",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '\u20B9 ${widget.order.codAmount.toInt()}',
                  ),
                ),
              ],
            ) : Container(),
            (widget.order.pickUp==true && widget.order.status=="PAID") ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "PickUp Address",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${shopMap[widget.order.shopId].shopAddress}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ) : Container(),
            (widget.order.status=="PAID" && (widget.order.pickUp==true)) ?
              routeButton(width, shopMap[widget.order.shopId].shopAddress):
              Text("")
          ],
        ));
  }

  Container shopDetails(double width, Shop shop) {
    return Container(
      height: width * 0.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(border),
              topLeft: Radius.circular(border)),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xffeaafc8), Color(0xff654ea3)])),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width * 0.2,
            height: width * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(border),
            ),
            child: ClipRRect(
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(border)),
                child: CachedNetworkImage(
                    imageUrl: shop.profilePhoto,
                    placeholder: (context, url) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    fit: BoxFit.fill)),
          ),
          Container(
            width: width * 0.8,
            height: width * 0.2,
            padding: EdgeInsets.only(right: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('#'+widget.order.orderId,
                    style: TextStyle(
                      fontSize: head,
                      color: white,
                    )),
                Text(shop.shopName,
                    style: TextStyle(
                      fontSize: head,
                      color: white,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
