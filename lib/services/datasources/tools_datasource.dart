// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class ToolsDatasource {
  Future<({ResponseModel response, ToolListModel? toolList})> getTools({
    int page = 1,
    int limit = 10,
    String? companyId,
  }) async {
    final queryParams = <String, dynamic>{'page': page, 'limit': limit};

    if (companyId != null) {
      queryParams['companyId'] = companyId;
    }

    final response = await HttpPlugin.get(
      '/tools',
      queryParameters: queryParams,
    );

    if (response.isError) {
      return (
        response: ResponseModel(error: response.errorMessage),
        toolList: null,
      );
    }

    final toolList = ToolListModel.fromJson(response.data);
    return (response: ResponseModel(), toolList: toolList);
  }

  Future<ResponseModel> createTool(CreateToolModel tool) async {
    final response = await HttpPlugin.post(
      '/tools/catalog',
      data: tool.toJson(),
    );

    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }

  Future<({ResponseModel response, ToolModel? tool})> getToolById(
    String toolId,
  ) async {
    final response = await HttpPlugin.get('/tools/$toolId');

    if (response.isError) {
      return (
        response: ResponseModel(error: response.errorMessage),
        tool: null,
      );
    }

    final tool = ToolModel.fromJson(response.data);
    return (response: ResponseModel(), tool: tool);
  }

  Future<ResponseModel> updateTool(
    String originalId,
    CreateToolModel tool,
  ) async {
    final response = await HttpPlugin.patch(
      '/tools/catalog/$originalId',
      data: tool.toJson(),
    );

    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }

  Future<List<ToolModel>> getToolsCatalog() async {
    final response = await HttpPlugin.get('/tools/catalog');

    if (response.isError) {
      return [];
    }

    return (response.data as List)
        .map((e) => ToolModel.fromJson(e))
        .toList();
  }
}
