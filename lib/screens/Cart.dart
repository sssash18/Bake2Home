import 'dart:async';
import 'dart:math';
import 'package:bake2home/functions/order.dart';
import 'package:bake2home/screens/Checkout.dart';
import 'package:bake2home/screens/NoInternet.dart';
import 'package:bake2home/screens/Noorders.dart';
import 'package:bake2home/screens/OrderPending.dart';
import 'package:bake2home/services/PushNotification.dart';
import 'package:bake2home/services/database.dart';
import 'package:bake2home/widgets/CartTile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  TimeOfDay startTime;
  TimeOfDay endTime;
  String _date, _time;
  List<DropdownMenuItem<String>> _addresses;
  DateTime delTime;
  String _selectedAddress;
  double subtotal;
  bool internetStatus;
  StreamSubscription<ConnectivityResult> subs;
  Connectivity _connectivity;
  ProgressDialog pr;
  double delCharges;
  double cakeQuantity;
  int cakeCount;
  final cartKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime = TimeOfDay(hour: 10, minute: 00);
    endTime = TimeOfDay(hour: 22, minute: 00);
    _addresses = [];
    delCharges = 0.0;
    cakeCount = 0;
    cakeQuantity = 0;
    subtotal = 0.0;
    internetStatus = true;
    _connectivity = Connectivity();
    currentUser.addresses.keys.forEach((element) {
      print(currentUser.addresses[element]['address']);
      _addresses.add(
        DropdownMenuItem(
          child: Text(currentUser.addresses[element]['address'].toString()),
          value: currentUser.addresses[element]['address'],
        ),
      );
      subs = _connectivity.onConnectivityChanged
          .listen((ConnectivityResult event) {
        setState(() {
          if (event == ConnectivityResult.none) {
            internetStatus = false;
          } else {
            internetStatus = true;
          }
        });
        _connectivity.checkConnectivity().then((value) {
          if (value == ConnectivityResult.none) {
            internetStatus = false;
          }
        });
      });
    });
    _addresses.forEach((element) {
      print('----------?${element.value}');
    });
    setState(() {
      _selectedAddress = _addresses.first.value;
    });
  }

  double calculateDeliveryCharges(double cakeQuantity) {
    if (cakeQuantity <= 2) {
      delCharges = delChargesList[0];
    } else {
      if (cakeQuantity > 2) {
        delCharges = delChargesList[1];
      }
      if (cakeQuantity > 2 && cakeCount == 2) {
        delCharges = delChargesList[2];
      }
      if (cakeCount > 2) {
        delCharges = delChargesList[3];
      }
    }
    return delCharges;
  }

  @override
  Widget build(BuildContext context) {
    print(cartMap.toString());
    bool status = Provider.of<bool>(context) ?? true;
    print(cartMap.toString());

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width - 20;
    Shop shop;
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            cartMap = Map.from(snapshot.data.data()['cart']);
            print(cartMap);
            delCharges = 0.0;
            cakeQuantity = 0;
            cakeCount = 0;
            subtotal = 0.0;
            delCharges = delChargesList.first;
            cartMap.keys
                .where((element) => element != cartMap['shopId'])
                .forEach((element) {
              if (element != 'shopId') {
                subtotal +=
                    cartMap[element]['price'] * cartMap[element]['quantity'];
                if (cartMap[element]['itemCategory'] == "cake") {
                  cakeQuantity +=
                      cartMap[element]['quantity'] * cartMap[element]['size'];
                  cakeCount += cartMap[element]['quantity'];
                }
                print("XCCC" + '$cakeQuantity');
              }
            });
            calculateDeliveryCharges(cakeQuantity);
            return internetStatus
                ? cartMap.isNotEmpty
                    ? Scaffold(
                        key: cartKey,
                        appBar: AppBar(
                            backgroundColor: white,
                            elevation: 0.0,
                            iconTheme: IconThemeData(color: base),
                            title: Text('Cart',
                                style: TextStyle(
                                  color: base,
                                ))),
                        body: status == true
                            ? Container(
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
                                          colors: [
                                            Color(0xffeaafc8),
                                            Color(0xff654ea3)
                                          ]),
                                      borderRadius:
                                          BorderRadius.circular(border),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Icon(
                                            Icons.shopping_cart,
                                            color: white,
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                20,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Expanded(
                                            // width: width * 0.9,
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    'Shopping Cart',
                                                    style: TextStyle(
                                                      color: white,
                                                      fontSize: head,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                      'Verify your quantities and proceed to checkout',
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
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  shop = shopMap[shopMap.keys
                                                      .firstWhere((element) =>
                                                          element ==
                                                          cartMap['shopId'])];

                                                  return CartTile(
                                                    item: cartMap[cartMap.keys
                                                        .where((element) =>
                                                            element != 'shopId')
                                                        .elementAt(index)],
                                                    shopName: shop.shopName,
                                                    vid: cartMap.keys
                                                        .where((element) =>
                                                            element != 'shopId')
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 5.0),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xffeaafc8),
                                                  Color(0xff654ea3)
                                                ]),
                                            borderRadius:
                                                BorderRadius.circular(border),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text('SubTotal',
                                                          style: TextStyle(
                                                              color: white,
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text('\u20B9 $subtotal',
                                                          style: TextStyle(
                                                              color: white,
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ]),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        'Delivery charges',
                                                        style: TextStyle(
                                                          color: white,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        '$delCharges',
                                                        style: TextStyle(
                                                          color: white,
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ]),
                                                Container(
                                                  child: ButtonTheme(
                                                    minWidth: double.infinity,
                                                    child: FlatButton(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      border)),
                                                      color: Colors.white,
                                                      textColor: base,
                                                      child: Text(
                                                          'Checkout (\u20B9 ${subtotal + delCharges})'),
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
                              )
                            : NoOrders(),
                      )
                    : Center(
                        child: Text("No Data"),
                      )
                : NoInternet();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  showBottomSheet(
      BuildContext context,
      DateTime delTime,
      String _date,
      String _time,
      String _selectedAddress,
      List<DropdownMenuItem<String>> _addresses,
      double subtotal,
      Shop shop) async {
    print(_selectedAddress);
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
                    if (date != null) {
                      setState(() {
                        delTime = date;
                        _date = DateFormat.yMMMd().format(date);
                        print(delTime);
                        print(_date);
                      });
                    }
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
                    TimeOfDay nowTime = TimeOfDay.now();
                    if (_date != null) {
                      TimeOfDay time = await showTimePicker(
                          context: context, initialTime: nowTime);
                      if (time != null) {
                        int timeInMinutes = time.hour * 60 + time.minute;
                        int nowInMinutes = nowTime.hour * 60 + nowTime.minute;
                        int startInMinutes =
                            startTime.hour * 60 + startTime.minute;
                        int endInMinutes = endTime.hour * 60 + endTime.minute;
                        if (timeInMinutes >= startInMinutes &&
                            timeInMinutes <= endInMinutes) {
                          if (delTime.day == DateTime.now().day &&
                              delTime.month == DateTime.now().month) {
                            if (timeInMinutes >= nowInMinutes) {
                              setState(() {
                                delTime =
                                    delTime.add(Duration(hours: time.hour));
                                delTime =
                                    delTime.add(Duration(minutes: time.minute));
                                _time = time.format(context);
                              });
                            } else {
                              showGenDialog(
                                  context, "Please select valid time");
                            }
                          } else {
                            setState(() {
                              delTime = delTime.add(Duration(hours: time.hour));
                              delTime =
                                  delTime.add(Duration(minutes: time.minute));
                              _time = time.format(context);
                            });
                          }
                        } else {
                          showGenDialog(context,
                              "We provide service only from 10am to 10 pm only!");
                        }
                      }
                    } else {
                      showGenDialog(context, "Please select date first");
                    }
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
                  pr = ProgressDialog(context,
                      type: ProgressDialogType.Normal,
                      isDismissible: true,
                      showLogs: true);
                  pr.style(
                      message: 'Preparing Your Order...',
                      borderRadius: 10.0,
                      backgroundColor: Colors.white,
                      progressWidget:
                          Center(child: CircularProgressIndicator()),
                      elevation: 10.0,
                      insetAnimCurve: Curves.easeInOut,
                      progress: 0.0,
                      maxProgress: 100.0,
                      progressTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          fontWeight: FontWeight.w400),
                      messageTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 19.0,
                          fontWeight: FontWeight.w600));

                  // print(delTime);
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
                      deliveryTime: Timestamp.fromDate(delTime),
                      deliveryAddress: _selectedAddress,
                      items: cartMap);
                  await pr.show();
                  bool rs = await DatabaseService().createOrder(order);
                  await pr.hide();
                  if (rs) {
                    await PushNotification().pushMessage('New Order Request',
                        'Request from ${currentUser.name}', shop.token);
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Checkout(order: order);
                    }));
                    Navigator.pop(context);
                  } else {
                    Navigator.pop(context);
                    showSnackBar(
                        cartKey, "Cannot Prepare Order... try again later");
                  }
                  // } else {
                  //   showGenDialog(context, "Please fill essential Details");
                  // }
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

  @override
  void dispose() {
    super.dispose();
    subs.cancel();
  }
}
