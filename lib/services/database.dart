import 'dart:math';

import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/Address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class DatabaseService{

  final CollectionReference shopCollection = Firestore.instance.collection('Shops');
  final CollectionReference userCollection  = Firestore.instance.collection("Users");
  final CollectionReference orderCollection = Firestore.instance.collection("Orders");
  final String uid;

  DatabaseService({this.uid});

  void updateUserDetails(String name) async{
    await userCollection.document(uid).updateData(
      {
        'name' : name,
      }
    );
  }

  void deleteAddress(String key) async{
    currentUser.addresses.remove(key);
    await userCollection.document(uid).updateData(
      {
       'addresses' : currentUser.addresses, 
      }
    );
    print("Done");
  }

  Future<void> addAddress(Map newAddress) async {
    currentUser.addresses.putIfAbsent(Timestamp.now().microsecondsSinceEpoch.toString(), () => newAddress);
    await userCollection.document(uid).updateData({
      'addresses' : currentUser.addresses
    });
  }

  Future<void> updateCart(Map cart) async{
    await userCollection.document(uid).updateData({
      'cart' : cart
    });
    print("Updated");
  }

  Future<void> createOrder() async{
    int counter;
    DocumentSnapshot doc  = await orderCollection.document('counter').get();
    counter = doc.data['counter'];
    int random = Random().nextInt(9999);
    String orderId = "bmc" + random.toString() + counter.toString();
    orderCollection.document('counter').updateData(
      {
        'counter' : FieldValue.increment(1),
      }
    );
    


  }
  
}