import 'dart:async';

import 'package:bake2home/screens/NoInternet.dart';
import 'package:bake2home/services/database.dart';
import 'package:bake2home/widgets/OrdersList.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/widgets/HistoryTile.dart';
import 'package:provider/provider.dart';
import 'package:bake2home/functions/order.dart';

class ProfileOrder extends StatefulWidget {
  @override
  _ProfileOrderState createState() => _ProfileOrderState();
}

class _ProfileOrderState extends State<ProfileOrder> {
  final Connectivity _connectivity = Connectivity();
  final historyKey = GlobalKey<ScaffoldState>();
  StreamSubscription<ConnectivityResult> subs;

  bool internetStatus = true;

  @override
  void initState(){
    super.initState();
    final Connectivity _connectivity = Connectivity();
    _connectivity.checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        internetStatus = false;
      }
    });
    subs =
        _connectivity.onConnectivityChanged.listen((ConnectivityResult event) {
      setState(() {
        if (event == ConnectivityResult.none) {
          internetStatus = false;
        } else {
          internetStatus = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return internetStatus
        ? Scaffold(
            key: historyKey,
            appBar: AppBar(
                backgroundColor: white,
                elevation: 0.0,
                iconTheme: IconThemeData(
                  color: base,
                ),
                title: Text('History',
                    style: TextStyle(
                      color: text,
                    ))),
            body: StreamProvider<List<Order>>.value(
              value: DatabaseService().orders,
              catchError: (context, e) {
                print(
                    '++++++++++++++++++++++++++++++++++++++++${e.toString()}');
              },
              child: Container(
                child: OrdersList(
                  historyKey: historyKey,
                ),
              ),
            ),
          )
        : NoInternet();
  }

  @override
  void dispose() {
    super.dispose();
    subs.cancel();
  }
}
