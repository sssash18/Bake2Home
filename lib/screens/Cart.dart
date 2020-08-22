import 'package:bake2home/widgets/CartTile.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  itemCount: cartMap.length - 1,
                  itemBuilder: (BuildContext context, int index) {
                    return CartTile(item: cartMap.values.elementAt(index),);
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
                  child: Text('Rs 3500',
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
                    child: Text('Checkout (Rs 3550)'),
                    onPressed: () {},
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
