import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String userId;
  final String name;
  final String apartmentName;
  final String email;
  final String apartmentCode;
  final bool isAdmin;

  UserModel({
    required this.userId,
    required this.name,
    required this.apartmentName,
    required this.email,
    required this.apartmentCode, required this.isAdmin,
  });

  factory UserModel.fromFirebaseUser(UserModel model) {
    return UserModel(
      userId: model.userId,
      name: model.name,
      apartmentName: model.apartmentName,
      email: model.email,
      apartmentCode: model.apartmentCode,
      isAdmin: model.isAdmin
    );
  }
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      apartmentName: json['apartmentName'] as String,
      email: json['email'] as String,
      apartmentCode: json['apartmentCode'] as String,
      isAdmin: json['isAdmin'] as bool,
    );
  }
  Map<String, dynamic> toJson() {
  return {
    'userId': userId,
    'name': name,
    'apartmentName': apartmentName,
    'email': email,
    'apartmentCode': apartmentCode,
    'isAdmin': isAdmin,
  };
}
}
