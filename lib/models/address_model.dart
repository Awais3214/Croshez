// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AddressModel {
  String? userId;
  String? streetAddress;
  String? city;
  String? province;
  String? country;
  bool isSelected = false;
  // bool isDefault;
  AddressModel({
    this.userId,
    this.streetAddress,
    this.city,
    this.province,
    this.country,
    this.isSelected = false,
    // this.isDefault = false,
  });

  AddressModel copyWith({
    String? userId,
    String? streetAddress,
    String? city,
    String? province,
    String? country,
    bool? isSelected,
    // bool? isDefault,
  }) {
    return AddressModel(
      userId: userId ?? this.userId,
      streetAddress: streetAddress ?? this.streetAddress,
      city: city ?? this.city,
      province: province ?? this.province,
      country: country ?? this.country,
      isSelected: isSelected ?? this.isSelected,
      // isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'streetAddress': streetAddress,
      'city': city,
      'province': province,
      'country': country,
      'isSelected': isSelected,
      // 'isDefault': isDefault,
    };
  }

  factory AddressModel.fromMap(map) {
    return AddressModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      streetAddress:
          map['streetAddress'] != null ? map['streetAddress'] as String : null,
      city: map['city'] != null ? map['city'] as String : null,
      province: map['province'] != null ? map['province'] as String : null,
      country: map['country'] != null ? map['country'] as String : null,
      isSelected: map['isSelected'] ?? false,
      // isDefault: map['']
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddressModel(userId: $userId, streetAddress: $streetAddress, city: $city, province: $province, country: $country, isSelected: $isSelected)';
  }

  @override
  bool operator ==(covariant AddressModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.streetAddress == streetAddress &&
        other.city == city &&
        other.province == province &&
        other.country == country &&
        other.isSelected == isSelected;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        streetAddress.hashCode ^
        city.hashCode ^
        province.hashCode ^
        country.hashCode ^
        isSelected.hashCode;
  }
}
