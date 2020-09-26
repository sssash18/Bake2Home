import 'dart:async';
import 'package:bake2home/services/PushNotification.dart';
import 'package:bake2home/services/database.dart';
import 'package:bake2home/widgets/FinalAmount.dart';
import 'package:http/http.dart';
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
  double codAmount = 0;
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;

  UpiResponse _response;
  @override
  void initState() {
    super.initState();
    _upiIndia.getAllUpiApps().then((value) {
      setState(() {
        apps = value;
      });
    });
  }

  Future<UpiResponse> initiateTransaction(String app) {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: 'suyashchoudhary42@oksbi',
      receiverName: "BakeMyCake",
      transactionRefId: "1233434",
      transactionNote: '#bmc2323111',
      amount: 1.0,
    );
  }

  StreamSubscription subs;
  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      controller.stream.listen((event) {
        setState(() {
          _index++;
        });
      });
      count++;
    } else {
      //subs.cancel();
    }
    String _selectedOption = "full";
    List<DropdownMenuItem> paymentOptions = [
      DropdownMenuItem(
          value: "full",
          child: Text(
            "Full Payment(\u20B9 ${widget.order.amount})",
          )),
      DropdownMenuItem(
          value: "partial",
          child: Text(
              "Partial COD(\u20B9 ${(100 - shopMap[widget.order.shopId].advance) * widget.order.amount / 100})"))
    ];
    if (_selectedOption == "full") {
      codAmount = 0;
    } else {
      codAmount =
          (100 - shopMap[widget.order.shopId].advance) * widget.order.amount;
    }
    return Scaffold(
      body: StreamProvider.value(
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
                  child: Text("Next"),
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
                  state: _index <= 0 ? StepState.indexed : StepState.complete),
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
                  content: FinalAmount(),
                  isActive: _index == 1 ? true : false,
                  state: _index <= 1 ? StepState.indexed : StepState.complete),
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
                  height: MediaQuery.of(context).size.height / 2.8,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 4,
                    child: Column(children: [
                      DropdownButton(
                          value: _selectedOption,
                          items: paymentOptions,
                          onChanged: (val) {
                            setState(() {
                              _selectedOption = val;
                            });
                          }),
                      Container(
                        height: MediaQuery.of(context).size.height / 3.5,
                        child: ListView.builder(
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
                                      apps[index].app);

                                  if (_response.error != null) {
                                    showDialog(
                                        context: context,
                                        child: AlertDialog(
                                          title: Text("Payment Failed!"),
                                          content:
                                              Text('Payment Fail Try Again'),
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
                                          widget.order, _response, codAmount);
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
                      DatabaseService(uid: currentUserID).emptyCart();

                      Navigator.pop(context);
                      Navigator.pop(context);
                      PushNotification().pushMessage(
                          "Order Placed Successfully",
                          'Order Id : ${widget.order.orderId}',
                          shopMap[widget.order.shopId].token);
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
    );
  }
}
