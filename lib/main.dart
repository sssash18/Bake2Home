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

import 'functions/shop.dart';

bool USE_FIRESTORE_EMULATOR = false;

void main() async {
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

  void initState(){
    super.initState();
     WidgetsBinding.instance.addObserver(this);
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      routes: {
        '/profile': (BuildContext context) => VendorProfile(),
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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
               //do your stuff
        initDynamicLinks();
    }
  }

  Future<void> initDynamicLinks() async {
    Navigator.pushNamed(context, '/profile',arguments: shopMap['emYlLuBFbRcw1hhlitvGuePI7Rh1']);
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData link) async {      
      _handleDeepLink(link);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
    final PendingDynamicLinkData link =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(link);
    final Uri deeplink = link?.link;
    print("LLLLL" + deeplink.toString());
    
    
  }
  void _handleDeepLink(PendingDynamicLinkData link){
    print("link:  " + '${link?.link}');
    Uri deepLink = link?.link;
    if (deepLink != null) {
        final String param = deepLink.queryParameters['Id'];
        print(param);
        Shop shop = shopMap[param];
        print(shop.shopName);
        print(deepLink.path);
        Navigator.pushNamed(context, deepLink.path, arguments: shop);
        print('cant Handle');
    }
  }
}
