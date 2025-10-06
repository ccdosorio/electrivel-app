// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class UsersDatasource {

  Future<({ResponseModel response, UserListModel? employeeList})> getEmployees({int page = 1, int limit = 10}) async {

    final response = await HttpPlugin.get('/users/employees', queryParameters: {
      'page': page,
      'limit': limit,
    });

    if (response.isError) {
      return (response: ResponseModel(error: response.errorMessage), employeeList: null);
    }

    final employeeList = UserListModel.fromJson(response.data);

    return (response: ResponseModel(), employeeList: employeeList);
  }

}