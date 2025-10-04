
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class RegisterDatasource {

  Future<ResponseModel> register(bool isCheckIn, AttendanceRegister model) async {
    final endpoint = isCheckIn ? '/attendance/check-in' : '/attendance/check-out';

    final response = await HttpPlugin.post(endpoint, data: model.toJson());
    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }

}