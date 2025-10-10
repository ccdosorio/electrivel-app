// To parse this JSON data, do
//
//     final assignmentModel = assignmentModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ToolAssignmentModel assignmentModelFromJson(String str) => ToolAssignmentModel.fromJson(json.decode(str));

String assignmentModelToJson(ToolAssignmentModel data) => json.encode(data.toJson());

class ToolAssignmentModel {
  final int id;
  final String status;
  final int userId;
  final String username;
  final DateTime? checkOutTimestamp;
  final DateTime? checkInTimestamp;
  final String checkOutPhotoUrl;
  final String checkInPhotoUrl;
  final String checkOutNotes;
  final String checkInNotes;
  final List<Tool> tools;

  ToolAssignmentModel({
    this.id = 0,
    this.status = '',
    this.userId = 0,
    this.username = '',
    this.checkOutTimestamp,
    this.checkInTimestamp,
    this.checkOutPhotoUrl = '',
    this.checkInPhotoUrl = '',
    this.checkOutNotes = '',
    this.checkInNotes = '',
    this.tools = const [],
  });

  ToolAssignmentModel copyWith({
    int? id,
    String? status,
    int? userId,
    String? username,
    DateTime? checkOutTimestamp,
    DateTime? checkInTimestamp,
    String? checkOutPhotoUrl,
    String? checkInPhotoUrl,
    String? checkOutNotes,
    String? checkInNotes,
    List<Tool>? tools,
  }) =>
      ToolAssignmentModel(
        id: id ?? this.id,
        status: status ?? this.status,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        checkOutTimestamp: checkOutTimestamp ?? this.checkOutTimestamp,
        checkInTimestamp: checkInTimestamp ?? this.checkInTimestamp,
        checkOutPhotoUrl: checkOutPhotoUrl ?? this.checkOutPhotoUrl,
        checkInPhotoUrl: checkInPhotoUrl ?? this.checkInPhotoUrl,
        checkOutNotes: checkOutNotes ?? this.checkOutNotes,
        checkInNotes: checkInNotes ?? this.checkInNotes,
        tools: tools ?? this.tools,
      );

  factory ToolAssignmentModel.fromJson(Map<String, dynamic> json) => ToolAssignmentModel(
    id: json["id"] ?? 0,
    status: json["status"] ?? '',
    userId: json["userId"] ?? '',
    username: json["username"] ?? '',
    checkOutTimestamp: json["checkOutTimestamp"] == null ? DateTime.now() : DateTime.parse(json["checkOutTimestamp"]),
    checkInTimestamp:  json["checkInTimestamp"] == null ? DateTime.now() : DateTime.parse(json["checkInTimestamp"]),
    checkOutPhotoUrl: json["checkOutPhotoUrl"] ?? '',
    checkInPhotoUrl: json["checkInPhotoUrl"] ?? '',
    checkOutNotes: json["checkOutNotes"] ?? '',
    checkInNotes: json["checkInNotes"] ?? '',
    tools: List<Tool>.from(json["tools"].map((x) => Tool.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "userId": userId,
    "username": username,
    "checkOutTimestamp": checkOutTimestamp?.toIso8601String(),
    "checkInTimestamp": checkInTimestamp?.toIso8601String(),
    "checkOutPhotoUrl": checkOutPhotoUrl,
    "checkInPhotoUrl": checkInPhotoUrl,
    "checkOutNotes": checkOutNotes,
    "checkInNotes": checkInNotes,
    "tools": List<dynamic>.from(tools.map((x) => x.toJson())),
  };
}

class Tool {
  final int id;
  final String toolId;
  final String toolName;
  final String toolBrand;
  final String toolModel;
  final String category;
  final int quantity;
  final String conditionCheckOut;
  final String conditionCheckIn;
  final String checkOutNotes;
  final String checkInNotes;
  final String damageDescription;
  final DateTime? checkOutTimestamp;
  final DateTime? checkInTimestamp;

  Tool({
    this.id = 0,
    this.toolId = '',
    this.toolName = '',
    this.toolBrand = '',
    this.toolModel = '',
    this.category = '',
    this.quantity = 0,
    this.conditionCheckOut = '',
    this.conditionCheckIn = '',
    this.checkOutNotes = '',
    this.checkInNotes = '',
    this.damageDescription = '',
    this.checkOutTimestamp,
    this.checkInTimestamp,
  });

  Tool copyWith({
    int? id,
    String? toolId,
    String? toolName,
    String? toolBrand,
    String? toolModel,
    String? category,
    int? quantity,
    String? conditionCheckOut,
    String? conditionCheckIn,
    String? checkOutNotes,
    String? checkInNotes,
    String? damageDescription,
    DateTime? checkOutTimestamp,
    DateTime? checkInTimestamp,
  }) =>
      Tool(
        id: id ?? this.id,
        toolId: toolId ?? this.toolId,
        toolName: toolName ?? this.toolName,
        toolBrand: toolBrand ?? this.toolBrand,
        toolModel: toolModel ?? this.toolModel,
        category: category ?? this.category,
        quantity: quantity ?? this.quantity,
        conditionCheckOut: conditionCheckOut ?? this.conditionCheckOut,
        conditionCheckIn: conditionCheckIn ?? this.conditionCheckIn,
        checkOutNotes: checkOutNotes ?? this.checkOutNotes,
        checkInNotes: checkInNotes ?? this.checkInNotes,
        damageDescription: damageDescription ?? this.damageDescription,
        checkOutTimestamp: checkOutTimestamp ?? this.checkOutTimestamp,
        checkInTimestamp: checkInTimestamp ?? this.checkInTimestamp,
      );

  factory Tool.fromJson(Map<String, dynamic> json) => Tool(
    id: json["id"] ?? 0,
    toolId: json["toolId"] ?? '',
    toolName: json["toolName"] ?? '',
    toolBrand: json["toolBrand"] ?? '',
    toolModel: json["toolModel"] ?? '',
    category: json["category"] ?? '',
    quantity: json["quantity"] ?? 0,
    conditionCheckOut: json["conditionCheckOut"] ?? '',
    conditionCheckIn: json["conditionCheckIn"] ?? '',
    checkOutNotes: json["checkOutNotes"] ?? '',
    checkInNotes: json["checkInNotes"] ?? '',
    damageDescription: json["damageDescription"] ?? '',
    checkOutTimestamp: json["checkOutTimestamp"] == null ? DateTime.now() : DateTime.parse(json["checkOutTimestamp"]),
    checkInTimestamp:  json["checkInTimestamp"] == null ? DateTime.now() : DateTime.parse(json["checkInTimestamp"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "toolId": toolId,
    "toolName": toolName,
    "toolBrand": toolBrand,
    "toolModel": toolModel,
    "category": category,
    "quantity": quantity,
    "conditionCheckOut": conditionCheckOut,
    "conditionCheckIn": conditionCheckIn,
    "checkOutNotes": checkOutNotes,
    "checkInNotes": checkInNotes,
    "damageDescription": damageDescription,
    "checkOutTimestamp": checkOutTimestamp?.toIso8601String(),
    "checkInTimestamp": checkInTimestamp?.toIso8601String(),
  };
}
