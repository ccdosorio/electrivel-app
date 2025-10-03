// Internal dependencies
import 'package:electrivel_app/shared/shared.dart';

class TranslateApiErrorHelper {
  static Map<String, Map<String, String>> mapErrors(HttpErrorsDataSharedModel httpErrorsDataModel) {
    return {
      'AUTH': {
        'InvalidCredentials': 'Credenciales inválidas',
      },
      'ATTENDANCE': {
        'AlreadyCheckedIn': 'Ya ha registrado su ingreso',
        'MustCheckInFirst': 'Primero debe marcar su ingreso'
      }
    };
  }
}
