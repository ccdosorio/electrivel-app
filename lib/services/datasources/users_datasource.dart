// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class UsersDatasource {
  Future<({ResponseModel response, UserListModel? employeeList})> getUsers({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await HttpPlugin.get(
      '/users/all',
      queryParameters: {'page': page, 'limit': limit},
    );

    if (response.isError) {
      return (
        response: ResponseModel(error: response.errorMessage),
        employeeList: null,
      );
    }

    final employeeList = UserListModel.fromJson(response.data);
    return (response: ResponseModel(), employeeList: employeeList);
  }

  Future<({ResponseModel response, List<RoleModel>? roles})> getRoles() async {
    final response = await HttpPlugin.get('/users/roles');

    if (response.isError) {
      return (
        response: ResponseModel(error: response.errorMessage),
        roles: null,
      );
    }

    final roles = List<RoleModel>.from(
      response.data.map((x) => RoleModel.fromJson(x)),
    );
    return (response: ResponseModel(), roles: roles);
  }

  Future<ResponseModel> createUser(CreateUserModel user) async {
    final response = await HttpPlugin.post('/users', data: user.toJson());

    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }

  Future<ResponseModel> deactivateUser(int userId) async {
    // Usamos patch como indicaste en los requisitos
    final response = await HttpPlugin.patch('/users/$userId/deactivate');

    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }

  Future<ResponseModel> changePassword(int userId, String newPassword) async {
    final response = await HttpPlugin.patch(
      '/users/$userId/change-password',
      data: {'newPassword': newPassword},
    );

    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }

  Future<({ResponseModel response, List<UserModel>? users})>
  getUsersCatalog() async {
    final response = await HttpPlugin.get('/users/catalog');

    if (response.isError) {
      return (
        response: ResponseModel(error: response.errorMessage),
        users: null,
      );
    }

    final list = response.data is List ? response.data : response.data['data'];

    final users = List<UserModel>.from(list.map((x) => UserModel.fromJson(x)));
    return (response: ResponseModel(), users: users);
  }
}
