import 'dart:convert';
import 'user_model.dart';

UserListModel userListModelFromJson(String str) => UserListModel.fromJson(json.decode(str));

String userListModelToJson(UserListModel data) => json.encode(data.toJson());

class UserListModel {
  List<UserModel> users;
  int total;
  int limit;
  int currentPage;
  int totalPages;

  UserListModel({
    required this.users,
    required this.total,
    required this.limit,
    required this.currentPage,
    required this.totalPages,
  });

  factory UserListModel.fromJson(Map<String, dynamic> json) => UserListModel(
    users: List<UserModel>.from(json["users"].map((x) => UserModel.fromJson(x))),
    total: json["total"],
    limit: json["limit"],
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "users": List<dynamic>.from(users.map((x) => x.toJson())),
    "total": total,
    "limit": limit,
    "currentPage": currentPage,
    "totalPages": totalPages,
  };
}