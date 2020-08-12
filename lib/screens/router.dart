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
  }

  getThings() async {
    await getShops();
    getTopPick();
    await getUser();
  }

  Future<bool> getUser() async {
    DocumentSnapshot user = await Firestore.instance
        .collection("Users")
        .document('94ON8vhE5kxa7SfOyBWJ')
        .get();
    currentUser.name = user.data['name'];
    currentUser.address = user.data['address'];
    currentUser.contact = user.data['contact'];
    return true;
  }

  Future<bool> getShops() async {
    QuerySnapshot shops = await shopCollection.getDocuments();
    shops.documents.forEach((element) {
      Shop shop = _shopFromSnapshot(element);
      shopMap.putIfAbsent(shop.shopID, () => shop);
    });
    return true;
  }

  void getTopPick() async {
    await topCollection.getDocuments().then((value) {
      value.documents.forEach((element) {
        Shop shop = shopMap[element.data['shopID']];
        topPickMap.putIfAbsent(shop.shopID, () => shop);
      });
    });
  }

  Shop _shopFromSnapshot(DocumentSnapshot doc) {
    return Shop(
      shopID: doc.data['shopID'],
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()));
            },
            child: Text("HomePage")),
      ),
    );
  }
}
