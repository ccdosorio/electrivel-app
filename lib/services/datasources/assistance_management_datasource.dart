import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';
import 'package:geolocator/geolocator.dart';

class AssistanceManagementDatasource {
  Future<List<AssistanceManagementModel>> getAssistanceList(
    bool isEmployee,
  ) async {
    final response = await HttpPlugin.get(
      !isEmployee
          ? '/insurance-assistances/all/active'
          : '/insurance-assistances/user/active',
    );
    if (response.isError) {
      return [];
    }

    final items = (response.data as List)
        .map((e) => AssistanceManagementModel.fromJson(e))
        .toList();

    return items;
  }

  Future<List<AssistanceCompanyModel>> getAssistanceCompanies() async {
    final response = await HttpPlugin.get('/insurance-companies');
    if (response.isError) {
      return [];
    }

    final items = (response.data as List)
        .map((e) => AssistanceCompanyModel.fromJson(e))
        .toList();

    return items;
  }

  Future<ResponseModel> create(AssistanceCreateModel model) async {
    final response = await HttpPlugin.post(
      '/insurance-assistances',
      data: model.toJson(),
    );
    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }

  Future<ResponseModel> start(
    int id, {
    required Position pos,
    required String startNotes,
  }) async {
    final response = await HttpPlugin.patch(
      '/insurance-assistances/$id/start',
      data: {
        'startLatitude': pos.latitude,
        'startLongitude': pos.longitude,
        'startNotes': startNotes,
      },
    );

    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }

  Future<ResponseModel> onsite(int id) async {
    final response = await HttpPlugin.patch(
      '/insurance-assistances/$id/onsite',
    );

    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }

  Future<ResponseModel> complete(
    int id, {
    required Position pos,
    required String endNotes,
  }) async {
    final response = await HttpPlugin.patch(
      '/insurance-assistances/$id/complete',
      data: {
        'endLatitude': pos.latitude,
        'endLongitude': pos.longitude,
        'endNotes': endNotes,
      },
    );

    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }

  Future<({ResponseModel response, UserCompletedAssistancesModel? data})>
  getUserCompletedAssistances({
    required String username,
    required String startDate, // YYYY-MM-DD
    required String endDate, // YYYY-MM-DD
  }) async {
    // Query params para el filtro de fechas
    final queryParams = {'startDate': startDate, 'endDate': endDate};

    // Concatenamos los query params a la URL
    final queryString = Uri(queryParameters: queryParams).query;
    final endpoint =
        '/insurance-assistances/user/$username/completed?$queryString';

    final response = await HttpPlugin.get(endpoint);

    if (response.isError) {
      return (
        response: ResponseModel(error: response.errorMessage),
        data: null,
      );
    }

    try {
      final model = UserCompletedAssistancesModel.fromJson(response.data);
      return (response: ResponseModel(), data: model);
    } catch (e) {
      return (response: ResponseModel(error: e.toString()), data: null);
    }
  }
}
