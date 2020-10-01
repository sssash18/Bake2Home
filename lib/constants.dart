import 'package:bake2home/functions/category.dart';
import 'package:bake2home/services/PushNotification.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/functions/user.dart' as LocalUser;
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';


Color base = Color(0xff654ea3);
Color white = Colors.white;
Color text = Color(0xff654ea3);
Color button = Colors.pink[800];
Color pastry = Colors.grey[200];
Color grad1 = Color(0xffeaafc8);
Color grad2 = Color(0xff654ea3);
Color black = Colors.black;
int badge1 = 0,badge2 = 0,badge = 3,badge4 = 0;
double head = 20.0;
double head2 = 30.0;
double textSize = 18.0;
double sideButton = 12.0;
double border = 20.0;
Map<String, Shop> shopMap = new Map<String, Shop>();
Map<String, Shop> topPickMap = new Map<String, Shop>();
LocalUser.MyUser currentUser;
String currentUserID = '94ON8vhE5kxa7SfOyBWJ';
String cartShopId = 'null';
Map<String, dynamic> cartMap = Map<String, dynamic>();
ValueNotifier<int> cartLengthNotifier = ValueNotifier<int>(0);
String currentShopId = 'null';
StopWatchTimer timer;
bool activeTimer = false;
PushNotification pushNotification = PushNotification();
String timerVal;
GlobalKey navigatorKey = GlobalKey<NavigatorState>();
List<Category> categoryList = [];
List<double> delChargesList = [];
bool timerOver = false;
StreamController<bool> controller = StreamController<bool>.broadcast();
FirebaseMessaging firebaseMessaging = FirebaseMessaging();
String token = "";
List<String> slidesUrl = [];

String readTimestamp(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  String df = DateFormat('HH-mm').format(date);
  String tp = DateFormat('MMM-dd-yyyy').format(date);
  List<dynamic> ll = df.split('-');
  if (int.parse(ll[0]) > 12) {
    df = '$df PM';
  } else {
    df = '$df AM';
  }
  df = df.replaceAll('-', ':');
  tp = tp.replaceAll('-', ', ');
  String s = '$tp, $df';
  print("s is f$s");
  return s;
}

String createAvatarText() {
  String result = "";
  print('retsult is ${currentUser.name}');

  if (currentUser.name.contains(" ")) {
    List<String> nameList = currentUser.name.split(" ");
    if (nameList.contains('')) {
      result += nameList[0][0].toUpperCase();
      return result;
    }
    nameList.forEach((element) {
      result += element[0].toUpperCase();
    });
  } else {
    result = currentUser.name.substring(0, 1);
  }
  print('retsult is $result');
  return result;
}

Future<bool> genDialog(
    BuildContext context, String msg, String yes, String no) async {
  bool rs = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text("$msg"),
          actions: [
            RaisedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              color: base,
              child: Text(
                yes,
                style: TextStyle(color: white),
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              color: black,
              child: Text(
                no,
                style: TextStyle(color: white),
              ),
            )
          ],
        );
      });
  return rs;
}

showSnackBar(GlobalKey<ScaffoldState> key, String msg) {
  key.currentState.showSnackBar(SnackBar(
    content: Text("$msg"),
    duration: Duration(seconds: 2),
  ));
}

Future showGenDialog(BuildContext context, String msg) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(title: Text("Alert"), content: Text(msg), actions: [
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: base,
            child: Text("Ok", style: TextStyle(color: white)),
          )
        ]);
      });
}
