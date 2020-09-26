import 'dart:math';
import 'package:bake2home/functions/order.dart';
import 'package:bake2home/screens/Checkout.dart';
// import 'package:bake2home/screens/Noorders.dart';
import 'package:bake2home/screens/OrderPending.dart';
import 'package:bake2home/services/PushNotification.dart';
import 'package:bake2home/services/database.dart';
import 'package:bake2home/widgets/CartTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    bool status = Provider.of<bool>(context) ?? true;
    print(cartMap.toString());
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width - 20;
    double subtotal = 0;
    Shop shop;
    String _date, _time;
    Timestamp delTime;
    cartMap.keys
        .where((element) => element != cartMap['shopId'])
        .forEach((element) {
      if (element != 'shopId') {
        subtotal += cartMap[element]['price'] * cartMap[element]['quantity'];
      }
    });
    print("SSSSSSSSSSS");
    print(shopMap.toString());

    List<DropdownMenuItem<String>> _addresses = [];
    currentUser.addresses.keys.forEach((element) {
      _addresses.add(
        DropdownMenuItem(
          child: Text(currentUser.addresses[element]['address'].toString()),
          value: currentUser.addresses[element]['address'],
        ),
      );
    });
    String _selectedAddress = _addresses.first.value;
    print(currentUser.addresses[currentUser.addresses.keys.elementAt(0)]
        ['address']);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: white,
          elevation: 0.0,
          iconTheme: IconThemeData(color: base),
          title: Text('Cart',
              style: TextStyle(
                color: base,
              ))),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(children: <Widget>[
          Container(
            height: height * 0.15,
            width: width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
              borderRadius: BorderRadius.circular(border),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.shopping_cart,
                    color: white,
                    size: MediaQuery.of(context).size.height / 20,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    // width: width * 0.9,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Shopping Cart',
                            style: TextStyle(
                              color: white,
                              fontSize: head,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Verify your quantities and proceed to checkout',
                              style: TextStyle(
                                color: white,
                              ))
                        ]),
                  ),
                ]),
          ),
          (cartMap != null && cartMap.isNotEmpty)
              ? Expanded(
                  child: Container(
                    width: double.infinity,
                    color: white,
                    child: ListView.builder(
                        itemCount: cartMap.length - 1,
                        itemBuilder: (BuildContext context, int index) {
                          shop = shopMap[shopMap.keys.firstWhere(
                              (element) => element == cartMap['shopId'])];

                          return CartTile(
                            item: cartMap[cartMap.keys
                                .where((element) => element != 'shopId')
                                .elementAt(index)],
                            shopName: shop.shopName,
                            vid: cartMap.keys
                                .where((element) => element != 'shopId')
                                .elementAt(index),
                          );
                        }),
                  ),
                )
              : Expanded(child: Container()),
          (cartMap != null && cartMap.isNotEmpty)
              ? Container(
                  height: height * 0.16,
                  width: width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
                    borderRadius: BorderRadius.circular(border),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('SubTotal',
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              Text('\u20B9 $subtotal',
                                  style: TextStyle(
                                      color: white,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Delivery charges',
                                style: TextStyle(
                                  color: white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rs 50',
                                style: TextStyle(
                                  color: white,
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ]),
                        Container(
                          child: ButtonTheme(
                            minWidth: double.infinity,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(border)),
                              color: Colors.white,
                              textColor: base,
                              child: Text('Checkout (\u20B9 $subtotal)'),
                              onPressed: () async {
                                await showBottomSheet(
                                    context,
                                    delTime,
                                    _date,
                                    _time,
                                    _selectedAddress,
                                    _addresses,
                                    subtotal,
                                    shop);
                              },
                            ),
                          ),
                        )
                      ]),
                )
              : SizedBox.shrink()
        ]),
      ),
    );
  }

  showBottomSheet(
      BuildContext context,
      Timestamp delTime,
      String _date,
      String _time,
      String _selectedAddress,
      List<DropdownMenuItem<String>> _addresses,
      double subtotal,
      Shop shop) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return Column(children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 20,
              ),
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 40),
                child: Text(
                  "Choose the Delivery Date\n and Time",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: head),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              FlatButton.icon(
                  onPressed: () async {
                    DateTime date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 12)));
                    setState(() {
                      delTime = Timestamp.fromDate(date);
                      _date = DateFormat.yMMMd().format(date);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(border),
                  ),
                  color: base,
                  icon: Icon(Icons.date_range, color: white),
                  label: Text(
                    _date ?? "Choose the date",
                    style: TextStyle(color: white),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              FlatButton.icon(
                  onPressed: () async {
                    TimeOfDay time = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    setState(() {
                      delTime.toDate().add(Duration(hours: time.hour));
                      delTime.toDate().add(Duration(minutes: time.minute));
                      _time = time.format(context);
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(border),
                  ),
                  color: base,
                  icon: Icon(Icons.date_range, color: white),
                  label: Text(
                    _time ?? "Choose the time",
                    style: TextStyle(color: white),
                  )),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              DropdownButton(
                  value: _selectedAddress,
                  items: _addresses,
                  onChanged: (val) {
                    setState(() {
                      _selectedAddress = val;
                    });
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height / 40,
              ),
              FlatButton.icon(
                color: base,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(border),
                ),
                onPressed: () async {
                  int _otp = Random().nextInt(9999);
                  while (_otp < 1000) {
                    _otp *= 10;
                  }
                  Order order = Order(
                      userId: currentUserID,
                      shopId: currentShopId,
                      status: "PENDING",
                      otp: _otp,
                      paymentType: "UPI",
                      amount: subtotal + 50,
                      delCharges: 50,
                      pickUp: false,
                      orderTime: Timestamp.now(),
                      deliveryTime: delTime,
                      deliveryAddress: _selectedAddress,
                      items: cartMap);
                  DatabaseService().createOrder(order);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Checkout(order: order);
                  }));
                  PushNotification().pushMessage('New Order Request',
                      'Request from ${currentUser.name}', shop.token);
                },
                icon: Icon(
                  Icons.done,
                  color: white,
                ),
                label: Text('Confirm', style: TextStyle(color: white)),
              )
            ]);
          });
        });
  }
}
