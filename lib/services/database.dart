import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final CollectionReference shopCollection = Firestore.instance.collection('Shops');
  final CollectionReference userCollection  = Firestore.instance.collection("Users");
  final String uid;

  DatabaseService({this.uid});

  void updateUserDetails(String name,String address) async{
    await userCollection.document(uid).updateData(
      {
        'name' : name,
        'address' : address,
      }
    );
  }
}