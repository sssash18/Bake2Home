
import 'package:bake2home/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bake2home/functions/shop.dart';
import 'package:bake2home/constants.dart';


class Router extends StatefulWidget {

  @override
  _RouterState createState() => _RouterState();
}

class _RouterState extends State<Router> {
  CollectionReference shopCollection = Firestore.instance.collection("Shops");
  CollectionReference topCollection = Firestore.instance.collection("TopPicks");
  @override
  void initState() {
    super.initState();
    getThings();
    getCardDetails();
  }

  void getThings() async{
      await getShops();
      getTopPick();
      await getUser();
  }

  Future<bool> getUser() async{
      DocumentSnapshot user = await Firestore.instance.collection("Users").document('94ON8vhE5kxa7SfOyBWJ').get();   
      currentUser.name = user.data['name'];
      currentUser.addresses = user.data['address'];
      currentUser.contact = user.data['contact'];   
      return true;
  }

  Future<bool> getShops() async {
    QuerySnapshot shops = await shopCollection.getDocuments();
    shops.documents.forEach((element) {
      Shop shop = _shopFromSnapshot(element);
      shopMap.putIfAbsent(shop.shopId, () => shop);
    });
    return true;
  }

  void getTopPick() async {
    await topCollection.getDocuments().then((value) {
      value.documents.forEach((element) {
        Shop shop = shopMap[element.data['shopId']];
        topPickMap.putIfAbsent(shop.shopId, () => shop);
      });
    });
  }

  Shop _shopFromSnapshot(DocumentSnapshot doc){
    return Shop(
      shopId: doc.data['shopId'],
      shopName: doc.data['shopName'],
      shopAddress: doc.data['shopAddress'],
      contact: doc.data['contact'],
      merchantName: doc.data['merchantName'],
      tagline: doc.data['tagline'],
      bio: doc.data['bio'],
      profilePhoto: doc.data['profilePhoto'],
      coverPhoto: doc.data['coverPhoto'],
      cookTime: doc.data['cookTime'],
      experience: doc.data['experience'],
      numOrders: doc.data['numOrders'],
      items: doc.data['items'],
      rating: doc.data['rating'].toDouble(),
      ingPrice: doc.data['ingPrice'],
    );
  }

  Future<void> getCardDetails() async {
    Stream<DocumentSnapshot> ss = Firestore.instance
        .collection('Users')
        .document(currentUserID)
        .snapshots();
    ss.listen((event) {
      if (event.exists) {
        print('startting cartMap ${event.data['cart']}');
        Map<String, dynamic> someMap = Map();
        if (event.data['cart'] != null) {
          someMap = Map<String, dynamic>.from(event.data['cart']);
        }
        setState(() {
          print('fetched shopId is $currentShopId');
          if (someMap.isNotEmpty) {
            cartMap = Map<String, dynamic>.from(someMap['items']);
          }
          cartLengthNotifier.value = cartMap.length;
          currentShopId = someMap['shopId'].toString();
          print('cartMap is $cartMap');

          // if (someMap.containsKey('orderId')) {
          //   // orderId = someMap['orderId'];
          //   // if (someMap['status'] == 'pending') {
          //   //   orderPending = true;
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
            Image.asset("assets/images/logo.png",height: 250,)
            ]
        ),
      ),
    );
  }
}