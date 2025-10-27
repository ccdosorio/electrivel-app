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
        attendanceSummary: null
      );
    }

    final attendanceSummary = AttendanceSummaryModel.fromJson(response.data);
    return (response: ResponseModel(), attendanceSummary: attendanceSummary);
  }

}