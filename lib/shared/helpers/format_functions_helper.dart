// External dependencies
import 'package:intl/intl.dart';

// Internal dependencies
import 'package:electrivel_app/shared/shared.dart';

class FormatFunctions {
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy', String locale = 'es'}) {
    final formatter = DateFormat(format, locale);
    return formatter.format(date);
  }

  static DateTime parseDate(String dateString) {
    return DateTime.parse(dateString);
  }

  static String formatError(String error, Map<String, dynamic> errorData, int statusCode) {
    error = error.trim();

    if (statusCode == 401) {
      return 'Unauthorzied';
    }

    if (statusCode == 500) {
      return 'Ha ocurrido un error inesperado, contecte con un administrador.';
    }

    if (!error.contains('.')) {
      return error;
    }

    final partsError = error.split('.');
    final errorKey = partsError[0];
    final errorCode = partsError[1];

    final httpErrorsDataModel = HttpErrorsDataSharedModel.fromMap(errorData);
    final localErrors = TranslateApiErrorHelper.mapErrors(httpErrorsDataModel);

    if (localErrors.containsKey(errorKey)) {
      final error = localErrors[errorKey];
      return error?[errorCode] ?? 'Ha ocurrido un error inesperado';
    }

    return 'Ha ocurrido un error inesperado';
  }
}
