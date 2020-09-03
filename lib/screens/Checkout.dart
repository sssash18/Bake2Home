import 'dart:async';
import 'package:bake2home/services/database.dart';
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
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp> apps;
  UpiResponse _response;
  @override
  void initState() {
    super.initState();
    _upiIndia.getAllUpiApps().then((value){
      setState((){
        apps = value;
      });
    });
    
  }

  Future<UpiResponse> initiateTransaction(String app) {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: 'pmcares@sbi',
      receiverName: "BakeMyCake",
      transactionRefId: "1233434",
      transactionNote: '#bmc2323111',
      amount: 1.0,
    );
  }
  StreamSubscription subs;
  @override
  Widget build(BuildContext context) {
    if(count==0){
       controller.stream.listen((event) { 
        setState(() {
          _index++;
        });
      });
      count++;
    }else{
      //subs.cancel();
    }
    return Scaffold(
          body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
              borderRadius: BorderRadius.circular(border),
            ),
              child: Stepper(
              currentStep: _index,
              controlsBuilder: (BuildContext context,{VoidCallback onStepContinue,VoidCallback onStepCancel}){
                if(_index==1){
                  return FlatButton(
                    child: Text("Next"),
                    onPressed: (){
                      setState(() {
                        _index++;
                      });
                    },
                  );
                }
                return Container();
              },
              onStepContinue: (){
                setState(() {
                  _index++;
                });
              },
              
              steps: [
                Step(
                  title: Text("Requesting Vendor",style: TextStyle(color:white,fontWeight: FontWeight.bold,fontSize: 15)),
                  subtitle: Text('Requesting vendor with the required items',style: TextStyle(color:white,),),
                  content: OrderPending(),
                  isActive:  _index==1 ? true : false,
                  state: _index<=0 ? StepState.indexed : StepState.complete
                ),
                Step(
                  title: Text("Vendor Response",style: TextStyle(color:white,fontWeight: FontWeight.bold,fontSize: 15)),
                  subtitle: Text('Vendor Response for the requirements',style: TextStyle(color:white,)),
                  content: Text("Phone Aaya"),
                  isActive: _index==1 ? true : false,
                  state: _index<=1 ? StepState.indexed : StepState.complete
                ),
                Step(
                  title: Text("Payment",style: TextStyle(color:white,fontWeight: FontWeight.bold,fontSize: 15)),
                  state: _index<=2 ? StepState.indexed : StepState.complete,
                  subtitle: Text('Only UPI payments are accepted currently',style: TextStyle(color:white,)),
                  content:  Container(
                      height: MediaQuery.of(context).size.height/3,
                      child: ListView.builder(
                      itemCount: (apps ?? []).length,
                      itemBuilder: (BuildContext context,int index){
                        return Container(
                          margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/20, MediaQuery.of(context).size.height/40, MediaQuery.of(context).size.width/20, 0),
                          child: FlatButton(
                            child: Text(apps[index].name,style: TextStyle(color:base),),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(border)),
                            color: white,
                            onPressed: () async{
                              _response = await initiateTransaction(apps[index].app);
                              if(_response.error != null){
                                showDialog(context :context,child: 
                                  AlertDialog(
                                    title: Text("Payment Failed!"),
                                    content: Text('Payment Fail Try Again'),
                                    actions: [
                                      FlatButton(
                                        child: Text("OK"),
                                        onPressed: (){
                                          Navigator.pop(context);
                                          setState(() {
                                            _index++;
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  isActive: _index==2 ? true : false,
                ),
                Step(
                  title: Text("Order Placed Successfully")  , 
                  content: FlatButton.icon(
                    onPressed: (){
                      DatabaseService(uid: currentUserID).emptyCart();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    shape: RoundedRectangleBorder(borderRadius : BorderRadius.circular(border)),
                    color: white,
                    icon: Icon(Icons.done), 
                    label: Text("Finish"),
                  ),
                  state: _index<3 ? StepState.indexed : StepState.complete
                )
              ],
            ),
          ),
    );
  }
}