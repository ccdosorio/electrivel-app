import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class ToolsAssignmentDatasource {
  Future<ToolAssignmentPageListModel> getPageList(int page) async {
    final response = await HttpPlugin.get(
      '/tools/assignments/user',
      queryParameters: {'page': page, 'limit': 10},
    );

    if (response.isError) {
      return ToolAssignmentPageListModel();
    }

    final items = (response.data['assignments'] as List)
        .map((e) => ToolAssignmentModel.fromJson(e))
        .toList();

    return ToolAssignmentPageListModel(
      items: items,
      totalPages: response.data['totalPages'],
      currentPage: page,
    );
  }

  Future<ResponseModel> save({
    required String notes,
    required List<ToolModel> selectedTools
  }) async {
    final response = await HttpPlugin.post('/tools/assignments', data: {
      'checkOutNotes': notes,
      'tools': selectedTools.map((e) => {
        'toolId': e.id
      }).toList()
    });

    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    return ResponseModel();
  }
}
