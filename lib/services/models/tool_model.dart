import 'dart:convert';

ToolModel toolModelFromJson(String str) => ToolModel.fromJson(json.decode(str));

String toolModelToJson(ToolModel data) => json.encode(data.toJson());

class ToolModel {
  String id;
  String name;
  String description;
  String? brand;
  String? model;
  String? serialNumber;
  String category;
  String condition;
  String? purchaseDate;
  String? warrantyExpiryDate;
  String? maintenanceNotes;
  bool isAvailable;
  bool isActive;
  String company;

  ToolModel({
    required this.id,
    required this.name,
    required this.description,
    this.brand,
    this.model,
    this.serialNumber,
    required this.category,
    required this.condition,
    this.purchaseDate,
    this.warrantyExpiryDate,
    this.maintenanceNotes,
    required this.isAvailable,
    required this.isActive,
    required this.company,
  });

  factory ToolModel.fromJson(Map<String, dynamic> json) => ToolModel(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    brand: json["brand"],
    model: json["model"],
    serialNumber: json["serialNumber"],
    category: json["category"],
    condition: json["condition"],
    purchaseDate: json["purchaseDate"],
    warrantyExpiryDate: json["warrantyExpiryDate"],
    maintenanceNotes: json["maintenanceNotes"],
    isAvailable: json["isAvailable"],
    isActive: json["isActive"],
    company: json["company"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "brand": brand,
    "model": model,
    "serialNumber": serialNumber,
    "category": category,
    "condition": condition,
    "purchaseDate": purchaseDate,
    "warrantyExpiryDate": warrantyExpiryDate,
    "maintenanceNotes": maintenanceNotes,
    "isAvailable": isAvailable,
    "isActive": isActive,
    "company": company,
  };
}