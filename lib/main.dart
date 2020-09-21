import 'package:bake2home/screens/VendorProfile.dart';
import 'package:bake2home/screens/router.dart';
import 'package:bake2home/services/PushNotification.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/VendorListPage.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

bool USE_FIRESTORE_EMULATOR = false;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = Settings(
        host: 'localhost:8080', sslEnabled: false, persistenceEnabled: false);
  }
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      routes: {
        '/profile' : (BuildContext context) => VendorProfile(),
      },
      title: 'Bake2Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          canvasColor: white,
          primaryColor: base,
          primarySwatch: Colors.deepPurple,
          tabBarTheme: TabBarTheme(
              unselectedLabelColor: Colors.black,
              labelColor: white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  color: base,
                  borderRadius: BorderRadius.circular(40),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xffeaafc8), Color(0xff654ea3)]))),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          fontFamily: 'Sora'),
      home: Router(),
    );
  }
}
