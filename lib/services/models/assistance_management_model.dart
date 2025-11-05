import 'dart:convert';

AssistanceManagementModel assistanceManagementModelFromJson(String str) => AssistanceManagementModel.fromJson(json.decode(str));

String assistanceManagementModelToJson(AssistanceManagementModel data) => json.encode(data.toJson());

class AssistanceManagementModel {
  final int id;
  final int insuranceCompanyId;
  final String insuranceCompanyName;
  final int userId;
  final String username;
  final String status;
  final String caseNumber;
  final String clientName;
  final String clientPhone;
  final String serviceAddress;
  final String description;
  final DateTime? startTimestamp;
  final String? startLatitude;
  final String? startLongitude;
  final String? startNotes;
  final DateTime? endTimestamp;
  final String? endLatitude;
  final String? endLongitude;
  final String? endNotes;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;

  AssistanceManagementModel({
    this.id = 0,
    this.insuranceCompanyId = 0,
    this.insuranceCompanyName = '',
    this.userId = 0,
    this.username = '',
    this.status = '',
    this.caseNumber = '',
    this.clientName = '',
    this.clientPhone = '',
    this.serviceAddress = '',
    this.description = '',
    this.startTimestamp,
    this.startLatitude,
    this.startLongitude,
    this.startNotes,
    this.endTimestamp,
    this.endLatitude,
    this.endLongitude,
    this.endNotes,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  AssistanceManagementModel copyWith({
    int? id,
    int? insuranceCompanyId,
    String? insuranceCompanyName,
    int? userId,
    String? username,
    String? status,
    String? caseNumber,
    String? clientName,
    String? clientPhone,
    String? serviceAddress,
    String? description,
    DateTime? startTimestamp,
    String? startLatitude,
    String? startLongitude,
    String? startNotes,
    DateTime? endTimestamp,
    String? endLatitude,
    String? endLongitude,
    String? endNotes,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
  }) =>
      AssistanceManagementModel(
        id: id ?? this.id,
        insuranceCompanyId: insuranceCompanyId ?? this.insuranceCompanyId,
        insuranceCompanyName: insuranceCompanyName ?? this.insuranceCompanyName,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        status: status ?? this.status,
        caseNumber: caseNumber ?? this.caseNumber,
        clientName: clientName ?? this.clientName,
        clientPhone: clientPhone ?? this.clientPhone,
        serviceAddress: serviceAddress ?? this.serviceAddress,
        description: description ?? this.description,
        startTimestamp: startTimestamp ?? this.startTimestamp,
        startLatitude: startLatitude ?? this.startLatitude,
        startLongitude: startLongitude ?? this.startLongitude,
        startNotes: startNotes ?? this.startNotes,
        endTimestamp: endTimestamp ?? this.endTimestamp,
        endLatitude: endLatitude ?? this.endLatitude,
        endLongitude: endLongitude ?? this.endLongitude,
        endNotes: endNotes ?? this.endNotes,
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        updatedBy: updatedBy ?? this.updatedBy,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory AssistanceManagementModel.fromJson(Map<String, dynamic> json) => AssistanceManagementModel(
    id: json["id"],
    insuranceCompanyId: json["insuranceCompanyId"],
    insuranceCompanyName: json["insuranceCompanyName"],
    userId: json["userId"],
    username: json["username"],
    status: json["status"],
    caseNumber: json["caseNumber"],
    clientName: json["clientName"],
    clientPhone: json["clientPhone"],
    serviceAddress: json["serviceAddress"],
    description: json["description"],
    startTimestamp: json["startTimestamp"] != null ? DateTime.parse(json["startTimestamp"]) : null,
    startLatitude: json["startLatitude"],
    startLongitude: json["startLongitude"],
    startNotes: json["startNotes"],
    endTimestamp: json["endTimestamp"] != null ? DateTime.parse(json["endTimestamp"]) : null,
    endLatitude: json["endLatitude"],
    endLongitude: json["endLongitude"],
    endNotes: json["endNotes"],
    createdBy: json["createdBy"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedBy: json["updatedBy"],
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "insuranceCompanyId": insuranceCompanyId,
    "insuranceCompanyName": insuranceCompanyName,
    "userId": userId,
    "username": username,
    "status": status,
    "caseNumber": caseNumber,
    "clientName": clientName,
    "clientPhone": clientPhone,
    "serviceAddress": serviceAddress,
    "description": description,
    "startTimestamp": startTimestamp?.toIso8601String(),
    "startLatitude": startLatitude,
    "startLongitude": startLongitude,
    "startNotes": startNotes,
    "endTimestamp": endTimestamp?.toIso8601String(),
    "endLatitude": endLatitude,
    "endLongitude": endLongitude,
    "endNotes": endNotes,
    "createdBy": createdBy,
    "createdAt": createdAt?.toIso8601String(),
    "updatedBy": updatedBy,
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
