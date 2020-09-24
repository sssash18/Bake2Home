import 'dart:async';
import 'dart:math';

import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/Address.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bake2home/functions/user.dart' as LocalUser;
import 'package:bake2home/functions/order.dart';

class DatabaseService {
  final CollectionReference shopCollection =
      FirebaseFirestore.instance.collection('Shops');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection("Orders");
  final String uid;

  DatabaseService({this.uid});

  Future<bool> createUser(String name, String uid, String contact,
      Map<dynamic, dynamic> address) async {
    String token = await firebaseMessaging.getToken();
    bool rs = false;
    currentUser = FirebaseAuth.instance.currentUser != null
        ? LocalUser.MyUser(
            uid: FirebaseAuth.instance.currentUser.uid,
            contact: contact,
            name: name,
            addresses: address)
        : LocalUser.MyUser();
    await userCollection.doc(uid).set({
      'name': name,
      'contact': contact,
      'uid': uid,
      'token': token,
      'cart': {},
      'addresses': address
    }).then((value) {
      rs = true;
    }).catchError((e) {
      rs = false;
    });
    return rs;
  }

  Future<bool> updateToken(String token) async {
    bool rs = false;
    await userCollection
        .doc(uid)
        .update({
          'token': token,
        })
        .then((value) => rs = true)
        .catchError((e) {
          print(e.toString());
          rs = false;
        });
    return rs;
  }

  Future<bool> updateUserDetails(String name) async {
    bool rs = false;
    await userCollection
        .doc(uid)
        .update({
          'name': name,
        })
        .then((value) => rs = true)
        .catchError((e) {
          print(e.toString());
          rs = false;
        });
    return rs;
  }

  Future<bool> deleteAddress(String key) async {
    bool rs = false;
    currentUser.addresses.remove(key);
    await userCollection
        .doc(uid)
        .update({
          'addresses': currentUser.addresses,
        })
        .then((value) => rs = true)
        .catchError((e) {
          print(e.toString());
          rs = false;
        });
    return rs;
  }

  Future<bool> addAddress(Map newAddress) async {
    bool rs = false;
    currentUser.addresses.putIfAbsent(
        Timestamp.now().microsecondsSinceEpoch.toString(), () => newAddress);
    await userCollection
        .doc(uid)
        .update({'addresses': currentUser.addresses})
        .then((value) => rs = true)
        .catchError((e) {
          print(e.toString());
          rs = false;
        });
    return rs;
  }

  Future<bool> updateCart(Map cart) async {
    bool rs = false;
    await userCollection
        .doc(uid)
        .update({'cart': cart})
        .then((value) => rs = true)
        .catchError((e) {
          print(e.toString());
          rs = false;
        });
    return rs;
  }

  Future<bool> createOrder(Order order) async {
    int counter;
    bool rs = false;
    DocumentSnapshot doc = await orderCollection.doc('counter').get();
    counter = doc.data()['counter'];
    int random = Random().nextInt(9999);
    String orderId = "bmc" + random.toString() + counter.toString();
    orderCollection.doc('counter').update({
      'counter': FieldValue.increment(1),
    });
    order.orderId = orderId;

    orderCollection
        .doc(orderId)
        .set({
          'orderId': order.orderId,
          'shopId': order.shopId,
          'userId': order.userId,
          'status': order.status,
          'otp': order.otp,
          'paymentType': order.paymentType,
          'deliveryAddress': order.deliveryAddress,
          'amount': order.amount,
          'deliveryCharges': order.delCharges,
          'pickUp': order.pickUp,
          'orderTime': order.orderTime,
          'deliveryTime': order.deliveryTime,
          'items': order.items
        })
        .then((value) => {rs = true, print("Order Placed")})
        .catchError((e) {
          rs = false;
          print(e.toString());
        });
    return rs;
  }

  

  Future<bool> cancelOrder(Order order) async {
    double refundAmount=0;
    if(DateTime.now().isBefore(order.orderTime.toDate().add(Duration(hours: 1)).add(Duration(minutes: 30))) == true ){
      refundAmount = order.amount;
    }else{
      if(order.cod==false){
        refundAmount = 0;
      }else{
        refundAmount = (100 - shopMap[order.shopId].advance)/100 * order.amount;
      }
    }
    order.refund = refundAmount;
    bool rs = false;
    await orderCollection
        .doc(order.orderId)
        .update({
          'status': "CANCELLED",
          'refund' : refundAmount,
        })
        .then((value) => rs = true)
        .catchError((e) {
          print(e.toString());
          rs = false;
        });
    return rs;
  }

  Future<bool> emptyCart() async {
    bool rs = false;
    await userCollection
        .doc(uid)
        .update({
          'cartMap': Map(),
        })
        .then((value) => rs = true)
        .catchError((e) {
          print(e.toString());
          rs = false;
        });
    return rs;
  }

  Stream<List<Order>> get orders {
    return orderCollection
        .where('userId', isEqualTo: currentUserID)
        .snapshots()
        .map((_ordersFromSnapshot));
  }

  Stream<List<Order>>  orderUpdate(String orderId){
    return orderCollection.where('orderId',isEqualTo: orderId).snapshots().map(( _ordersFromSnapshot));
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
      orderId: e.data()['orderId'],
      comments: e.data()['comments']
    )).toList();
  }

  
}

