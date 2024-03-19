import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class CartModel {
  String? productId;
  int? quantity;
  String? userId;
  String? image;
  String? name;
  String? price;
  String? storeId;
  String? storeName;
  bool isSelected = false;
  CartModel({
    this.productId,
    this.quantity,
    this.userId,
    this.image,
    this.name,
    this.price,
    this.storeId,
    this.storeName,
    this.isSelected = false,
  });

  CartModel copyWith({
    String? productId,
    int? quantity,
    String? userId,
    String? image,
    String? name,
    String? price,
    String? storeId,
    bool? isSelected,
    String? storeName,
  }) {
    return CartModel(
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      userId: userId ?? this.userId,
      image: image ?? this.image,
      name: name ?? this.name,
      price: price ?? this.price,
      storeId: storeId ?? this.storeId,
      isSelected: isSelected ?? this.isSelected,
      storeName: storeName ?? this.storeName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'quantity': quantity,
      'userId': userId,
      'image': image,
      'name': name,
      'price': price,
      'storeId': storeId,
      'isSelected': isSelected,
      'storeName': storeName,
    };
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartModel(productId: $productId, quantity: $quantity, userId: $userId, image: $image, name: $name, price: $price, storeId: $storeId, isSelected: $isSelected)';
  }

  @override
  bool operator ==(covariant CartModel other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.quantity == quantity &&
        other.userId == userId &&
        other.image == image &&
        other.name == name &&
        other.price == price &&
        other.storeId == storeId &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        quantity.hashCode ^
        userId.hashCode ^
        image.hashCode ^
        name.hashCode ^
        price.hashCode ^
        storeId.hashCode ^
        isSelected.hashCode;
  }

  factory CartModel.fromMap(map) {
    return CartModel(
      productId: map['productId'] != null ? map['productId'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      storeId: map['storeId'] != null ? map['storeId'] as String : null,
      isSelected: map['isSelected'] != null ? map['isSelected'] as bool : false,
      storeName: map['storeName'],
    );
  }
}
