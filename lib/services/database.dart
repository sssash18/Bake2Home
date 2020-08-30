import 'dart:math';

import 'package:bake2home/constants.dart';
import 'package:bake2home/screens/Address.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bake2home/functions/order.dart';


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

  Future<void> createOrder(Order order) async{
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

  Stream<List<Order>> get orders{
    return orderCollection.where('userId',isEqualTo : currentUserID).snapshots().map((_ordersFromSnapshot));
  }

  List<Order> _ordersFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((e) => Order(
      userId : e['userId'],
      shopId: e['shopId'],
      status: e['status'],
      otp : e['otp'],
      paymentType: e['paymentType'],
      amount: e['amount'],
      delCharges: e['deliveryCharges'],
      pickUp: e['pickUp'],
      orderTime: e['orderTime'],
      deliveryTime: e['deliveryTime'],
      deliveryAddress: e['deliveryAddress'],
      items: e['items'],
      orderId: e['orderId']
    )).toList();
  }
  
}