import 'dart:convert';
import 'attendance_employee_model.dart';

AttendanceSummaryModel attendanceSummaryModelFromJson(String str) =>
    AttendanceSummaryModel.fromJson(json.decode(str));

String attendanceSummaryModelToJson(AttendanceSummaryModel data) =>
    json.encode(data.toJson());

class AttendanceSummaryModel {
  String date;
  int totalEmployees;
  Summary summary;
  List<AttendanceEmployeeModel> employees;

  AttendanceSummaryModel({
    required this.date,
    required this.totalEmployees,
    required this.summary,
    required this.employees,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) =>
      AttendanceSummaryModel(
        date: json["date"],
        totalEmployees: json["totalEmployees"],
        summary: Summary.fromJson(json["summary"]),
        employees: List<AttendanceEmployeeModel>.from(
          json["employees"].map((x) => AttendanceEmployeeModel.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "date": date,
    "totalEmployees": totalEmployees,
    "summary": summary.toJson(),
    "employees": List<dynamic>.from(employees.map((x) => x.toJson())),
  };
}

class Summary {
  int notCheckedIn;
  int checkedIn;
  int checkedOut;

  Summary({
    required this.notCheckedIn,
    required this.checkedIn,
    required this.checkedOut,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    notCheckedIn: json["notCheckedIn"],
    checkedIn: json["checkedIn"],
    checkedOut: json["checkedOut"],
  );

  Map<String, dynamic> toJson() => {
    "notCheckedIn": notCheckedIn,
    "checkedIn": checkedIn,
    "checkedOut": checkedOut,
  };
}
