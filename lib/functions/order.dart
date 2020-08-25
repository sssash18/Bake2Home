import 'package:cloud_firestore/cloud_firestore.dart';

class Order{
  String shopId,
  userId,
  orderId,
  status,
  otp,
  paymentType,
  deliveryAddress;

  int amount,
  delCharges;

  bool pickUp;

  Timestamp orderTime,deliveryTime;

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
  });
}