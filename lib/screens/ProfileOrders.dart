import 'package:bake2home/services/database.dart';
import 'package:bake2home/widgets/OrdersList.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/HistoryTile.dart';
import 'package:provider/provider.dart';
import 'package:bake2home/functions/order.dart';


class ProfileOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: base,
        ),
        title: Text(
          'History',
          style: TextStyle(
            color: text,
          )
        )
      ),
      body: StreamProvider<List<Order>>.value(
          value: DatabaseService().orders,
          child: Container(
          child: OrdersList(),
        ),
      ),
    );
  }
}