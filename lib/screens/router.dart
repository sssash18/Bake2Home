import 'dart:math';

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
<<<<<<< HEAD

CollectionReference shopCollection = Firestore.instance.collection("Shops");
    Future<bool> getShops() async{
      QuerySnapshot shops = await shopCollection.getDocuments();
      shops.documents.forEach((element) {
          print(element.data['shopID']);
          Shop shop = _shopFromSnapshot(element);
          shopMap.putIfAbsent(shop.shopID, () => shop);
      });
      return true;
    }
    CollectionReference topCollection = Firestore.instance.collection("TopPicks");
    void getTopPick() async{
      QuerySnapshot top  = await topCollection.getDocuments();
        top.documents.forEach((element) {
          //print('top ${shopMap[element.data['shopID']]}');
          Shop shop = shopMap[element.data['shopID']];
          topPickMap.putIfAbsent(shop.shopID, () => shop);   
        });
    }

    Future<bool> getUser() async{
      DocumentSnapshot user = await Firestore.instance.collection("Users").document('94ON8vhE5kxa7SfOyBWJ').get();   
      currentUser.name = user.data['name'];
      currentUser.address = user.data['address'];
      currentUser.contact = user.data['contact'];   
      return true;
    }
  
    void getThings() async{
      await getShops();
      getTopPick();
      await getUser();
    }
  // String genID(DocumentReference doc){
  //   String res = doc.documentID;
  //   Random ran = new Random();
  //   ran.nextInt(9000);
  //   res += '-${Timestamp.now().millisecondsSinceEpoch.toString() + ran.nextInt(9000).toString()}';
  //   return res;
  // }
 @override
  void initState() {
    super.initState(); 
    getThings();
  // int i =0;
  // for(i=0;i<6;i++){
  //   DocumentReference docRef = shopCollection.document();
  //   String itemID1 = genID(docRef);
  //   String itemID2 = genID(docRef);    
  //   String itemID3 = genID(docRef);
  //   String itemID4 = genID(docRef);
  //   String itemID5 = genID(docRef);
  //   String itemID6 = genID(docRef);
  //   docRef.setData(
  //     {
  //       'shopID' : docRef.documentID,
  //       'shopName' : 'DessertTown',
  //       'shopAddress' : 'ABC Colony',
  //       'contact' : '2233434343',
  //       'merchantName': 'Aman Bhai',
  //       'rating' : 4.2,
  //       'numOrders' : 450,
  //       'experience' : '2+ years',
  //       'profilePhoto' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //       'coverPhoto' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //       'tagline' : 'Utterly',
  //       'bio' : 'Good shop',
  //       'cookTime' : {
  //         'cake' : '2 hours',
  //         'cookie' : '1 hour',
  //         'chocolate' : '2 days'
  //       },
  //       'items' : {
  //         'cake' : {
  //           'standard' : {
  //             itemID1 : {
  //               'itemID' : itemID1,
  //               'itemName' : 'Chocolate Cake',
  //               'availability' : true,
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemID1}-1#00' : {
  //                   'vid' : '${itemID1}-1#00',
  //                   'size' : 1,
  //                   'price' : 450,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'ingPrice' : 200,
  //               'recipe' : "Good to make",

  //             }
  //           },
  //           'customised' : {
  //             itemID2: {
  //               'itemID' : itemID2,
  //               'availability' : true,
  //               'itemName' : 'PUBG Cake',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemID2}-1#00' : {
  //                   'vid' : '${itemID2}-1#00',
  //                   'size' : 1,
  //                   'price' : 550,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'ingPrice' : 120,
  //               'recipe' : "Good to make",

  //             }

  //           }
  //         },
  //         'cookie' : {
  //           'standard' : {
  //             itemID3 : {
  //               'itemID' : itemID3,
  //               'availability' : true,
  //               'itemName' : 'Dry Fruit cookie',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemID3}-1#00' : {
  //                   'vid' : '${itemID3}-1#00',
  //                   'size' : 1,
  //                   'price' : 90,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'ingPrice' : 400,
  //               'recipe' : "Good to make",
  //               'ingPrice' : 110,

  //             }
  //           },
  //           'customised' : {
  //             itemID4 : {
  //               'itemID' : itemID4,
  //               'availability' : true,
  //               'itemName' : 'ChocoVanilla cookie',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemID4}-1#50' : {
  //                   'vid' : '${itemID4}-1#50',
  //                   'size' : 1.5,
  //                   'price' : 120,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'ingPrice' : 150,
  //               'recipe' : "Good to make",

  //             }

  //           }
  //         },
  //         'chocolate' : {
  //           'standard' : {
  //             itemID5 : {
  //               'itemID' : itemID5,
  //               'availability' : true,
  //               'itemName' : 'White Chocolate',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemID5}-1#00' : {
  //                   'vid' : '${itemID5}-1#00',
  //                   'size' : 1,
  //                   'price' : 200,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'ingPrice' : 200,
  //               'recipe' : "Good to make",

  //             }
  //           },
  //           'customised' : {
  //             itemID6 : {
  //               'itemID' : itemID6,
  //               'availability' : true,
  //               'itemName' : 'Choco Delight',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemID6}-1#00' : {
  //                   'vid' : '${itemID6}-1#00',
  //                   'size' : 1,
  //                   'price' : 600,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'ingPrice' : 200,
  //               'recipe' : "Good to make",
=======
  CollectionReference shopCollection = Firestore.instance.collection("Shops");
  CollectionReference topCollection = Firestore.instance.collection("TopPicks");
  @override
  void initState() {
    super.initState();
    getThings();
  }
>>>>>>> 5051cc4325eb5b0711fc8d7b3abf0e0721f0c90c

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
      ingPrice: doc.data['ingPrice'],
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
