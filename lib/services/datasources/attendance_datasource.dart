// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class AttendanceDatasource {
  Future<({ResponseModel response, AttendanceSummaryModel? attendanceSummary})>
  getAttendanceEmployees({String? date}) async {
    final queryParams = <String, dynamic>{};

    if (date != null) {
      queryParams['date'] = date;
    }

    final response = await HttpPlugin.get(
      '/attendance/employees',
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    if (response.isError) {
      return (
        response: ResponseModel(error: response.errorMessage),
        attendanceSummary: null,
      );
    }

    final attendanceSummary = AttendanceSummaryModel.fromJson(response.data);
    return (response: ResponseModel(), attendanceSummary: attendanceSummary);
  }

  Future<({ResponseModel response, AttendanceDetailModel? attendanceDetail})>
  getEmployeeAttendanceDetail({
    required String username,
    String? date,
    String? startDate,
    String? endDate,
  }) async {
    final queryParams = <String, dynamic>{};

    // Agregamos los parámetros si existen
    if (date != null) queryParams['date'] = date;
    if (startDate != null) queryParams['startDate'] = startDate;
    if (endDate != null) queryParams['endDate'] = endDate;

    final response = await HttpPlugin.get(
      '/attendance/employee/$username/detail',
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    if (response.isError) {
      return (
        response: ResponseModel(error: response.errorMessage),
        attendanceDetail: null,
      );
    }

    final attendanceDetail = AttendanceDetailModel.fromJson(response.data);

    return (response: ResponseModel(), attendanceDetail: attendanceDetail);
  }
}
