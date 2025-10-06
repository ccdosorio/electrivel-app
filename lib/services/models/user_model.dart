import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String username;
  String fullName;
  String role;
  String company;

  UserModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    required this.company,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    username: json["username"],
    fullName: json["fullName"],
    role: json["role"],
    company: json["company"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "fullName": fullName,
    "role": role,
    "company": company,
  };
}