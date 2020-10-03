import 'dart:async';
import 'dart:math';

import 'package:bake2home/constants.dart';
import 'package:bake2home/functions/customisedItemModel.dart';
import 'package:bake2home/screens/Address.dart';
import 'package:bake2home/screens/customised.dart';
import 'package:bake2home/services/PushNotification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bake2home/functions/user.dart' as LocalUser;
import 'package:bake2home/functions/order.dart';
import 'package:http/http.dart';
import 'package:upi_india/upi_response.dart';

class DatabaseService {
  final CollectionReference shopCollection =
      FirebaseFirestore.instance.collection('Shops');
  final CollectionReference statusCollection =
      FirebaseFirestore.instance.collection('Status');
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("Users");
  final CollectionReference orderCollection =
      FirebaseFirestore.instance.collection("Orders");
  final String uid;

  DatabaseService({this.uid});

  Future<void> getDeliveryToken(){
    FirebaseFirestore.instance.collection("Delivery").doc('token').get().then((value) => deliveryToken = value.data()['token']);
  }

  Future<bool> updateTransaction(
      Order order, UpiResponse response, double codAmount) async {
    bool rs = false;
    await orderCollection
        .doc(order.orderId)
        .update({
          'codAmount': codAmount,
          'status': "PAID",
          'transaction': {
            'transactionId': response.transactionId,
            'transactionRefId': response.transactionRefId,
            'responseCode': response.responseCode,
            'appRefNo': response.approvalRefNo,
            'status': response.status,
          }
        })
        .then((value) => rs = true)
        .catchError((e) => rs = false);
    return rs;
  }

  Future<bool> submitReview(String shopId, String review, int rating) async {
    bool rs = false;
    int nums = shopMap[shopId].reviews.length;
    shopMap[shopId].reviews.add(review);

    double ratingFinal = (shopMap[shopId].rating + rating) / (nums + 1);
    await shopCollection
        .doc(shopId)
        .update({
          'rating': ratingFinal,
          'reviews': shopMap[shopId].reviews,
        })
        .then((value) => rs = true)
        .catchError((e) => rs = false);
    return rs;
  }

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

  Future<bool> updateToken(String id) async {
    bool rs = false;
    String token = await firebaseMessaging.getToken();
    await userCollection
        .doc(id)
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

  Future<bool> createToken(String id) async {
    bool rs = false;
    String token = await firebaseMessaging.getToken();
    await userCollection
        .doc(id)
        .set({
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
    bool rs;
    DocumentSnapshot doc = await orderCollection.doc('counter').get();
    counter = doc.data()['counter'];
    int random = Random().nextInt(9999);
    String orderId = "bmc" + random.toString() + counter.toString();
    orderCollection.doc('counter').update({
      'counter': FieldValue.increment(1),
    });
    order.orderId = orderId;
    await orderCollection
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
          'items': order.items,
          'codAmount': 0,
        })
        .then((value) => {rs = true, print("Order Placed")})
        .catchError((e) {
          rs = false;
          print(e.toString());
        });
    return rs;
  }

  getRefundAmount(Order order) {
    double refundAmount = 0;
    if ((DateTime.now().day < order.orderTime.toDate().day )&& DateTime.now().month == order.orderTime.toDate().month && DateTime.now().year == order.orderTime.toDate().year) 
    {
      refundAmount = order.amount - order.codAmount;
    } else {
      refundAmount = 0;
    }
    return refundAmount;
  }

  Future<bool> cancelOrder(Order order) async {
    double refundAmount = getRefundAmount(order);
    double compensationAmount =
        max(0, (order.amount - refundAmount) - 0.05 * order.amount);

    order.refund = refundAmount;
    bool rs = false;
    await orderCollection.doc(order.orderId).update({
      'status': "CANCELLED",
      'refund': refundAmount,
      'compensation': compensationAmount,
    }).then((value) {
      rs = true;
      pushNotification.pushMessagewithCancel(
          "Order ${order.orderId} cancelled by ${currentUser.name}",
          "Compensation Amount: ${compensationAmount.truncate()}",
          shopMap[order.shopId].token,
          order.orderId)
          ;
    }).catchError((e) {
      print(e.toString());
      rs = false;
    });
    return rs;
  }

  Future<bool> missOrderUpdate(String orderId) async {
    bool rs;
    await orderCollection.doc(orderId).update({
      'status': 'MISSED',
    }).catchError((e) {
      print(e.toString());
      rs = false;
    }).then((value) => {rs = true});
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
        .orderBy('orderTime', descending: true)
        .snapshots()
        .map((_ordersFromSnapshot));
  }

  Stream<bool> get status {
    bool getStatus(DocumentSnapshot doc) {
      return doc.data()['status'];
    }

    return statusCollection.doc('status').snapshots().map(getStatus);
  }

  Stream<List<Order>> orderUpdate(String orderId) {
    return orderCollection
        .where('orderId', isEqualTo: orderId)
        .snapshots()
        .map((_ordersFromSnapshot));
  }

  List<Order> _ordersFromSnapshot(QuerySnapshot snapshot) {
    snapshot.docs.forEach((element) {
      print(element.data()['orderId']);
    });
    return snapshot.docs
        .map((e) => Order(
            userId: e.data()['userId'],
            shopId: e.data()['shopId'],
            status: e.data()['status'],
            otp: e.data()['otp'],
            paymentType: e.data()['paymentType'],
            amount: e.data()['amount'].toDouble(),
            delCharges: e.data()['deliveryCharges'].toDouble(),
            pickUp: e.data()['pickUp'],
            orderTime: e.data()['orderTime'],
            deliveryTime: e.data()['deliveryTime'],
            deliveryAddress: e.data()['deliveryAddress'],
            items: e.data()['items'],
            codAmount: (e.data()['codAmount'] ?? 0).toDouble(),
            orderId: e.data()['orderId'],
            comments: e.data()['comments']))
        .toList();
  }

  StreamController getItemList(
      String shopId, String itemType, String category) {
    StreamController il = new StreamController();
    List<CustomisedItemModel> list = new List();
    FirebaseFirestore.instance
        .collection('Shops')
        .doc(shopId)
        .snapshots()
        .listen((event) {
      list.clear();
      Map<String, dynamic> allItems =
          Map.from(event.data()['items'][itemType][category]);
      allItems.forEach((key, value) {
        Map<String, dynamic> dup = value['variants'];
        Map<String, dynamic> variants = Map();
        Map<String, dynamic> idtoprice = Map();
        dup.forEach((key, value) {
          idtoprice.putIfAbsent(key, () => value['price']);
        });
        List<dynamic> prices = idtoprice.values.toList();
        prices.sort((a, b) {
          return a.compareTo(b);
        });
        prices.forEach((element) {
          idtoprice.forEach((key, value) {
            if (value == element) {
              variants.putIfAbsent(key, () => dup[key]);
            }
          });
        });
        CustomisedItemModel model = CustomisedItemModel(
            itemId: value['itemId'],
            ingredients: List<String>.from(value['ingredients']),
            itemName: value['itemName'],
            itemCategory: value['itemCategory'],
            photoUrl: value['photoUrl'],
            recipe: value['recipe'],
            minTime: value['minTime'].toDouble(),
            variants: variants,
            flavours: List<String>.from(value['flavours']));
        list.add(model);
      });
      il.sink.add(list);
    });
    return il;
  }
}
