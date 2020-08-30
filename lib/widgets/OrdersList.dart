
import 'package:flutter/material.dart';
import 'package:bake2home/widgets/HistoryTile.dart';
import 'package:bake2home/functions/order.dart';
import 'package:provider/provider.dart';

class OrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Order> orders = Provider.of<List<Order>>(context) ?? [];
    return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index){
        return HistoryTile(order: orders.elementAt(index),);
      }
    );
  }
}