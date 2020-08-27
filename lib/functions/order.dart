import 'package:cloud_firestore/cloud_firestore.dart';

class Order{
  String shopId,
  userId,
  orderId,
  status,
  paymentType,
  deliveryAddress;

  double amount,
  delCharges;

  int otp;
  bool pickUp;

  String orderTime,deliveryTime;

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
  });
}