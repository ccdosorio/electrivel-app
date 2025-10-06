import 'dart:convert';

CreateUserModel createUserModelFromJson(String str) => CreateUserModel.fromJson(json.decode(str));

String createUserModelToJson(CreateUserModel data) => json.encode(data.toJson());

class CreateUserModel {
  String username;
  String fullName;
  String password;
  String roleId;
  String companyId;

  CreateUserModel({
    required this.username,
    required this.fullName,
    required this.password,
    required this.roleId,
    required this.companyId,
  });

  factory CreateUserModel.fromJson(Map<String, dynamic> json) => CreateUserModel(
    username: json["username"],
    fullName: json["fullName"],
    password: json["password"],
    roleId: json["roleId"],
    companyId: json["companyId"],
  );

  Map<String, dynamic> toJson() => {
    "username": username,
    "fullName": fullName,
    "password": password,
    "roleId": roleId,
    "companyId": companyId,
  };
}