
import 'package:bake2home/widgets/Review.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/widgets/HistoryTile.dart';
import 'package:bake2home/functions/order.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class OrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Order> orders = Provider.of<List<Order>>(context) ?? [];
    print(orders.toString());
    return Review(shop: shopMap["emYlLuBFbRcw1hhlitvGuePI7Rh1"]);
    return ListView.builder(
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index){
        return HistoryTile(order: orders.elementAt(index));
      }
    );
  }
}