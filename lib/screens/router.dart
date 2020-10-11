import 'dart:async';

import 'package:bake2home/functions/category.dart';
import 'package:bake2home/functions/customisedItemModel.dart';
import 'package:bake2home/functions/trending.dart';
import 'package:bake2home/functions/user.dart';
import 'package:bake2home/screens/VendorProfile.dart';
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

class _RouterState extends State<Router> with WidgetsBindingObserver {
  Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> subs;
  bool internetStatus = true;
  CollectionReference shopCollection =
      FirebaseFirestore.instance.collection("Shops");
  CollectionReference attrCollection =
      FirebaseFirestore.instance.collection("Attributions");
  CollectionReference topCollection =
      FirebaseFirestore.instance.collection("TopPicks");
  CollectionReference categoryCollection =
      FirebaseFirestore.instance.collection("Categories");
  CollectionReference deliveryCollection =
      FirebaseFirestore.instance.collection("DeliveryCharges");
  CollectionReference slidesCollection =
      FirebaseFirestore.instance.collection("Slides");
  CollectionReference trendCollection =
      FirebaseFirestore.instance.collection("Trending");
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _connectivity = Connectivity();
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
    getThings();
    //createDynamicLink();
  }

  @override
  void dispose() {
    super.dispose();
    subs.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: internetStatus
          ? Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Center(
                child: Container(
                    child: Image.asset(
                  "assets/images/logo.png",
                  height: 120,
                )),
              ),
              CircularProgressIndicator(),
            ])
          : Text("No Internet"),
    );
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData link =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(link, navigatorKey.currentContext);
    final Uri deeplink = link?.link;
    print("LLLLL" + deeplink.toString());
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData link) async {
      _handleDeepLink(link, navigatorKey.currentContext);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  void _handleDeepLink(PendingDynamicLinkData link, BuildContext context) {
    print("link:  " + '${link?.link}');
    Uri deepLink = link?.link;
    if (deepLink != null) {
      final String param = deepLink.queryParameters['Id'];
      print(param);
      Shop shop = shopMap[param];
      print(shop.shopName);
      print(deepLink.path);
      Navigator.of(context).pushNamed(deepLink.path, arguments: shop);
      print('cant Handle');
    }
  }

  void getThings() async {
    //await initDynamicLinks();
    await getSlides();
    await getShops();
    await getTopPick();
    bool done = false;
    await getUser().then((value) => done = true).catchError((e) {
      done = false;
    });
    await getAttr();
    await getCategories();
    await getTrending();
    await getDeliveryCharges();
    // await getCardDetails();

    (_auth.currentUser != null && done)
        ? Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()))
        : Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (BuildContext context) => SignIn()));
    await initDynamicLinks();
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
      if (user == null) {
        return false;
      }
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
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getSlides() async {
    bool rs = false;
    await slidesCollection.doc('slides').get().then((value) {
      value.data().forEach((key, value) {
        slidesUrl.add(value);
        rs = true;
      });
    });
    return rs;
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

  Future<void> getTrending() async {
    await trendCollection.get().then((value) {
      CustomisedItemModel model = CustomisedItemModel();
      value.docs.forEach((element) {
        print(element.toString());
        Map item = shopMap[element.data()['shopId']]
                .items[element.data()['itemCategory']]
            [element.data()['itemType']][element.id];
        print(item.toString());
        model.itemName = item['itemName'];
        model.ingredients = List<String>.from(item['ingredients']);
        model.itemCategory = item['itemCategory'];
        model.itemId = item['itemId'];
        model.minTime = item['minTime'].toDouble();
        model.photoUrl = item['photoUrl'];
        model.recipe = item['recipe'];
        model.variants = item['variants'];
        model.veg = item['veg'];
        model.flavours = List<String>.from(item['flavours']);

        Trending trend =
            Trending(shopId: element.data()['shopId'], model: model);
        trendingList.add(trend);
        print(trendingList.toString());
      });
    });
  }

  Future<void> getAttr() async {
    await attrCollection.get().then((value) {
      value.docs.forEach((element) {
        attr.add(element.data());
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
      variety: document.data()['variety'],
      items: document.data()['items'],
      rating: (document.data()['rating'] ?? 0).toDouble(),
      ingPrice: document.data()['ingPrice'],
      token: document.data()['token'],
      advance: document.data()['advance'].toDouble(),
      cod: document.data()['cod'],
      pickup: document.data()['pickUp'],
      recent: document.data()['recent'] == null
          ? []
          : List.from(document.data()['recent']),
      customTime: document.data()['customTime'].toDouble(),
      reviews: List<String>.from(document.data()['reviews']),
    );
  }

  Future<void> getDeliveryCharges() async {
    await deliveryCollection.doc('charges').get().then((value) {
      value.data().keys.forEach((element) {
        delChargesList.add(value.data()[element].toDouble());
      });
      print("DDDDDD ${delChargesList.toString()}");
    });
  }

  Future<void> createDynamicLink() async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        navigationInfoParameters:
            NavigationInfoParameters(forcedRedirectEnabled: true),
        uriPrefix: 'https://bakemycakevendor.page.link',
        link: Uri.parse(
            'https://bakemycakevendor/profile?Id=mDjoKJMdRZT7x3NN5bj9bJiUBFZ2'),
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
        // setState(() {
        print('fetched shopId is $currentShopId');
        if (someMap.isNotEmpty) {
          cartMap = Map<String, dynamic>.from(someMap);
        }
        cartLengthNotifier.value = cartMap.length;
        currentShopId = someMap['shopId'].toString();
        print('cartMap is $cartMap');
        // });
      }
    });
  }

  // Future<void> initDynamicLinks() async {
  //   final PendingDynamicLinkData link =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   _handleDeepLink(link);
  //   final Uri deeplink = link?.link;
  //   print("LLLLL" + deeplink.toString());
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData link) async {
  //     _handleDeepLink(link);
  //   }, onError: (OnLinkErrorException e) async {
  //     print('onLinkError');
  //     print(e.message);
  //   });
  // }

  // void _handleDeepLink(PendingDynamicLinkData link) {
  //   print("link:  " + '${link?.link}');
  //   Uri deepLink = link?.link;
  //   if (deepLink != null) {
  //     final String param = deepLink.queryParameters['Id'];
  //     print(param);
  //     Shop shop = shopMap[param];
  //     print(shop.shopName);
  //     print(deepLink.path);
  //     Navigator.pushNamed(context, deepLink.path, arguments: shop);
  //     print('cant Handle');
  //   }
  // }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('state: ' + state.toString());
      initDynamicLinks();
    }
  }
}
