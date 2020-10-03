import 'package:bake2home/functions/order.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class FinalAmount extends StatelessWidget {
  Function callBackToPrice;
  FinalAmount({this.callBackToPrice});
  @override
  Widget build(BuildContext context) {
    List<Order> orderList = Provider.of<List<Order>>(context) ?? [];
    Order order;
    if (orderList.isNotEmpty) {
      order = orderList[0];
      // callBackToPrice(order.amount);
      print(order.amount);
      print(order.codAmount);
    }
    return orderList.isEmpty
        ? Center(child: CircularProgressIndicator())
        : Container(
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(border),
            ),
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                height: MediaQuery.of(context).size.height / 25,
                margin: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 20,
                    MediaQuery.of(context).size.width / 14,
                    MediaQuery.of(context).size.width / 40,
                    0),
                alignment: Alignment.centerRight,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Text(
                    "Final Order Amount",
                    style: TextStyle(
                        color: white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(border),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffeaafc8), Color(0xff654ea3)]),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'AMOUNT',
                style: TextStyle(color: Colors.grey[700], fontSize: 10),
              ),
              Text(
                '\u20B9 ${order.amount ?? ""}',
                style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                'COMMENTS',
                style: TextStyle(color: Colors.grey[700], fontSize: 10),
              ),
              Text(
                '${order.comments ?? ""}',
                style: TextStyle(fontSize: 15.0),
              ),
              SizedBox(height: 20),
            ]));
  }
}
