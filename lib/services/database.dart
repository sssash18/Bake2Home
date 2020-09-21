import 'dart:async';
import 'dart:math';

import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/Address.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:bake2home/functions/order.dart';


class DatabaseService{

  final CollectionReference shopCollection = FirebaseFirestore.instance.collection('Shops');
  final CollectionReference userCollection  = FirebaseFirestore.instance.collection("Users");
  final CollectionReference orderCollection = FirebaseFirestore.instance.collection("Orders");
  final String uid;

  DatabaseService({this.uid});

  void createUser(String name,String uid,String contact) async{
    String token = await firebaseMessaging.getToken();
    await userCollection.doc(uid).set({
      'name' : name,
      'contact' : contact,
      'uid' : uid,
      'token' : token,
      'cart' : {},
      'addresses' : {}
    });
  }

  void updateToken(String token) async{
    await userCollection.doc(uid).update({
      'token' : token,
    });
  }

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

  Future<void> createOrder(Order order) async{
    int counter;
    DocumentSnapshot document  = await orderCollection.document('counter').get();
    counter = document.data()['counter'];
    int random = Random().nextInt(9999);
    String orderId = "bmc" + random.toString() + counter.toString();
    orderCollection.document('counter').updateData(
      {
        'counter' : FieldValue.increment(1),
      }
    );
    order.orderId = orderId;
    orderCollection.document(orderId).setData({
      'orderId' : order.orderId,
      'shopId' : order.shopId,
      'userId' : order.userId,
      'status' : order.status,
      'otp' : order.otp,
      'paymentType' : order.paymentType,
      'deliveryAddress' : order.deliveryAddress,
      'amount' : order.amount,
      'deliveryCharges' : order.delCharges,
      'pickUp' : order.pickUp,
      'orderTime' : order.orderTime,
      'deliveryTime' : order.deliveryTime,
      'items' : order.items 
    }).then((value) => print("Order Places"));
  }

  Future<void> cancelOrder(String orderId){
    orderCollection.document(orderId).updateData(
      {
        'status' : "CANCELLED",
      }
    );
    
  }

  Future<void> emptyCart(){
    userCollection.document(uid).update(
      {
        'cartMap' : Map(),
      }
    );
  }

  

  Stream<List<Order>> get orders{
    return orderCollection.where('userId',isEqualTo : currentUserID).snapshots().map((_ordersFromSnapshot));
  }

  List<Order> _ordersFromSnapshot(QuerySnapshot snapshot){
    
    return snapshot.docs.map((e) => Order(
      userId : e.data()['userId'],
      shopId: e.data()['shopId'],
      status: e.data()['status'],
      otp : e.data()['otp'],
      paymentType: e.data()['paymentType'],
      amount: e.data()['amount'],
      delCharges: e.data()['deliveryCharges'],
      pickUp: e.data()['pickUp'],
      orderTime: e.data()['orderTime'],
      deliveryTime: e.data()['deliveryTime'],
      deliveryAddress: e.data()['deliveryAddress'],
      items: e.data()['items'],
      orderId: e.data()['orderId']
    )).toList();
  }
  
}