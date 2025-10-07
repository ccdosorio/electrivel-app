import 'dart:convert';
import 'tool_model.dart';

ToolListModel toolListModelFromJson(String str) => ToolListModel.fromJson(json.decode(str));

String toolListModelToJson(ToolListModel data) => json.encode(data.toJson());

class ToolListModel {
  List<ToolModel> tools;
  int total;
  int limit;
  int currentPage;
  int totalPages;

  ToolListModel({
    required this.tools,
    required this.total,
    required this.limit,
    required this.currentPage,
    required this.totalPages,
  });

  factory ToolListModel.fromJson(Map<String, dynamic> json) => ToolListModel(
    tools: List<ToolModel>.from(json["tools"].map((x) => ToolModel.fromJson(x))),
    total: json["total"],
    limit: json["limit"],
    currentPage: json["currentPage"],
    totalPages: json["totalPages"],
  );

  Map<String, dynamic> toJson() => {
    "tools": List<dynamic>.from(tools.map((x) => x.toJson())),
    "total": total,
    "limit": limit,
    "currentPage": currentPage,
    "totalPages": totalPages,
  };
}