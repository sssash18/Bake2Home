import 'dart:math';
import 'package:bake2home/functions/order.dart';
import 'package:bake2home/screens/Checkout.dart';
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


class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    print(cartMap.toString());
    double subtotal  = 0;
    Shop shop;
    String _date,_time;
    Timestamp delTime;
    double cakeQuantity = 0,cakeCount = 0;
    double delCharges = delChargesList.first;
    cartMap.keys.where((element) => element!=cartMap['shopId']).forEach((element) { 
      if(element!='shopId'){
        subtotal += cartMap[element]['price'] * cartMap[element]['quantity'];
        if(cartMap[element]['itemCategory']=="cake"){
          cakeQuantity += cartMap[element]['quantity'] * cartMap[element]['size'] ;
          cakeCount += cartMap[element]['quantity'];
        }
        print("XCCC" + '${cakeQuantity}');
      }
    });

    void calculateDeliveryCharges(double cakeQuantity){
      if(cakeQuantity <= 2){
        delCharges = delChargesList[0];
      }else{
        if(cakeQuantity > 2 ){
          delCharges = delChargesList[1];
        }
        if(cakeQuantity > 2 && cakeCount == 2){
          delCharges = delChargesList[2];
        }
        if(cakeCount > 2){
          delCharges = delChargesList[3];
        }
      }
    }
    calculateDeliveryCharges(cakeQuantity);
    print("SSSSSSSSSSS");
    print(shopMap.toString());
    
    List<DropdownMenuItem<String>> _addresses=[];
    currentUser.addresses.keys.forEach((element) { 
      _addresses.add(
        DropdownMenuItem(
          child: Text(currentUser.addresses[element]['address'].toString()),
          value : currentUser.addresses[element]['address'],
        ),
      );
    });
    String _selectedAddress = _addresses.first.value;
    print(currentUser.addresses[currentUser.addresses.keys.elementAt(0)]['address']);
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
        height: double.infinity,
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 30,
                MediaQuery.of(context).size.height / 50,
                MediaQuery.of(context).size.width / 30,
                0.0),
            height: MediaQuery.of(context).size.height / 6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
              borderRadius: BorderRadius.circular(border),
            ),
            child: Stack(children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 9, 0.0, 0.0, 0.0),
                child: Column(children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 30,
                        MediaQuery.of(context).size.height / 35,
                        MediaQuery.of(context).size.width / 30,
                        0.0),
                    width: double.infinity,
                    child: Text(
                      'Shopping Cart',
                      style: TextStyle(
                        color: white,
                        fontSize: head,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 30,
                          MediaQuery.of(context).size.height / 80,
                          MediaQuery.of(context).size.width / 30,
                          0.0),
                      child:
                          Text('Verify your quantities and proceed to checkout',
                              style: TextStyle(
                                color: white,
                              )))
                ]),
              ),
              Container(
                height: double.infinity,
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 30,
                    MediaQuery.of(context).size.height / 35,
                    0.0,
                    0.0),
                alignment: Alignment.topLeft,
                child: Icon(
                  Icons.shopping_cart,
                  color: white,
                  size: MediaQuery.of(context).size.height / 20,
                ),
              )
            ]),
          ),
          cartMap!=null  && cartMap.length!=0 ?Expanded(
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width / 30,
                  MediaQuery.of(context).size.height / 200,
                  MediaQuery.of(context).size.width / 30,
                  0.0),
              color: white,
              child: ListView.builder(
                  itemCount: cartMap.length-1,
                  itemBuilder: (BuildContext context, int index) {
                      shop = shopMap[shopMap.keys.firstWhere((element) => element==cartMap['shopId'])];
    
                      return CartTile(item: cartMap[cartMap.keys.where((element) => element!='shopId').elementAt(index)],shopName: shop.shopName,vid: cartMap.keys.where((element) => element!='shopId').elementAt(index),);
                  }),
            ),
          ) : Expanded(child: Container()),
          Container(
            height: MediaQuery.of(context).size.height / 5.5,
            margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 30,
                MediaQuery.of(context).size.height / 200,
                MediaQuery.of(context).size.width / 30,
                0.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
              borderRadius: BorderRadius.circular(border),
            ),
            child: Column(children: <Widget>[
              Container(
                  child: Stack(children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 20,
                      MediaQuery.of(context).size.height / 80,
                      MediaQuery.of(context).size.width / 20,
                      0),
                  child: Text('SubTotal',
                      style: TextStyle(
                          color: white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 20,
                      MediaQuery.of(context).size.height / 80,
                      MediaQuery.of(context).size.width / 20,
                      0),
                  alignment: Alignment.centerRight,
                  child: Text('\u20B9 ${subtotal}',
                      style: TextStyle(
                          color: white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold)),
                ),
              ])),
              Container(
                  child: Stack(children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 20,
                      MediaQuery.of(context).size.height / 80,
                      MediaQuery.of(context).size.width / 20,
                      0),
                  child: Text('Delivery charges',
                      style: TextStyle(
                          color: white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width / 20,
                      MediaQuery.of(context).size.height / 80,
                      MediaQuery.of(context).size.width / 20,
                      0),
                  alignment: Alignment.centerRight,
                  child: Text('\u20B9 ${delCharges}',
                      //textAlign: TextAlign.right,
                      style: TextStyle(
                          color: white,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold)),
                ),
              ])),
              SizedBox(height: MediaQuery.of(context).size.height / 50),
              Container(
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 20,
                    0,
                    MediaQuery.of(context).size.width / 20,
                    0),
                child: ButtonTheme(
                  minWidth: double.infinity,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(border)),
                    color: Colors.white,
                    textColor: base,
                    child: Text('Checkout (\u20B9 ${subtotal + delCharges})'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return StatefulBuilder(
                                  builder: (BuildContext context,setState){
                                    return Column(
                                  children: <Widget>[
                                    SizedBox(height: MediaQuery.of(context).size.height/20,),
                                    Container(
                                      alignment: Alignment.topCenter,
                                        margin: EdgeInsets.symmetric(horizontal : MediaQuery.of(context).size.width/40),
                                        child: Text("Choose the Delivery Date\n and Time",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: head
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                                    FlatButton.icon(
                                      onPressed: ()async{
                                        DateTime date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 12)));
                                        setState((){
                                          delTime = Timestamp.fromDate(date);
                                          _date = DateFormat.yMMMd().format(date);
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius : BorderRadius.circular(border),
                                      ),
                                      color: base,
                                      icon: Icon(Icons.date_range,color:white),
                                      label: Text(_date ?? "Choose the date",style: TextStyle(color:  white),)
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                                    FlatButton.icon(
                                      onPressed: ()async{
                                        TimeOfDay time = TimeOfDay(hour: 9, minute: 0);
                                        while(!(time.hour >=10 && time.hour<=22)){
                                          time = await showTimePicker(context: context,helpText: "Please choose time between 10:00 A.M. to 10:00 P.M. ",initialTime: TimeOfDay(hour: 10, minute: 00),initialEntryMode: TimePickerEntryMode.input);
                                          if(!(time.hour >=10 && time.hour<=22)){
                                            showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Alert'),
                                                content: Text("Please choose time between 10:00 A.M. to 10:00 P.M."),
                                                actions: [
                                                  RaisedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context, true);
                                                    },
                                                    color: base,
                                                    child: Text(
                                                      "OK",
                                                    style: TextStyle(color: white),
                                                      ),
                                                  ),
            
                                                ],
                                                );
                                              });
                                          }
                                          print(time.toString());
                                        }
                                        setState((){
                                          delTime.toDate().add(Duration(hours: time.hour));
                                          delTime.toDate().add(Duration(minutes: time.minute));
                                          _time = time.format(context);
                                        });
              
                                        if(delTime.toDate().isBefore(DateTime.now().add(Duration(hours: 1)))){
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text('Alert'),
                                                content: Text("Minimum time for this order is 1 hour. Choose the delivery time after the current one."),
                                                actions: [
                                                  RaisedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context, true);
                                                    },
                                                    color: base,
                                                    child: Text(
                                                      "OK",
                                                    style: TextStyle(color: white),
                                                      ),
                                                  ),
            
                                                ],
                                                );
                                              });
                                        }
                                        
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius : BorderRadius.circular(border),
                                      ),
                                      color: base,
                                      icon: Icon(Icons.date_range,color:white),
                                      label: Text(_time ?? "Choose the time",style: TextStyle(color:  white),)
                                    ),                                    
                                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                                    DropdownButton(
                                      value: _selectedAddress,
                                      items: _addresses,
                                      onChanged: (val){
                                        setState((){
                                          _selectedAddress = val;
                                        });
                                      }
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height/40,),
                                    FlatButton.icon(
                                      color: base,
                                      shape : RoundedRectangleBorder(
                                        borderRadius : BorderRadius.circular(border),
                                      ),
                                      onPressed: () async {
                                        int _otp = Random().nextInt(9999);
                                        while(_otp < 1000){
                                          _otp *= 10;
                                        }
                                        Order order = Order(
                                          userId: currentUserID,
                                          shopId: shop.shopId,
                                          status: "PENDING",
                                          otp : _otp,
                                          paymentType: "UPI",
                                          amount: subtotal + 50,
                                          delCharges: 50,
                                          pickUp: false,
                                          orderTime: Timestamp.now(),
                                          deliveryTime: delTime,
                                          deliveryAddress: _selectedAddress,
                                          items: cartMap,
                                          cod: true,
                                        );
                                        DatabaseService().createOrder(order);
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return Checkout(order: order);}));
                                        PushNotification().pushMessage('New Order Request', 'Request from ${currentUser.name}', shop.token);
                                      },
                                      icon: Icon(Icons.done,color: white,), 
                                      label: Text('Confirm' ,style:TextStyle(color: white)),
                                    )
                                  ]
                              );
                            }
                          );
                        }
                      );                   
                    },
                  ),
                ),
              )
            ]),
          )
        ]),
      ),
    );

  }
}
