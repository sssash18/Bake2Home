
import 'package:bake2home/functions/category.dart';
import 'package:bake2home/screens/homepage.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/constants.dart';


class Router extends StatefulWidget {

  @override
  _RouterState createState() => _RouterState();
}

class _RouterState extends State<Router> {
  CollectionReference shopCollection = FirebaseFirestore.instance.collection("Shops");
  CollectionReference topCollection = FirebaseFirestore.instance.collection("TopPicks");
  CollectionReference categoryCollection = FirebaseFirestore.instance.collection("Categories");
  @override
  void initState() {
    super.initState();
    getThings();
    getCardDetails();
    //createDynamicLink();
    initDynamicLinks();
  }
  Future<void> initDynamicLinks() async{
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData link) async{
        final Uri deeplink = link?.link;
        if(deeplink!=null){
          final String param = deeplink.queryParameters['Id'];
          print(param);
          Shop shop = shopMap[param];
          print(shop.shopName);
          Navigator.pushNamed(context, deeplink.path,arguments: shop);
        }
      },
      onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
      }
    );
    final PendingDynamicLinkData link  = await FirebaseDynamicLinks.instance.getInitialLink();
    //FirebaseDynamicLinks.instance.getDynamicLink(url);
    final Uri deeplink = link?.link;
    print( "LLLLL" + deeplink.toString());
  }

  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //initDynamicLinks();
  }

  

  void getThings() async{
      await getShops();
      getTopPick();
      await getUser();
      getCategories();
  }

  Future<bool> getUser() async{
      DocumentSnapshot user = await FirebaseFirestore.instance.collection("Users").doc('94ON8vhE5kxa7SfOyBWJ').get();   
      currentUser.name = user.data()['name'];
      currentUser.addresses = user.data()['addresses'];
      currentUser.contact = user.data()['contact'];   
      return true;
  }

  Future<bool> getShops() async {
    QuerySnapshot shops = await shopCollection.get();
    shops.documents.forEach((element) {
      Shop shop = _shopFromSnapshot(element);
      shopMap.putIfAbsent(shop.shopId, () => shop);
    });
    return true;
  }

  Future<void> getCategories() async{
    QuerySnapshot categories = await categoryCollection.get();
    categories.docs.forEach((element) { 
      Category cat = Category(name: element.id,photoUrl: element.data()['photoUrl']);
      categoryList.add(cat);
    });
    print(categoryList);
  }
  void getTopPick() async {
    await topCollection.getDocuments().then((value) {
      value.documents.forEach((element) {
        Shop shop = shopMap[element.data()['shopId']];
        topPickMap.putIfAbsent(shop.shopId, () => shop);
      });
    });
  }

  Shop _shopFromSnapshot(DocumentSnapshot document){
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
      rating: document.data()['rating'].toDouble(),
      ingPrice: document.data()['ingPrice'],
    );
  }

  Future<void> createDynamicLink() async{
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      navigationInfoParameters: NavigationInfoParameters(forcedRedirectEnabled: true),
      uriPrefix: 'https://bakemycakevendor.page.link', 
      link: Uri.parse('https://bakemycakevendor/profile?Id=FKAEYVHnogOZvI4g6ba5'),
      androidParameters: AndroidParameters(packageName: 'com.example.bake2home'),
      socialMetaTagParameters: SocialMetaTagParameters(
        title : "Find me at",
        description : 'Find my profile at bmc',
        imageUrl: Uri.parse('https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe'),
      )
    );
    final dynamicLink = await parameters.buildUrl();
    final ShortDynamicLink shortLink = await parameters.buildShortLink();
    print('linkkkkkkkkk' + shortLink.shortUrl.toString() +"     " + shortLink.warnings.toString());
    
  }

  Future<void> getCardDetails() async {
    Stream<DocumentSnapshot> ss = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserID)
        .snapshots();
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

          // if (someMap.containsKey('orderId')) {
          //   // orderId = someMap['orderId'];
          //   // if (someMap['status'] == 'pending') {
          //   //   orderPending = ()true;
          //   // } else if (someMap['status'] == 'accepted') {
          //   //   orderPending = true;
          //   //   orderAccepted = true;
          //   // }
          // }
          // print('map us $cartMap or some is $someMap in streeam');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [FlatButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (BuildContext context) => HomePage()
              ));
            },
            child: Text("HomePage")),
            Image.asset("assets/images/logo.png",height: 250,),
            ]
        ),
      ),
    );
  }
}