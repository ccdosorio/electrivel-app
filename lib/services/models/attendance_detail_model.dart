import 'dart:convert';

AttendanceDetailModel attendanceDetailModelFromJson(String str) => AttendanceDetailModel.fromJson(json.decode(str));

String attendanceDetailModelToJson(AttendanceDetailModel data) => json.encode(data.toJson());

class AttendanceDetailModel {
  final EmployeeModel employee;
  final DateRangeModel dateRange;
  final int totalDays;
  final int totalRecords;
  final String totalWorkDuration;
  final List<DailyRecordModel> dailyRecords;

  AttendanceDetailModel({
    required this.employee,
    required this.dateRange,
    required this.totalDays,
    required this.totalRecords,
    required this.totalWorkDuration,
    required this.dailyRecords,
  });

  AttendanceDetailModel copyWith({
    EmployeeModel? employee,
    DateRangeModel? dateRange,
    int? totalDays,
    int? totalRecords,
    String? totalWorkDuration,
    List<DailyRecordModel>? dailyRecords,
  }) =>
      AttendanceDetailModel(
        employee: employee ?? this.employee,
        dateRange: dateRange ?? this.dateRange,
        totalDays: totalDays ?? this.totalDays,
        totalRecords: totalRecords ?? this.totalRecords,
        totalWorkDuration: totalWorkDuration ?? this.totalWorkDuration,
        dailyRecords: dailyRecords ?? this.dailyRecords,
      );

  factory AttendanceDetailModel.fromJson(Map<String, dynamic> json) => AttendanceDetailModel(
        employee: EmployeeModel.fromJson(json["employee"]),
        dateRange: DateRangeModel.fromJson(json["dateRange"]),
        totalDays: json["totalDays"],
        totalRecords: json["totalRecords"],
        totalWorkDuration: json["totalWorkDuration"],
        dailyRecords: List<DailyRecordModel>.from(json["dailyRecords"].map((x) => DailyRecordModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "employee": employee.toJson(),
        "dateRange": dateRange.toJson(),
        "totalDays": totalDays,
        "totalRecords": totalRecords,
        "totalWorkDuration": totalWorkDuration,
        "dailyRecords": List<dynamic>.from(dailyRecords.map((x) => x.toJson())),
      };
}

class EmployeeModel {
  final int id;
  final String username;
  final String fullName;
  final EntityModel role;
  final EntityModel company;

  EmployeeModel({
    required this.id,
    required this.username,
    required this.fullName,
    required this.role,
    required this.company,
  });

  EmployeeModel copyWith({
    int? id,
    String? username,
    String? fullName,
    EntityModel? role,
    EntityModel? company,
  }) =>
      EmployeeModel(
        id: id ?? this.id,
        username: username ?? this.username,
        fullName: fullName ?? this.fullName,
        role: role ?? this.role,
        company: company ?? this.company,
      );

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json["id"],
        username: json["username"],
        fullName: json["fullName"],
        role: EntityModel.fromJson(json["role"]),
        company: EntityModel.fromJson(json["company"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "fullName": fullName,
        "role": role.toJson(),
        "company": company.toJson(),
      };
}

class EntityModel {
  final String id;
  final String name;

  EntityModel({
    required this.id,
    required this.name,
  });

  EntityModel copyWith({
    String? id,
    String? name,
  }) =>
      EntityModel(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory EntityModel.fromJson(Map<String, dynamic> json) => EntityModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class DateRangeModel {
  final DateTime startDate;
  final DateTime endDate;

  DateRangeModel({
    required this.startDate,
    required this.endDate,
  });

  DateRangeModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      DateRangeModel(
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
      );

  factory DateRangeModel.fromJson(Map<String, dynamic> json) => DateRangeModel(
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
      );

  Map<String, dynamic> toJson() => {
        "startDate": "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "endDate": "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}",
      };
}

class DailyRecordModel {
  final DateTime workDate;
  final String status;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final String checkInLocation;
  final String? checkOutLocation;
  final String workDuration;
  final int workDurationMs;
  final List<RecordLogModel> records;

  DailyRecordModel({
    required this.workDate,
    required this.status,
    required this.checkInTime,
    this.checkOutTime,
    required this.checkInLocation,
    this.checkOutLocation,
    required this.workDuration,
    required this.workDurationMs,
    required this.records,
  });

  DailyRecordModel copyWith({
    DateTime? workDate,
    String? status,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    String? checkInLocation,
    String? checkOutLocation,
    String? workDuration,
    int? workDurationMs,
    List<RecordLogModel>? records,
  }) =>
      DailyRecordModel(
        workDate: workDate ?? this.workDate,
        status: status ?? this.status,
        checkInTime: checkInTime ?? this.checkInTime,
        checkOutTime: checkOutTime ?? this.checkOutTime,
        checkInLocation: checkInLocation ?? this.checkInLocation,
        checkOutLocation: checkOutLocation ?? this.checkOutLocation,
        workDuration: workDuration ?? this.workDuration,
        workDurationMs: workDurationMs ?? this.workDurationMs,
        records: records ?? this.records,
      );

  factory DailyRecordModel.fromJson(Map<String, dynamic> json) => DailyRecordModel(
        workDate: DateTime.parse(json["workDate"]),
        status: json["status"],
        checkInTime: DateTime.parse(json["checkInTime"]),
        checkOutTime: json["checkOutTime"] == null ? null : DateTime.parse(json["checkOutTime"]),
        checkInLocation: json["checkInLocation"],
        checkOutLocation: json["checkOutLocation"],
        workDuration: json["workDuration"],
        workDurationMs: json["workDurationMs"],
        records: List<RecordLogModel>.from(json["records"].map((x) => RecordLogModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "workDate": "${workDate.year.toString().padLeft(4, '0')}-${workDate.month.toString().padLeft(2, '0')}-${workDate.day.toString().padLeft(2, '0')}",
        "status": status,
        "checkInTime": checkInTime.toIso8601String(),
        "checkOutTime": checkOutTime?.toIso8601String(),
        "checkInLocation": checkInLocation,
        "checkOutLocation": checkOutLocation,
        "workDuration": workDuration,
        "workDurationMs": workDurationMs,
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class RecordLogModel {
  final int id;
  final String type;
  final DateTime timestamp;
  final String locationAddress;
  final String latitude;
  final String longitude;
  final String? notes;

  RecordLogModel({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    this.notes,
  });

  RecordLogModel copyWith({
    int? id,
    String? type,
    DateTime? timestamp,
    String? locationAddress,
    String? latitude,
    String? longitude,
    String? notes,
  }) =>
      RecordLogModel(
        id: id ?? this.id,
        type: type ?? this.type,
        timestamp: timestamp ?? this.timestamp,
        locationAddress: locationAddress ?? this.locationAddress,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        notes: notes ?? this.notes,
      );

  factory RecordLogModel.fromJson(Map<String, dynamic> json) => RecordLogModel(
        id: json["id"],
        type: json["type"],
        timestamp: DateTime.parse(json["timestamp"]),
        locationAddress: json["locationAddress"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "timestamp": timestamp.toIso8601String(),
        "locationAddress": locationAddress,
        "latitude": latitude,
        "longitude": longitude,
        "notes": notes,
      };
}