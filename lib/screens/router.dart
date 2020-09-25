import 'dart:async';

import 'package:bake2home/functions/category.dart';
import 'package:bake2home/functions/user.dart';
import 'package:bake2home/screens/homepage.dart';
import 'package:bake2home/screens/signIn.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';

class Router extends StatefulWidget {
  @override
  _RouterState createState() => _RouterState();
}

class _RouterState extends State<Router> {
  CollectionReference shopCollection =
      FirebaseFirestore.instance.collection("Shops");
  CollectionReference topCollection =
      FirebaseFirestore.instance.collection("TopPicks");
  CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection("Categories");
  CollectionReference deliveryCollection = 
      FirebaseFirestore.instance.collection("DeliveryCharges");
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getThings();
    //createDynamicLink();
    initDynamicLinks();
    
  }

  Future<void> initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData link) async {
      final Uri deeplink = link?.link;
      if (deeplink != null) {
        final String param = deeplink.queryParameters['Id'];
        print(param);
        Shop shop = shopMap[param];
        print(shop.shopName);
        Navigator.pushNamed(context, deeplink.path, arguments: shop);
      }
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
    final PendingDynamicLinkData link =
        await FirebaseDynamicLinks.instance.getInitialLink();
    //FirebaseDynamicLinks.instance.getDynamicLink(url);
    final Uri deeplink = link?.link;
    print("LLLLL" + deeplink.toString());
  }

  void getThings() async {
    await getShops();
    await getTopPick();
    await getUser();
    await getCategories();

    getDeliveryCharges();
    // await getCardDetails();

    _auth.currentUser != null
        ? Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => HomePage()))
        : Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => SignIn()));
  }

  Future<bool> getUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String uid = FirebaseAuth.instance.currentUser.uid;
      print('00000000000000------------------$uid');
      DocumentSnapshot user = await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .get()
          .catchError((e) {
        print(e.toString());
      });
      currentUserID = uid;
      currentUser = MyUser(
          uid: uid,
          name: user.data()['name'],
          addresses: user.data()['addresses'] == null
              ? {}
              : Map.from(user.data()['addresses']),
          contact: user.data()['contact'],
          token: user.data()['token']);
      await getCartDetails(uid);
    }

    return true;
  }

  
  Future<bool> getShops() async {
    QuerySnapshot shops = await shopCollection.get();
    shops.docs.forEach((element) {
      Shop shop = _shopFromSnapshot(element);
      shopMap.putIfAbsent(shop.shopId, () => shop);
    });
    print("SSSSSS + ${shopMap.toString()}");
    return true;
  }

  Future<void> getCategories() async {
    QuerySnapshot categories = await categoryCollection.get();
    categories.docs.forEach((element) {
      Category cat =
          Category(name: element.id, photoUrl: element.data()['photoUrl']);
      categoryList.add(cat);
    });
    print(categoryList);
  }

  Future<void> getTopPick() async {
    await topCollection.get().then((value) {
      value.docs.forEach((element) {
        Shop shop = shopMap[element.data()['shopId']];
        topPickMap.putIfAbsent(shop.shopId, () => shop);
      });
    });
  }

  Shop _shopFromSnapshot(DocumentSnapshot document) {
    return Shop(
      shopId: document.data()['shopId'],
      shopName: document.data()['shopName'],
      shopAddress: document.data()['shopAddress'],
      contact: document.data()['contact'],
      merchantName: document.data()['merchantName'],
      tagline: document.data()['tagline'],
      bio: document.data()['bio'],
      profilePhoto: document.data()['profilePhoto'],
      coverPhoto: document.data()['coverPhoto'],
      cookTime: document.data()['cookTime'],
      experience: document.data()['experience'],
      numOrders: document.data()['numOrders'],
      items: document.data()['items'],
      rating: (document.data()['rating'] ?? 0).toDouble(),
      ingPrice: document.data()['ingPrice'],
      token: document.data()['token'],
      advance: document.data()['advance'].toDouble(),
      cod : document.data()['cod'],
      reviews: List<String>.from(document.data()['reviews']),
    );
  }

  Future<void> getDeliveryCharges() async{
    deliveryCollection.doc('charges').get().then((value){
      value.data().keys.forEach((element) { 
        delChargesList.add(value.data()[element].toDouble());
      });
      print("DDDDDD ${delChargesList.toString()}") ;
    }
    );
    
  }

  Future<void> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        navigationInfoParameters:
            NavigationInfoParameters(forcedRedirectEnabled: true),
        uriPrefix: 'https://bakemycakevendor.page.link',
        link: Uri.parse(
            'https://bakemycakevendor/profile?Id=FKAEYVHnogOZvI4g6ba5'),
        androidParameters:
            AndroidParameters(packageName: 'com.example.bake2home'),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: "Find me at",
          description: 'Find my profile at bmc',
          imageUrl: Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe'),
        ));
    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    print('linkkkkkkkkk' +
        shortLink.shortUrl.toString() +
        "     " +
        shortLink.warnings.toString());
  }

  Future<void> getCartDetails(String uid) async {
    Stream<DocumentSnapshot> ss =
        FirebaseFirestore.instance.collection('Users').doc(uid).snapshots();
    ss.listen((event) {
      if (event.exists) {
        print('startting cartMap ${event.data()['cart']}');
        Map<String, dynamic> someMap = Map();
        if (event.data()['cart'] != null) {
          someMap = Map<String, dynamic>.from(event.data()['cart']);
        }
        setState(() {
          print('fetched shopId is $currentShopId');
          if (someMap.isNotEmpty) {
            cartMap = Map<String, dynamic>.from(someMap);
          }
          cartLengthNotifier.value = cartMap.length;
          currentShopId = someMap['shopId'].toString();
          print('cartMap is $cartMap');
        });
      }
    });
  }

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> subs ;
  bool internetStatus = true;
  @override
  Widget build(BuildContext context) {
    subs = _connectivity.onConnectivityChanged.listen((ConnectivityResult event) { 
      setState(() {
        print("No connection");
        if(event == ConnectivityResult.none){
          internetStatus = false;
        }else{
          internetStatus = true;
        }
      });
    });
    
    return Scaffold(
      body: internetStatus==true ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Center(
          child: Container(
              child: Image.asset(
            "assets/images/logo.png",
            height: 120,
          )),
        ),
        CircularProgressIndicator(),
      ]) : Text("No Connection"),
    );
  }

  @override
  void dispose(){
    super.dispose();
    subs.cancel();
    
  }
}
