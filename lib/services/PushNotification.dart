import 'package:firebase_messaging/firebase_messaging.dart';

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


}