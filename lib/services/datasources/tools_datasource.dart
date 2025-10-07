// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class ToolsDatasource {

  Future<({ResponseModel response, ToolListModel? toolList})> getTools({int page = 1, int limit = 10}) async {
    final response = await HttpPlugin.get('/tools', queryParameters: {
      'page': page,
      'limit': limit,
    });

    if (response.isError) {
      return (response: ResponseModel(error: response.errorMessage), toolList: null);
    }

    final toolList = ToolListModel.fromJson(response.data);
    return (response: ResponseModel(), toolList: toolList);
  }

}