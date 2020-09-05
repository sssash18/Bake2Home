import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PushNotification{

  PushNotification._();

  factory PushNotification() => _instance;

  static final PushNotification _instance = PushNotification._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool _initialized = false;

  Future<void> init() async{
    if(!_initialized){
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();
      _firebaseMessaging.onTokenRefresh.last.then((value) => null);
      String token = await _firebaseMessaging.getToken();
      print("toke" + token);
      _initialized = true;
    }
  }

  Future<void> pushMessage(String title,String body) async{
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
       },
       'priority': 'high',
       'data': <String, dynamic>{
         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
         'id': '1',
         'status': 'done'
       },
       'to': await _firebaseMessaging.getToken(),
     },
    ),
  );

   }


}