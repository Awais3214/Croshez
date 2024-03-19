// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StoreModel {
  String? city;
  String? shopName;
  String? shopDescription;
  String? userId;
  String? storeId;
  String? imageUrl;
  StoreModel({
    this.city,
    this.shopName,
    this.shopDescription,
    this.userId,
    this.storeId,
    this.imageUrl,
  });

  StoreModel copyWith({
    String? city,
    String? shopName,
    String? shopDescription,
    String? userId,
    String? imageUrl,
  }) {
    return StoreModel(
      city: city ?? this.city,
      shopName: shopName ?? this.shopName,
      shopDescription: shopDescription ?? this.shopDescription,
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'city': city,
      'shopName': shopName,
      'shopDescription': shopDescription,
      'userId': userId,
      'imageUrl': imageUrl,
    };
  }

  factory StoreModel.fromMap(map) {
    return StoreModel(
      city: map['city'] != null ? map['city'] as String : null,
      shopName: map['shopName'] != null ? map['shopName'] as String : null,
      shopDescription: map['shopDescription'] != null
          ? map['shopDescription'] as String
          : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StoreModel.fromJson(String source) =>
      StoreModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StoreModel(city: $city, shopName: $shopName, shopDescription: $shopDescription, userId: $userId, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant StoreModel other) {
    if (identical(this, other)) return true;

    return other.city == city &&
        other.shopName == shopName &&
        other.shopDescription == shopDescription &&
        other.userId == userId &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return city.hashCode ^
        shopName.hashCode ^
        shopDescription.hashCode ^
        userId.hashCode ^
        imageUrl.hashCode;
  }
}
