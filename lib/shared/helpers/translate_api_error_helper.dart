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
        'MustCheckInFirst': 'Primero debe marcar su ingreso',
        'AlreadyCheckedOut': 'Ya ha registrado su salida'
      },
      'TOOLS': {
        'ToolsNotFound': 'Algunas herramientas no existen o están inactivas',
        'ToolsNotAvailable': 'Algunas herramientas no están disponibles para retirarse',
        'ToolsAlreadyInUse': 'Algunas herramientas ya están en uso',
        'AssignmentNotFound': 'La asignación no fue encontrada',
        'AssignmentNotInUse': 'La asignación no está en uso'
      }
    };
  }
}
