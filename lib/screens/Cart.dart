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
        title : Text(
          'Cart',
          style: TextStyle(
            color: base,
          )
        )
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          children: <Widget> [
            Container(
                margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                height: 110.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffeaafc8),Color(0xff654ea3)]
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(40.0, 0.0, 0.0, 0.0),
                      child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
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
                        margin: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
                        child: Text(
                          'Verify your quantities and proceed to checkout',
                          style: TextStyle(
                            color: white,
                          )
                        )
                      )
                      ]
                      ),
                    ),
                    Container(
                        height: double.infinity,
                        margin: EdgeInsets.fromLTRB(10.0, 20.0, 0.0, 0.0),
                        alignment: Alignment.topLeft,
                        child: Icon(
                        Icons.shopping_cart,
                        color: white,
                        size: 40.0,
                      ),
                    )
                  ]
                ),
              ),
            Expanded(
                child: Container(
                width: double.infinity,
                //height: 350.0,
                margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
                color: white,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index){
                    return CartTile();
                  }
                ),
              ),
            ) ,
            Container(
              height: 140.0,
              margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 0.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffeaafc8),Color(0xff654ea3)]
                ),
                borderRadius: BorderRadius.circular(border),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    child: Stack(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0) ,
                          child: Text(
                            'SubTotal',
                            //textAlign: TextAlign.left,
                            style: TextStyle(
                              color: white,
                              fontSize: 18.0,
                              fontWeight : FontWeight.bold
                            )
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0) ,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Rs 3500',
                            //textAlign: TextAlign.right,
                            style: TextStyle(
                              color: white,
                              fontSize: 18.0,
                              fontWeight : FontWeight.bold
                            )
                          ),
                        ),
                      ]
                    )
                  ),
                  
                  Container(
                    child: Stack(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0) ,
                          child: Text(
                            'Delivery charges',
                            //textAlign: TextAlign.left,
                            style: TextStyle(
                              color: white,
                              fontSize: 12.0,
                              fontWeight : FontWeight.bold
                            )
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0) ,
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Rs 50',
                            //textAlign: TextAlign.right,
                            style: TextStyle(
                              color: white,
                              fontSize: 12.0,
                              fontWeight : FontWeight.bold
                            )
                          ),
                        ),
                      ]
                    )
                  ),
                  
                  SizedBox(height: 20.0),
                  Container(
                      margin:EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0) ,
                      child: ButtonTheme(
                      minWidth: double.infinity,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(border)
                        ),
                        color: Colors.white,
                        textColor: base,
                        child: Text('Checkout (Rs 3550)'),
                        onPressed: (){},
                      ),
                    ),
                  )

                ]
              ),
            )  
          ]
        ),
      ),
      
    );
  }
}