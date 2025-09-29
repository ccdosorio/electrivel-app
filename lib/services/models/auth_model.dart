// Dart
import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));
String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  final User user;
  final String accessToken;
  final int expireIn;
  final String refreshToken;
  final int refreshExpiresIn;
  final String tokenType;

  AuthModel({
    required this.user,
    required this.accessToken,
    required this.expireIn,
    required this.refreshToken,
    required this.refreshExpiresIn,
    required this.tokenType,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
    user: User.fromJson(json["user"]),
    accessToken: json["accessToken"],
    expireIn: json["expireIn"],
    refreshToken: json["refreshToken"],
    refreshExpiresIn: json["refreshExpiresIn"],
    tokenType: json["tokenType"],
  );

  Map<String, dynamic> toJson() => {
    "user": user.toJson(),
    "accessToken": accessToken,
    "expireIn": expireIn,
    "refreshToken": refreshToken,
    "refreshExpiresIn": refreshExpiresIn,
    "tokenType": tokenType,
  };
}

class User {
  final int userId;
  final String username;
  final String fullName;
  final String role;

  User({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["userId"],
    username: json["username"],
    fullName: json["fullName"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "username": username,
    "fullName": fullName,
    "role": role,
  };
}
