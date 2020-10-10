import 'package:cloud_firestore/cloud_firestore.dart';

class Order {
  String shopId,
      userId,
      orderId,
      status,
      paymentType,
      comments,
      instructions,
      deliveryAddress;
  String reason;
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
    this.instructions,
    this.amount,
    this.delCharges,
    this.pickUp,
    this.orderTime,
    this.deliveryTime,
    this.reason,
    this.deliveryAddress,
    this.items,
    this.comments,
    this.refund,
    this.codAmount,
  });
}
