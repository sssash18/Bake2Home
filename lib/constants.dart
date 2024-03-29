import 'package:bake2home/functions/category.dart';
import 'package:bake2home/functions/trending.dart';
import 'package:bake2home/services/PushNotification.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/functions/user.dart' as LocalUser;
import 'package:intl/intl.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

Color base = Color(0xff654ea3);
Color white = Colors.white;
Color text = Color(0xff654ea3);
Color button = Colors.pink[800];
Color pastry = Colors.grey[200];
Color grad1 = Color(0xffeaafc8);
Color grad2 = Color(0xff654ea3);
Color black = Colors.black;
int badge1 = 0, badge2 = 0, badge = 3, badge4 = 0;
double head = 20.0;
double head2 = 30.0;
double textSize = 18.0;
double sideButton = 12.0;
double border = 20.0;
String deliveryToken = "";
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
List<Trending> trendingList = [];
List<double> delChargesList = [];
bool timerOver = false;
StreamController<String> controller = StreamController<String>.broadcast();
FirebaseMessaging firebaseMessaging = FirebaseMessaging();
String token = "";
List<String> slidesUrl = [];
double finalAmount = 0;

String readTimestamp(Timestamp timestamp) {
  DateTime date = timestamp.toDate();
  String df = DateFormat('HH-mm').format(date);
  String tp = DateFormat('MMM-dd-yyyy').format(date);
  List<dynamic> ll = df.split('-');
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
      barrierDismissible: false,
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

List<Map> attr = [];
Text gen = Text("General Terms and Conditions\n",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11));
String tnc =
    "Keep it clean: Whether you are writing a small comment or a detailed description for your meal, keep foul/abusive/hateful language,threats out of it.\nKeep it fresh: Only one review per order for each online transaction can be submitted.\nBe honest: Give your reviews based on your real experience with a particular order.Don’t try to falsify your experience.Also please don't exaggerate about your reviews;keep it clean and minimalist\n Don't fabricate: Disguising yourself a BakeMyCake official is an act of solicitation.If reports or evidence of any such thing is brought to us, we reserve the right to take down your BakeMyCake profile and take any other relevant action if needed.\nBe yourself: Your identity is displayed clearly from your profile, so please fill in the honest information in your profile.\nDon’t bully: We take accusations for a threat against our vendors very seriously.So don’t try to threaten vendors in order to fulfil your personal demands.\nSeek help from us: If you have any complaints regarding the service or the vendors please feel free to contact us through the contact details provided in the application.\nAbout the product:BakeMyCake accepts no liability for any errors on behalf of third party vendors.\n";
String can =
    "No penalty is charged if the customer hasn't paid for the order even if the vendor has approved for the order,the order stands cancelled in this case.\nIf the payment is done,then in order to avail full refund of the payment,the order needs to be cancelled in the service hours(10AM-10PM) one day before when the delivery is scheduled.(In short order can’t be cancelled on the day when the delivery is scheduled or else advance amount would be charged as penalty.)\nRefund amount will be sent to the customer within 48 hours after the cancellation.";
Text cancel = Text("Cancellation Policy\n",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11));
