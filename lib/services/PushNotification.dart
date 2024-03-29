import 'package:bake2home/chatApp/screens/chatwithfriend.dart';
import 'package:bake2home/functions/order.dart';
import 'package:bake2home/services/database.dart';
import 'package:bake2home/widgets/Review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bake2home/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotification {
  PushNotification._();

  factory PushNotification() => _instance;

  static final PushNotification _instance = PushNotification._();

  bool _initialized = false;

  Future<void> init() async {
    DatabaseService().getDeliveryToken();

    if (!_initialized) {
      firebaseMessaging.requestNotificationPermissions();
      firebaseMessaging.configure(onMessage: (payload) async {
        if (payload['data']['route'] == 'delivered') {
          showDialog(
              context: navigatorKey.currentContext,
              builder: (context) {
                return Review(
                  shop: shopMap[payload['data']['shopId']],
                  orderId: payload['data']['orderId'],
                );
              });
        }
      }, onResume: (payload) {
        if (payload['data']['route'] == 'delivered') {
          showDialog(
              context: navigatorKey.currentContext,
              builder: (context) {
                return Review(
                  shop: shopMap[payload['data']['shopId']],
                  orderId: payload['data']['orderId'],
                );
              });
        }
        if (payload['data']['route'] == 'chat') {
          String orderId = payload['data']['chatId'];
          FirebaseFirestore.instance
              .collection("Orders")
              .doc(orderId)
              .get()
              .then((e) {
            Order order = Order(
                userId: e.data()['userId'],
                shopId: e.data()['shopId'],
                status: e.data()['status'],
                otp: e.data()['otp'],
                paymentType: e.data()['paymentType'],
                amount: e.data()['amount'].toDouble(),
                delCharges: e.data()['deliveryCharges'].toDouble(),
                pickUp: e.data()['pickUp'],
                orderTime: e.data()['orderTime'],
                deliveryTime: e.data()['deliveryTime'],
                deliveryAddress: e.data()['deliveryAddress'],
                items: e.data()['items'],
                codAmount: e.data()['codAmount'].toDouble(),
                //reason: e.data()['reason'],
                //compensation: e.data()['compensation'].toDouble(),
                orderId: e.data()['orderId']);
            Navigator.push(
                navigatorKey.currentContext,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        ChatWithFriend(order: order)));
          });
        }
      });
      firebaseMessaging.onTokenRefresh.last.then((value) {
        DatabaseService().updateToken(value);
      });
      _initialized = true;
    }
  }

  Future<void> pushMessagewithNewOrder(
      String title, String body, String token, String orderId) async {
    final serverToken =
        'AAAAhsyrwCg:APA91bEh5TWM94ynBA-oroEO8ajZ9sS9ej2fDlYtNl4VkNGNGdGPbI_Ep4hFXsn0K0tivx5MhnybtWiYH43heJ4LIWITZXXg1qHxVFysyDUe6rzcSNQndDNhsXnaD4yrrPmt3mGYDsIh';
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
            'android_channel_id': '1891',
            'icon': 'logo.png',
            'sound': 'neworder.mp3'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'route': 'neworder',
            'orderId': orderId
          },
          'time_to_live': 120,
          'to': token
        },
      ),
    );
  }

  Future<void> pushMessagewithCancel(
      String title, String body, String token, String orderId) async {
    final serverToken =
        'AAAAhsyrwCg:APA91bEh5TWM94ynBA-oroEO8ajZ9sS9ej2fDlYtNl4VkNGNGdGPbI_Ep4hFXsn0K0tivx5MhnybtWiYH43heJ4LIWITZXXg1qHxVFysyDUe6rzcSNQndDNhsXnaD4yrrPmt3mGYDsIh';
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
            'android_channel_id': '1890',
            'icon': 'logo.png',
            'sound': 'cancel.mp3'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'route': 'cancel',
            'orderId': orderId,
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': token
        },
      ),
    );
  }

  Future<void> pushMessage(String title, String body, String token) async {
    final serverToken =
        'AAAAhsyrwCg:APA91bEh5TWM94ynBA-oroEO8ajZ9sS9ej2fDlYtNl4VkNGNGdGPbI_Ep4hFXsn0K0tivx5MhnybtWiYH43heJ4LIWITZXXg1qHxVFysyDUe6rzcSNQndDNhsXnaD4yrrPmt3mGYDsIh';
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
            'icon': 'logo.png',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': token
        },
      ),
    );
  }

  Future<void> pushMessageChat(
      String title, String body, String token, String chatId) async {
    final serverToken =
        'AAAAhsyrwCg:APA91bEh5TWM94ynBA-oroEO8ajZ9sS9ej2fDlYtNl4VkNGNGdGPbI_Ep4hFXsn0K0tivx5MhnybtWiYH43heJ4LIWITZXXg1qHxVFysyDUe6rzcSNQndDNhsXnaD4yrrPmt3mGYDsIh';
    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
            'icon': 'logo.png',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'route': 'chat',
            'chatId': chatId,
          },
          'to': token
        },
      ),
    );
  }
}
