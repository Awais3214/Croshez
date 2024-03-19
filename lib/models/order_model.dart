// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? address;
  String? orderStatus;
  Timestamp? orderTime;
  String? paymentMethod;
  String? paymentStatus;
  List? products;
  int? shippingPrice;
  int? totalPrice;
  Map<String, dynamic>? store;
  String? buyerId;
  int? orderId;
  String? buyerName;

  OrderModel({
    this.address,
    this.orderStatus,
    this.orderTime,
    this.paymentMethod,
    this.paymentStatus,
    this.products,
    this.shippingPrice,
    this.totalPrice,
    this.store,
    this.buyerId,
    this.orderId,
    this.buyerName,
  });

  OrderModel copyWith(
      {String? address,
      String? orderStatus,
      Timestamp? orderTime,
      String? paymentMethod,
      String? paymentStatus,
      List? products,
      List? productId,
      int? shippingPrice,
      int? totalPrice,
      String? buyerId,
      Map<String, dynamic>? store,
      int? orderId,
      String? buyerName}) {
    return OrderModel(
        address: address ?? this.address,
        orderStatus: orderStatus ?? this.orderStatus,
        orderTime: orderTime ?? this.orderTime,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentStatus: paymentStatus ?? this.paymentStatus,
        products: products ?? this.products,
        shippingPrice: shippingPrice ?? this.shippingPrice,
        totalPrice: totalPrice ?? this.totalPrice,
        buyerId: buyerId ?? this.buyerId,
        store: store ?? this.store,
        orderId: orderId ?? this.orderId,
        buyerName: buyerName ?? this.buyerName);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'address': address,
      'orderStatus': orderStatus,
      'orderTime': orderTime?.millisecondsSinceEpoch,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'products': products,
      'shippingPrice': shippingPrice,
      'totalPrice': totalPrice,
      'buyerId': buyerId,
      'store': store,
      'orderId': orderId,
      'buyerName': buyerName
    };
  }

  factory OrderModel.fromMap(map) {
    Timestamp? timestamp =
        map['orderTime'] != null ? map['orderTime'] as Timestamp : null;
    return OrderModel(
      address: map['address'] != null ? map['address'] as String : null,
      orderStatus:
          map['orderStatus'] != null ? map['orderStatus'] as String : null,
      orderTime: timestamp,
      paymentMethod:
          map['paymentMethod'] != null ? map['paymentMethod'] as String : null,
      paymentStatus:
          map['paymentStatus'] != null ? map['paymentStatus'] as String : null,
      products: map['products'] != null ? map['products'] as List : null,
      shippingPrice:
          map['shippingPrice'] != null ? map['shippingPrice'] as int : null,
      totalPrice: map['totalPrice'] != null ? map['totalPrice'] as int : null,
      buyerId: map['buyerId'] != null ? map['buyerId'] as String : null,
      store: map['store'] != null ? map['store'] as Map<String, dynamic> : null,
      orderId: map['orderId'] != null ? map['orderId'] as int : null,
      buyerName: map['buyerName'] != null ? map['buyerName'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(address: $address, orderStatus: $orderStatus, orderTime: $orderTime, paymentMethod: $paymentMethod, paymentStatus: $paymentStatus, productId: $products, shippingPrice: $shippingPrice, totalPrice: $totalPrice, buyerId: $buyerId, store: $store, orderId: $orderId, buyerName: $buyerName)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.address == address &&
        other.orderStatus == orderStatus &&
        other.orderTime == orderTime &&
        other.paymentMethod == paymentMethod &&
        other.paymentStatus == paymentStatus &&
        other.products == products &&
        other.shippingPrice == shippingPrice &&
        other.totalPrice == totalPrice &&
        other.store == store &&
        other.buyerId == buyerId &&
        other.orderId == orderId &&
        other.buyerName == buyerName;
  }

  @override
  int get hashCode {
    return address.hashCode ^
        orderStatus.hashCode ^
        orderTime.hashCode ^
        paymentMethod.hashCode ^
        paymentStatus.hashCode ^
        products.hashCode ^
        buyerName.hashCode ^
        shippingPrice.hashCode ^
        shippingPrice.hashCode ^
        totalPrice.hashCode ^
        store.hashCode ^
        buyerId.hashCode ^
        orderId.hashCode;
  }
}
