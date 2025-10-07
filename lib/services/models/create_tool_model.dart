import 'dart:convert';

CreateToolModel createToolModelFromJson(String str) => CreateToolModel.fromJson(json.decode(str));

String createToolModelToJson(CreateToolModel data) => json.encode(data.toJson());

class CreateToolModel {
  String id;
  String companyId;
  String name;
  String description;
  String? brand;
  String? model;
  String? serialNumber;
  String category;
  String condition;

  CreateToolModel({
    required this.id,
    required this.companyId,
    required this.name,
    required this.description,
    this.brand,
    this.model,
    this.serialNumber,
    required this.category,
    required this.condition,
  });

  factory CreateToolModel.fromJson(Map<String, dynamic> json) => CreateToolModel(
    id: json["id"],
    companyId: json["companyId"],
    name: json["name"],
    description: json["description"],
    brand: json["brand"],
    model: json["model"],
    serialNumber: json["serialNumber"],
    category: json["category"],
    condition: json["condition"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "companyId": companyId,
    "name": name,
    "description": description,
    "brand": brand,
    "model": model,
    "serialNumber": serialNumber,
    "category": category,
    "condition": condition,
  };
}