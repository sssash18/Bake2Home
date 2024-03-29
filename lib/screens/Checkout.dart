import 'dart:async';
import 'package:bake2home/services/PushNotification.dart';
import 'package:bake2home/services/database.dart';
import 'package:bake2home/widgets/FinalAmount.dart';
import 'package:bake2home/widgets/OrdersList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:upi_india/upi_india.dart';
import 'package:bake2home/screens/OrderPending.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/Payment.dart';
import 'package:bake2home/functions/order.dart';

class Checkout extends StatefulWidget {
  final Order order;
  Checkout({this.order});
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int _index = 0;
  int count = 0;
  String _selectedOption;

  double codAmount = 0;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;
  List<DropdownMenuItem<String>> paymentOptions;
  ProgressDialog pr;
  StreamSubscription subs;
  UpiResponse _response;
  double finalPrice = 0.0;
  @override
  void initState() {
    super.initState();

    _selectedOption = "full";
    _upiIndia.getAllUpiApps().then((value) {
      setState(() {
        apps = value;
      });
    });
    createStream();
  }

  // callBackToPrice(double pr) {
  //   setState(() {
  //     finalPrice = pr;
  //   });
  // }

  createStream() {
    if (count == 0) {
      subs = controller.stream.listen((event) async {
        if (!event.contains("MISSED")) {
          if (event.contains("REJECTED")) {
            List<String> s = event.split('-');
            bool v = await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                      title: Text("Alert"),
                      content: Text(
                          'Sorry your order was denied by the baker. Please try again later \n Reason : ${s[1]} '),
                      actions: [
                        RaisedButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          color: base,
                          child: Text("Ok", style: TextStyle(color: white)),
                        )
                      ]);
                });
            subs.cancel();
            Navigator.pop(context);
          } else if (!event.contains("PENDING")) {
            setState(() {
              _index = 1;
              subs.cancel();
            });
          }
        } else {
          subs.cancel();
          bool ss = await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                    title: Text("Alert"),
                    content: Text(
                        'Sorry we were not able to contact ${shopMap[widget.order.shopId].shopName} . Please try again later'),
                    actions: [
                      RaisedButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        color: base,
                        child: Text("Ok", style: TextStyle(color: white)),
                      )
                    ]);
              });
          pr = ProgressDialog(context,
              type: ProgressDialogType.Normal,
              isDismissible: true,
              showLogs: true);
          pr.style(
              message: 'Updating order....',
              borderRadius: 10.0,
              backgroundColor: Colors.white,
              progressWidget: Center(child: CircularProgressIndicator()),
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
          if (ss) {
            await pr.show();
            bool rs = await DatabaseService()
                .missOrderUpdate(this.widget.order.orderId);
            await pr.hide();
            if (rs) {
            } else {
              showSnackBar(checkoutKey, "Error Encountered");
            }

            Navigator.pop(context);
          }
        }
      });
      count++;
    } else {
      //subs.cancel();
    }

    String _selectedOption = "full";
    paymentOptions = [
      DropdownMenuItem(
          value: "full",
          child: Text(
            "Full Payment(\u20B9 ${widget.order.amount.toInt()})",
          )),
      DropdownMenuItem(
          value: "partial",
          child: Text(
              "Partial COD(\u20B9 ${((100 - shopMap[widget.order.shopId].advance) * widget.order.amount / 100).toInt()})"))
    ];
    if (_selectedOption == "full") {
      codAmount = 0;
    } else {
      codAmount =
          ((100 - shopMap[widget.order.shopId].advance) * widget.order.amount);
    }
  }

  Future<UpiResponse> initiateTransaction(
      double amount, String orderId, String app) {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: 'bakemycake@ybl',
      receiverName: "BakeMyCake",
      transactionRefId: orderId,
      transactionNote: '${orderId}',
      amount: amount.ceilToDouble(),
    );
  }

  final checkoutKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool rs = await genDialog(
            context,
            "Pressing back would automatically cancel the order..please wait in order to proceed",
            "Leave",
            "Stay");
        if (rs) {
          pr = ProgressDialog(context,
              type: ProgressDialogType.Normal,
              isDismissible: true,
              showLogs: true);
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
                  color: Colors.black,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400),
              messageTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 19.0,
                  fontWeight: FontWeight.w600));
          await pr.show();
          print('********************************${widget.order.amount}');
          print('********************************${widget.order.codAmount}');
          await DatabaseService().cancelOrder(widget.order).then((value) async {
            await pr.hide();
            showSnackBar(checkoutKey, "Order cancelled ..");
            await Future.delayed(Duration(seconds: 1));
          }).catchError((e) async {
            await pr.hide();
            showSnackBar(checkoutKey, "Cannot cancel order ..");
            print(e.toString());
            await Future.delayed(Duration(seconds: 1));
          });
          Navigator.pop(context);
          return Future.value(true);
        }
      },
      child: Scaffold(
        key: checkoutKey,
        body: StreamProvider<List<Order>>.value(
          catchError: (context, error) {
            print(
                '------------------------>${widget.order.orderId}  ${error.toString()}');
          },
          value: DatabaseService().orderUpdate(widget.order.orderId),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
            ),
            child: Stepper(
              currentStep: _index,
              controlsBuilder: (BuildContext context,
                  {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                if (_index == 1) {
                  return FlatButton(
                    color: base,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(border)),
                    child: Text(
                      "Next",
                      style: TextStyle(color: white, fontSize: 16),
                    ),
                    onPressed: () {
                      setState(() {
                        _index++;
                      });
                    },
                  );
                }
                return Container();
              },
              onStepContinue: () {
                setState(() {
                  _index++;
                });
              },
              steps: [
                Step(
                    title: Text("Requesting Vendor",
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    subtitle: Text(
                      'Requesting vendor with the required items',
                      style: TextStyle(
                        color: white,
                      ),
                    ),
                    content: OrderPending(),
                    isActive: _index == 1 ? true : false,
                    state:
                        _index <= 0 ? StepState.indexed : StepState.complete),
                Step(
                    title: Text("Vendor Response",
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    subtitle: Text('Vendor Response for the requirements',
                        style: TextStyle(
                          color: white,
                        )),
                    content: FinalAmount(myOrder: widget.order),
                    isActive: _index == 1 ? true : false,
                    state:
                        _index <= 1 ? StepState.indexed : StepState.complete),
                Step(
                  title: Text("Payment",
                      style: TextStyle(
                          color: white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  state: _index <= 2 ? StepState.indexed : StepState.complete,
                  subtitle: Text('Only UPI payments are accepted currently',
                      style: TextStyle(
                        color: white,
                      )),
                  content: Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: black),
                                borderRadius: BorderRadius.circular(10.0)),
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: paymentDropdown(),
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: (apps ?? []).length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 50,
                                  margin: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width / 20,
                                      MediaQuery.of(context).size.height / 40,
                                      MediaQuery.of(context).size.width / 20,
                                      0),
                                  child: FlatButton(
                                    child: Text(
                                      apps[index].name,
                                      style: TextStyle(color: base),
                                    ),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(border)),
                                    color: white,
                                    onPressed: () async {
                                      _response = await initiateTransaction(
                                          widget.order.amount - codAmount,
                                          widget.order.orderId,
                                          apps[index].app);

                                      if (_response.error != null) {
                                        showDialog(
                                            context: context,
                                            child: AlertDialog(
                                              title: Text("Payment Failed!"),
                                              content: Text(
                                                  'Payment Fail Try Again'),
                                              actions: [
                                                FlatButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ));
                                      } else {
                                        if (_response.status ==
                                            UpiPaymentStatus.SUCCESS) {
                                          setState(() {
                                            _index++;
                                          });
                                          DatabaseService().updateTransaction(
                                              widget.order,
                                              _response,
                                              codAmount);
                                        }
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                  ),
                  isActive: _index == 2 ? true : false,
                ),
                Step(
                    title: Text("Order Placed Successfully",
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    content: FlatButton.icon(
                      onPressed: () async {
                        ProgressDialog pr2 = ProgressDialog(context,
                            type: ProgressDialogType.Normal,
                            isDismissible: true,
                            showLogs: true);
                        pr.style(
                            message: 'Finishing order....',
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
                        await pr2.show();
                        await emptyCart();
                        await pushNotification
                            .pushMessagewithNewOrder(
                                "New Order", '', deliveryToken, '123')
                            .catchError((e) async {
                          await pr2.hide();
                        });
                        Navigator.pop(context);
                        await pushNotification
                            .pushMessage(
                                "Order Placed Successfully",
                                'Order Id : ${widget.order.orderId}',
                                shopMap[widget.order.shopId].token)
                            .catchError((e) async {
                          await pr2.hide();
                        });
                        await pr2.hide();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(border)),
                      color: white,
                      icon: Icon(Icons.done),
                      label: Text("Finish"),
                    ),
                    state: _index < 3 ? StepState.indexed : StepState.complete)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> emptyCart() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser.uid)
        .update({'cart': {}});
    currentShopId = 'null';
    cartMap.clear();
  }

  DropdownButtonHideUnderline paymentDropdown() {
    paymentOptions = [
      DropdownMenuItem<String>(
          value: "full",
          child: Text(
            "Full Payment(\u20B9 ${widget.order.amount.truncate()})",
          )),
      DropdownMenuItem<String>(
          value: "partial",
          child: Text(
              "Partial COD(Now \u20B9 ${((shopMap[widget.order.shopId].advance) * widget.order.amount / 100).truncate()})"))
    ];
    return DropdownButtonHideUnderline(
      child: DropdownButton(
          value: _selectedOption,
          items: paymentOptions,
          onChanged: (val) {
            setState(() {
              _selectedOption = val;
              if (_selectedOption == "full") {
                codAmount = 0;
              } else {
                codAmount =
                    ((100 - shopMap[widget.order.shopId].advance) / 100) *
                        widget.order.amount;
              }
            });
            print(_selectedOption);
          }),
    );
  }
}
