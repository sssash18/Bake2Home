import 'dart:math';
import 'package:bake2home/functions/order.dart';
import 'package:bake2home/screens/Checkout.dart';
import 'package:bake2home/screens/OrderPending.dart';
import 'package:bake2home/services/database.dart';
import 'package:bake2home/widgets/CartTile.dart';
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
    double subtotal  = 0;
    String _date,_time;
    cartMap.keys.where((element) => element!=cartMap['shopId']).forEach((element) { 
      if(element!='shopId'){
        subtotal += cartMap[element]['price'] * cartMap[element]['quantity'];
      }
    });
    Shop shop = shopMap[shopMap.keys.firstWhere((element) => element==cartMap['shopId'])];
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
    //print(currentUser.addresses[currentUser.addresses.keys.elementAt(0)]['address']);
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
          Expanded(
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
                    //print('passed : ${cartMap[cartMap.keys.where((element) => element!='shopId').elementAt(index)]}');
                    return CartTile(item: cartMap[cartMap.keys.where((element) => element!='shopId').elementAt(index)],shopName: shop.shopName,vid: cartMap.keys.where((element) => element!='shopId').elementAt(index),);
                  }),
            ),
          ),
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
                  child: Text('Rs 50',
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
                    child: Text('Checkout (\u20B9 ${subtotal})'),
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
                                        TimeOfDay time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                                        setState((){
                                          _time = time.format(context);
                                        });
                                        
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
                                      onPressed: (){
                                        int _otp = Random().nextInt(9999);
                                        while(_otp < 1000){
                                          _otp *= 10;
                                        }
                                        Order order = Order(
                                          userId: currentUserID,
                                          shopId: currentShopId,
                                          status: "PENDING",
                                          otp : _otp,
                                          paymentType: "UPI",
                                          amount: subtotal + 50,
                                          delCharges: 50,
                                          pickUp: false,
                                          orderTime: '${DateTime.now()}',
                                          deliveryTime: '${_date} ${_time}',
                                          deliveryAddress: _selectedAddress,
                                          items: cartMap
                                        );
                                        DatabaseService().createOrder(order);
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){return Checkout();}));
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
