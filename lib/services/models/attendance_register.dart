import 'dart:convert';

AttendanceRegister attendanceRegisterFromJson(String str) => AttendanceRegister.fromJson(json.decode(str));

String attendanceRegisterToJson(AttendanceRegister data) => json.encode(data.toJson());

class AttendanceRegister {
  String locationAddress;
  double latitude;
  double longitude;
  String notes;

  AttendanceRegister({
    required this.locationAddress,
    required this.latitude,
    required this.longitude,
    required this.notes,
  });

  factory AttendanceRegister.fromJson(Map<String, dynamic> json) => AttendanceRegister(
    locationAddress: json["locationAddress"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    notes: json["notes"],
  );

  Map<String, dynamic> toJson() => {
    "locationAddress": locationAddress,
    "latitude": latitude,
    "longitude": longitude,
    "notes": notes,
  };
}
