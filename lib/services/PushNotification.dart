import 'package:bake2home/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bake2home/constants.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class PushNotification{

  PushNotification._();

  factory PushNotification() => _instance;

  static final PushNotification _instance = PushNotification._();


  bool _initialized = false;

  Future<void> init() async{
    if(!_initialized){
      firebaseMessaging.requestNotificationPermissions();
      firebaseMessaging.configure();
      firebaseMessaging.onTokenRefresh.last.then((value){
        DatabaseService().updateToken(value);
      });
      _initialized = true;
      
    }
    
  }

  Future<void> pushMessagewithNewOrder(String title,String body,String token) async{
    final serverToken = 'AAAATnEOuVU:APA91bEv0ZjHErtQC1lN_-yVorEJrf0YMBpdZiPrShRWSvog7SdUQ_B72yhEfx55i9riKJElt7BnsOi_E88DgrpvCMqilwikJq3gdg9_euNvqi3n7bBs8SaGnJCEbSt4gJr_4dljSA56'; 
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
         'android_channel_id' : '1891',
         'icon' : 'logo.png'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'time_to_live' : 90,
       'to': token
     },
    ),
  );

   }

  Future<void> pushMessagewithCancel(String title,String body,String token) async{
    final serverToken = 'AAAATnEOuVU:APA91bEv0ZjHErtQC1lN_-yVorEJrf0YMBpdZiPrShRWSvog7SdUQ_B72yhEfx55i9riKJElt7BnsOi_E88DgrpvCMqilwikJq3gdg9_euNvqi3n7bBs8SaGnJCEbSt4gJr_4dljSA56'; 
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
         'android_channel_id' : '1890',
         'icon' : 'logo.png'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'to': token
     },
    ),
  );

   }

   Future<void> pushMessage(String title,String body,String token) async{
    final serverToken = 'AAAATnEOuVU:APA91bEv0ZjHErtQC1lN_-yVorEJrf0YMBpdZiPrShRWSvog7SdUQ_B72yhEfx55i9riKJElt7BnsOi_E88DgrpvCMqilwikJq3gdg9_euNvqi3n7bBs8SaGnJCEbSt4gJr_4dljSA56'; 
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
         'icon' : 'logo.png'
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'to': token
     },
    ),
  );

   }

  


}