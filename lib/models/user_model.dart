// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  Timestamp? age;
  String? email;
  String? fullname;
  List<dynamic>? role;
  String? profilePicture;
  UserModel({
    this.age,
    this.email,
    this.fullname,
    this.role,
    this.profilePicture,
  });

  UserModel copyWith({
    Timestamp? age,
    String? email,
    String? fullname,
    List<dynamic>? role,
    String? profilePicture,
  }) {
    return UserModel(
      age: age ?? this.age,
      email: email ?? this.email,
      fullname: fullname ?? this.fullname,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'age': age?.millisecondsSinceEpoch,
      'email': email,
      'fullname': fullname,
      'role': role,
      'profilePicture': profilePicture,
    };
  }

  factory UserModel.fromMap(map) {
    Timestamp? timestamp;
    if (map['age'].runtimeType is Timestamp) {
      timestamp = map['age'] == null ? null : map['age'] as Timestamp;
    }
    List? roles = map['role'] == null
        ? []
        : map['role'] is String
            ? [map['role']]
            : List<dynamic>.from((map['role'] as List<dynamic>));
    return UserModel(
      age: timestamp,
      email: map['email'] != null ? map['email'] as String : null,
      fullname: map['fullname'] != null ? map['fullname'] as String : null,
      role: roles,
      profilePicture: map['profilePicture'] != null
          ? map['profilePicture'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(age: $age, email: $email, fullname: $fullname, role: $role, profilePicture: $profilePicture)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.age == age &&
        other.email == email &&
        other.fullname == fullname &&
        other.profilePicture == profilePicture &&
        listEquals(other.role, role);
  }

  @override
  int get hashCode {
    return age.hashCode ^
        email.hashCode ^
        fullname.hashCode ^
        role.hashCode ^
        profilePicture.hashCode;
  }
}
