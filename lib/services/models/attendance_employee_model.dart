import 'dart:convert';

AttendanceEmployeeModel attendanceEmployeeModelFromJson(String str) =>
    AttendanceEmployeeModel.fromJson(json.decode(str));

String attendanceEmployeeModelToJson(AttendanceEmployeeModel data) =>
    json.encode(data.toJson());

class AttendanceEmployeeModel {
  int id;
  String username;
  String fullName;
  RoleInfo role;
  CompanyInfo company;
  String status;
  String? checkInTime;
  String? checkOutTime;
  String? workDuration;
  String? checkInLocation;
  String? checkOutLocation;

  AttendanceEmployeeModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    required this.company,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    this.workDuration,
    this.checkInLocation,
    this.checkOutLocation,
  });

  factory AttendanceEmployeeModel.fromJson(Map<String, dynamic> json) =>
      AttendanceEmployeeModel(
        id: json["id"],
        username: json["username"],
        fullName: json["fullName"],
        role: RoleInfo.fromJson(json["role"]),
        company: CompanyInfo.fromJson(json["company"]),
        status: json["status"],
        checkInTime: json["checkInTime"],
        checkOutTime: json["checkOutTime"],
        workDuration: json["workDuration"],
        checkInLocation: json["checkInLocation"],
        checkOutLocation: json["checkOutLocation"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "fullName": fullName,
        "role": role.toJson(),
        "company": company.toJson(),
        "status": status,
        "checkInTime": checkInTime,
        "checkOutTime": checkOutTime,
        "workDuration": workDuration,
        "checkInLocation": checkInLocation,
        "checkOutLocation": checkOutLocation,
      };
}

class RoleInfo {
  String id;
  String name;

  RoleInfo({required this.id, required this.name});

  factory RoleInfo.fromJson(Map<String, dynamic> json) =>
      RoleInfo(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}

class CompanyInfo {
  String id;
  String name;

  CompanyInfo({required this.id, required this.name});

  factory CompanyInfo.fromJson(Map<String, dynamic> json) =>
      CompanyInfo(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}