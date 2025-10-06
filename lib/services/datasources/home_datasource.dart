// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class HomeDatasource {

    Future<({ResponseModel response, List<HomeMenuModel>? menuList})> loadMenu() async {
      final response = await HttpPlugin.get('/users/menu-permissions');

      if (response.isError) {
        return (response: ResponseModel(error: response.errorMessage), menuList: null);
      }

      final menuList = List<HomeMenuModel>.from(response.data.map((x) => HomeMenuModel.fromJson(x)));
      return (response: ResponseModel(), menuList: menuList);
    }

}