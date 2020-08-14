
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
    Future<bool> getShops() async{
      QuerySnapshot shops = await shopCollection.getDocuments();
      shops.documents.forEach((element) {
          print(element.data['shopId']);
          Shop shop = _shopFromSnapshot(element);
          shopMap.putIfAbsent(shop.shopId, () => shop);
      });
      return true;
    }
    CollectionReference topCollection = Firestore.instance.collection("TopPicks");
    void getTopPick() async{
      QuerySnapshot top  = await topCollection.getDocuments();
        top.documents.forEach((element) {
          Shop shop = shopMap[element.data['shopId']];
          topPickMap.putIfAbsent(shop.shopId, () => shop);   
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
  //   String itemId1 = genID(docRef);
  //   String itemId2 = genID(docRef);    
  //   String itemId3 = genID(docRef);
  //   String itemId4 = genID(docRef);
  //   String itemId5 = genID(docRef);
  //   String itemId6 = genID(docRef);
  //   docRef.setData(
  //     {
  //       'shopId' : docRef.documentID,
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
  //             itemId1 : {
  //               'itemId' : itemId1,
  //               'itemName' : 'Chocolate Cake',
  //               'availability' : true,
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemId1}-1#00' : {
  //                   'vid' : '${itemId1}-1#00',
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
  //             itemId2: {
  //               'itemId' : itemId2,
  //               'availability' : true,
  //               'itemName' : 'PUBG Cake',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemId2}-1#00' : {
  //                   'vid' : '${itemId2}-1#00',
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
  //             itemId3 : {
  //               'itemId' : itemId3,
  //               'availability' : true,
  //               'itemName' : 'Dry Fruit cookie',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemId3}-1#00' : {
  //                   'vid' : '${itemId3}-1#00',
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
  //             itemId4 : {
  //               'itemId' : itemId4,
  //               'availability' : true,
  //               'itemName' : 'ChocoVanilla cookie',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemId4}-1#50' : {
  //                   'vid' : '${itemId4}-1#50',
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
  //             itemId5 : {
  //               'itemId' : itemId5,
  //               'availability' : true,
  //               'itemName' : 'White Chocolate',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemId5}-1#00' : {
  //                   'vid' : '${itemId5}-1#00',
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
  //             itemId6 : {
  //               'itemId' : itemId6,
  //               'availability' : true,
  //               'itemName' : 'Choco Delight',
  //               'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/bakemycake-1d1dc.appspot.com/o/atom.png?alt=media&token=789c85bc-5234-4fb9-a317-957f98bb0abe',
  //               'variants' : {
  //                 '${itemId6}-1#00' : {
  //                   'vid' : '${itemId6}-1#00',
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