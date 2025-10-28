import 'dart:convert';

AssistanceCompanyModel assistanceCompanyModelFromJson(String str) => AssistanceCompanyModel.fromJson(json.decode(str));

String assistanceCompanyModelToJson(AssistanceCompanyModel data) => json.encode(data.toJson());

class AssistanceCompanyModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AssistanceCompanyModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  AssistanceCompanyModel copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      AssistanceCompanyModel(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory AssistanceCompanyModel.fromJson(Map<String, dynamic> json) => AssistanceCompanyModel(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    isActive: json["isActive"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "email": email,
    "isActive": isActive,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
  };
}
