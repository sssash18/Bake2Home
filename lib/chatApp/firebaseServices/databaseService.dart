import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class UserModel{
  final String email;
  UserModel({this.email});
}
class DatabaseService{
  final String uid;
  DatabaseService({this.uid});
  final CollectionReference _collectionReference
  =Firestore.instance.collection('myUsers');

  Future addMyUser(String uid,String email) async {
    try {
      return await _collectionReference.document(uid).setData({
        'uid': uid,
        'email': email,
      });
    }
    catch(e){
      print(e.toString());
    }
  }
}