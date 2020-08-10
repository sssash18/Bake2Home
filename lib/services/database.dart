import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bake2home/functions/shop.dart';

class DatabaseService{

  final CollectionReference shopCollection = Firestore.instance.collection('Shops');
  final String uid;

  DatabaseService({this.uid});

  Stream<List<Shop>> get shops{
    return shopCollection.snapshots().map(_shoplistFromSnapshot);
  }

  List<Shop> _shoplistFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) => Shop(
      shopID: doc.data['shopID'],
      shopName: doc.data['shopName'],
      shopAddress: doc.data['shopAddress'],
      contact: doc.data['contact'],
      merchantName: doc.data['merchantName'],
      tagline: doc.data['tagline'],
      bio: doc.data['bio'],
      profilePhoto: doc.data['profilePhoto'],
      coverPhoto: doc.data['coverPhoto'],
      cookTime: {
        'cake' : doc.data['cookTime']['cake'],
        'cookie' : doc.data['cookie'],
        'chocolate' : doc.data['chocolate'],
      }
    )).toList();
  }
}