import 'dart:convert';

AssistanceCreateModel assistanceCreateModelFromJson(String str) => AssistanceCreateModel.fromJson(json.decode(str));
String assistanceCreateModelToJson(AssistanceCreateModel data) => json.encode(data.toJson());

class AssistanceCreateModel {
  final int insuranceCompanyId;
  final int userId;
  final String caseNumber;
  final String clientName;
  final String clientPhone;
  final String serviceAddress;
  final String description;

  AssistanceCreateModel({
    required this.insuranceCompanyId,
    required this.userId,
    required this.caseNumber,
    required this.clientName,
    required this.clientPhone,
    required this.serviceAddress,
    required this.description,
  });

  AssistanceCreateModel copyWith({
    int? insuranceCompanyId,
    int? userId,
    String? caseNumber,
    String? clientName,
    String? clientPhone,
    String? serviceAddress,
    String? description,
  }) =>
      AssistanceCreateModel(
        insuranceCompanyId: insuranceCompanyId ?? this.insuranceCompanyId,
        userId: userId ?? this.userId,
        caseNumber: caseNumber ?? this.caseNumber,
        clientName: clientName ?? this.clientName,
        clientPhone: clientPhone ?? this.clientPhone,
        serviceAddress: serviceAddress ?? this.serviceAddress,
        description: description ?? this.description,
      );

  factory AssistanceCreateModel.fromJson(Map<String, dynamic> json) => AssistanceCreateModel(
    insuranceCompanyId: json["insuranceCompanyId"],
    userId: json["userId"],
    caseNumber: json["caseNumber"],
    clientName: json["clientName"],
    clientPhone: json["clientPhone"],
    serviceAddress: json["serviceAddress"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "insuranceCompanyId": insuranceCompanyId,
    "userId": userId,
    "caseNumber": caseNumber,
    "clientName": clientName,
    "clientPhone": clientPhone,
    "serviceAddress": serviceAddress,
    "description": description,
  };
}
