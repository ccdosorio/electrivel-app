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
    this.user = const User(),
    this.accessToken = '',
    this.expireIn = 0,
    this.refreshToken = '',
    this.refreshExpiresIn = 0,
    this.tokenType = '',
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

  const User({
    this.userId = 0,
    this.username = '',
    this.fullName = '',
    this.role = '',
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
