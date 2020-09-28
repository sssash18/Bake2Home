import 'package:bake2home/widgets/Review.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/widgets/HistoryTile.dart';
import 'package:bake2home/functions/order.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class OrdersList extends StatefulWidget {
  final GlobalKey<ScaffoldState> historyKey;
  OrdersList({this.historyKey});

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  @override
  Widget build(BuildContext context) {
    List<Order> orders = Provider.of<List<Order>>(context) ?? [];
    //return Review(shop: shopMap["emYlLuBFbRcw1hhlitvGuePI7Rh1"]);
    return orders.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.separated(
            separatorBuilder: (context, i) {
              return SizedBox(
                height: 10.0,
              );
            },
            itemCount: orders.length,
            itemBuilder: (context, i) {
              return HistoryTile(
                historyKey: this.widget.historyKey,
                order: orders[i],
              );
            });
  }
}
