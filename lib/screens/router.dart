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
 @override
  void initState() {
    super.initState();
    Firestore instance = Firestore.instance;
    CollectionReference shopCollection = instance.collection("Shops");
    Future<QuerySnapshot> shops = shopCollection.getDocuments();
    shops.then((value){
      value.documents.forEach((element) {
        Shop shop = _shopFromSnapshot(element);
        shopMap.putIfAbsent(shop.shopID, () => shop);
      });
    });
    CollectionReference topCollection = instance.collection("TopPicks");
    Future<QuerySnapshot> top  = topCollection.getDocuments();
    top.then(
      (value){
        value.documents.forEach((element) {
          Shop shop = shopMap[element.data['shopID']];
          topPickMap.putIfAbsent(shop.shopID, () => shop);   
        });
      }
    );
  // int i =0;
  // for(i=0;i<6;i++){
  //   shopCollection.document().setData(
  //     {
  //       'shopID' : '',
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
  //             '1' : {
  //               'itemID' : 1,
  //               'itemName' : 'Chocolate Cake',
  //               'availability' : true,
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 'v1' : {
  //                   'size' : 1,
  //                   'price' : 450,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'recipe' : "Good to make",

  //             }
  //           },
  //           'customised' : {
  //             '1' : {
  //               'itemID' : 1,
  //               'availability' : true,
  //               'itemName' : 'PUBG Cake',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 'v1' : {
  //                   'size' : 1,
  //                   'price' : 550,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'recipe' : "Good to make",

  //             }

  //           }
  //         },
  //         'cookie' : {
  //           'standard' : {
  //             '1' : {
  //               'itemID' : 1,
  //               'availability' : true,
  //               'itemName' : 'Dry Fruit cookie',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 'v1' : {
  //                   'size' : 1,
  //                   'price' : 90,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'recipe' : "Good to make",

  //             }
  //           },
  //           'customised' : {
  //             '1' : {
  //               'itemID' : 1,
  //               'availability' : true,
  //               'itemName' : 'ChocoVanilla cookie',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 'v1' : {
  //                   'size' : 1,
  //                   'price' : 120,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'recipe' : "Good to make",

  //             }

  //           }
  //         },
  //         'chocolate' : {
  //           'standard' : {
  //             '1' : {
  //               'itemID' : 1,
  //               'availability' : true,
  //               'itemName' : 'White Chocolate',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 'v1' : {
  //                   'size' : 1,
  //                   'price' : 200,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'recipe' : "Good to make",

  //             }
  //           },
  //           'customised' : {
  //             '1' : {
  //               'itemID' : 1,
  //               'availability' : true,
  //               'itemName' : 'Choco Delight',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 'v1' : {
  //                   'size' : 1,
  //                   'price' : 600,
  //                 }
  //               },
  //               'ingredients' : {
  //                 'flour' : '500g',
  //                 'sugar' : '1 Kg',
  //               },
  //               'recipe' : "Good to make",

  //             }

  //           }
  //         },
  //      }
  //   }

  // );
  // }
  

  }

  Shop _shopFromSnapshot(DocumentSnapshot doc){
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
      rating: doc.data['rating'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: FlatButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (BuildContext context) => HomePage()
            ));
          },
          child: Text("HomePage")),
      ),
    );
  }
}