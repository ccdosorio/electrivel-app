// To parse this JSON data, do
//
//     final toolAssignmentCreateModel = toolAssignmentCreateModelFromJson(jsonString);

import 'dart:convert';

ToolAssignmentCreateModel toolAssignmentCreateModelFromJson(String str) => ToolAssignmentCreateModel.fromJson(json.decode(str));
String toolAssignmentCreateModelToJson(ToolAssignmentCreateModel data) => json.encode(data.toJson());

class ToolAssignmentCreateModel {
  final String checkOutNotes;
  final List<ToolCreate> tools;

  ToolAssignmentCreateModel({
    this.checkOutNotes = '',
    this.tools = const [],
  });

  ToolAssignmentCreateModel copyWith({
    String? checkOutNotes,
    List<ToolCreate>? tools,
  }) =>
      ToolAssignmentCreateModel(
        checkOutNotes: checkOutNotes ?? this.checkOutNotes,
        tools: tools ?? this.tools,
      );

  factory ToolAssignmentCreateModel.fromJson(Map<String, dynamic> json) => ToolAssignmentCreateModel(
    checkOutNotes: json["checkOutNotes"],
    tools: List<ToolCreate>.from(json["tools"].map((x) => ToolCreate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "checkOutNotes": checkOutNotes,
    "tools": List<dynamic>.from(tools.map((x) => x.toJson())),
  };
}

class ToolCreate {
  final String toolId;

  ToolCreate({
    this.toolId = '',
  });

  ToolCreate copyWith({
    String? toolId,
  }) =>
      ToolCreate(
        toolId: toolId ?? this.toolId,
      );

  factory ToolCreate.fromJson(Map<String, dynamic> json) => ToolCreate(
    toolId: json["toolId"],
  );

  Map<String, dynamic> toJson() => {
    "toolId": toolId,
  };
}
