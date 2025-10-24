import 'dart:convert';

ToolsAssignmentReturn toolsAssignmentReturnFromJson(String str) => ToolsAssignmentReturn.fromJson(json.decode(str));

String toolsAssignmentReturnToJson(ToolsAssignmentReturn data) => json.encode(data.toJson());

class ToolsAssignmentReturn {
  final List<ToolAssignment> tools;
  final String checkInNotes;

  ToolsAssignmentReturn({
    this.tools = const [],
    this.checkInNotes = '',
  });

  ToolsAssignmentReturn copyWith({
    List<ToolAssignment>? tools,
    String? checkInNotes,
  }) =>
      ToolsAssignmentReturn(
        tools: tools ?? this.tools,
        checkInNotes: checkInNotes ?? this.checkInNotes,
      );

  factory ToolsAssignmentReturn.fromJson(Map<String, dynamic> json) => ToolsAssignmentReturn(
    tools: List<ToolAssignment>.from(json["tools"].map((x) => ToolAssignment.fromJson(x))),
    checkInNotes: json["checkInNotes"],
  );

  Map<String, dynamic> toJson() => {
    "tools": List<dynamic>.from(tools.map((x) => x.toJson())),
    "checkInNotes": checkInNotes,
  };
}

class ToolAssignment {
  final String toolId;
  final String conditionCheckIn;
  final String checkInNotes;
  final String damageDescription;

  ToolAssignment({
    required this.toolId,
    this.conditionCheckIn = 'BUENA',
    this.checkInNotes = '',
    this.damageDescription = '',
  });

  ToolAssignment copyWith({
    String? toolId,
    String? conditionCheckIn,
    String? checkInNotes,
    String? damageDescription,
  }) =>
      ToolAssignment(
        toolId: toolId ?? this.toolId,
        conditionCheckIn: conditionCheckIn ?? this.conditionCheckIn,
        checkInNotes: checkInNotes ?? this.checkInNotes,
        damageDescription: damageDescription ?? this.damageDescription,
      );

  factory ToolAssignment.fromJson(Map<String, dynamic> json) => ToolAssignment(
    toolId: json["toolId"],
    conditionCheckIn: json["conditionCheckIn"],
    checkInNotes: json["checkInNotes"],
    damageDescription: json["damageDescription"],
  );

  Map<String, dynamic> toJson() => {
    "toolId": toolId,
    "conditionCheckIn": conditionCheckIn,
    "checkInNotes": checkInNotes,
    "damageDescription": damageDescription,
  };
}
