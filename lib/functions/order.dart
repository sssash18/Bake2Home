import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String shopId,
      userId,
      orderId,
      status,
      paymentType,
      comments,
      deliveryAddress;

  double amount, refund = 0, delCharges;

  int otp;
  bool pickUp;
  double codAmount;

  Timestamp orderTime, deliveryTime;

  Map items;

  Order({
    this.userId,
    this.shopId,
    this.orderId,
    this.status,
    this.otp,
    this.paymentType,
    this.amount,
    this.delCharges,
    this.pickUp,
    this.orderTime,
    this.deliveryTime,
    this.deliveryAddress,
    this.items,
    this.comments,
    this.codAmount,
  });
}
