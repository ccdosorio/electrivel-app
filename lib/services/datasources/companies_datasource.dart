// Internal dependencies
import 'package:electrivel_app/shared/shared.dart';
import 'package:electrivel_app/services/services.dart';

class CompaniesDatasource {

  Future<({ResponseModel response, List<CompanyModel>? companies})> getCompanies() async {
    final response = await HttpPlugin.get('/companies');

    if (response.isError) {
      return (response: ResponseModel(error: response.errorMessage), companies: null);
    }

    final companies = List<CompanyModel>.from(response.data.map((x) => CompanyModel.fromJson(x)));
    return (response: ResponseModel(), companies: companies);
  }

}