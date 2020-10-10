import 'package:bake2home/functions/order.dart';
import 'package:bake2home/screens/Payment.dart';
import 'package:bake2home/services/database.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bake2home/constants.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_countdown_timer/countdown_timer.dart';

class OrderPending extends StatefulWidget {
  @override
  _OrderPendingState createState() => _OrderPendingState();
}

class _OrderPendingState extends State<OrderPending> {
  @override
  Widget build(BuildContext context) {
    List<Order> orders = Provider.of<List<Order>>(context) ?? [];
    Order order;
    if (orders.isNotEmpty) {
      order = orders[0];
      if (order.status != "PENDING") {
        if (order.status == 'REJECTED') {
          controller.sink.add('${order.status}-${order.reason}');
        } else {
          controller.sink.add(order.status);
        }
      }
    }

    return orders.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            height: MediaQuery.of(context).size.height / 3,
            alignment: Alignment.center,
            child: CircularCountDownTimer(
              width: MediaQuery.of(context).size.width / 2,
              height: 200,
              duration: 120,
              fillColor: white,
              color: base,
              isTimerTextShown: true,
              isReverse: true,
              onComplete: () {
                Order order = orders[0];
                if (order.status == 'PENDING') {
                  order.status = 'MISSED';
                  controller.sink.add('MISSED');
                } else {
                  controller.sink.add('PENDING');
                }
              },
            ));
  }
}
