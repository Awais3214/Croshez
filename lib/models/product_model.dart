// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class ProductModel {
  String? productId;
  bool? favorite;
  String? productName;
  List<String>? productImage;
  String? shopId;
  String? userId;
  String? productDescription;
  String? hookSize;
  String? price;
  ProductModel({
    this.productId,
    this.favorite,
    this.productName,
    this.productImage,
    this.shopId,
    this.userId,
    this.productDescription,
    this.hookSize,
    this.price,
  });

  ProductModel copyWith({
    String? productId,
    bool? favorite,
    String? productName,
    List<String>? productImage,
    String? shopId,
    String? userId,
    String? productDescription,
    String? hookSize,
    String? price,
  }) {
    return ProductModel(
      productId: productId ?? this.productId,
      favorite: favorite ?? this.favorite,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      shopId: shopId ?? this.shopId,
      userId: userId ?? this.userId,
      productDescription: productDescription ?? this.productDescription,
      hookSize: hookSize ?? this.hookSize,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'favorite': favorite,
      'productName': productName,
      'productImage': productImage,
      'shopId': shopId,
      'userId': userId,
      'productDescription': productDescription,
      'hookSize': hookSize,
      'price': price,
    };
  }

  factory ProductModel.fromMap(map) {
    return ProductModel(
      productId: map['productId'] != null ? map['productId'] as String : null,
      favorite: map['favorite'] != null ? map['favorite'] as bool : null,
      productName:
          map['productName'] != null ? map['productName'] as String : null,
      productImage: map['productImage'] != null
          ? List<String>.from(map['productImage'] as List<dynamic>)
          : null,
      shopId: map['shopId'] != null ? map['shopId'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      productDescription: map['productDescription'] != null
          ? map['productDescription'] as String
          : null,
      hookSize: map['hookSize'] != null ? map['hookSize'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(productId: $productId, favorite: $favorite, productName: $productName, productImage: $productImage, shopId: $shopId, userId: $userId, productDescription: $productDescription, hookSize: $hookSize, price: $price)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.favorite == favorite &&
        other.productName == productName &&
        listEquals(other.productImage, productImage) &&
        other.shopId == shopId &&
        other.userId == userId &&
        other.productDescription == productDescription &&
        other.hookSize == hookSize &&
        other.price == price;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        favorite.hashCode ^
        productName.hashCode ^
        productImage.hashCode ^
        shopId.hashCode ^
        userId.hashCode ^
        productDescription.hashCode ^
        hookSize.hashCode ^
        price.hashCode;
  }
}
