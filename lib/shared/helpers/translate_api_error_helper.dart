// Internal dependencies
import 'package:electrivel_app/shared/shared.dart';

class TranslateApiErrorHelper {
  static Map<String, Map<String, String>> mapErrors(HttpErrorsDataSharedModel httpErrorsDataModel) {
    return _friendlyMessagesByCategory;
  }

  /// Mapa completo de errores del backend (type "CATEGORY.Code") a mensaje amigable en español.
  static const Map<String, Map<String, String>> _friendlyMessagesByCategory = {
    'USER': {
      'UserNotFound': 'El usuario no fue encontrado',
      'RoleNotFound': 'El rol no fue encontrado',
      'CompanyNotFound': 'La empresa no fue encontrada',
      'UserAlreadyExists': 'El usuario ya existe',
      'PasswordPolicyViolation':
          'La contraseña debe tener al menos 6 caracteres, una mayúscula, un número y un carácter especial',
      'UserAlreadyInactive': 'El usuario ya está inactivo',
      'NewPasswordSameAsCurrent':
          'La nueva contraseña no puede ser igual a la contraseña actual',
    },
    'AUTH': {
      'InvalidCredentials': 'Credenciales inválidas',
      'InvalidToken': 'Token inválido',
      'UserIsInactive': 'Usuario inactivo. Contacte al administrador',
      'InvalidRefreshToken': 'Token de actualización inválido',
      'ExpiredRefreshToken': 'Token de actualización expirado',
    },
    'ATTENDANCE': {
      'AlreadyCheckedInToday': 'Ya registró su ingreso hoy',
      'AlreadyCheckedOutToday': 'Ya registró su salida hoy',
      'MustCheckInFirst': 'Debe marcar su ingreso antes del salida',
    },
    'TOOLS': {
      'ToolAlreadyExists': 'La herramienta ya existe',
      'ToolNotFound': 'Herramienta no encontrada',
      'ToolsNotFound': 'Algunas herramientas no existen o están inactivas',
      'ToolsNotAvailable': 'Algunas herramientas no están disponibles para asignación',
      'ToolsAlreadyInUse': 'Algunas herramientas ya están en asignaciones activas',
      'AssignmentNotFound': 'Asignación no encontrada',
      'AssignmentNotInUse': 'La asignación no está en uso',
      'ToolNotInAssignment': 'Herramienta no encontrada en la asignación',
    },
    'COMMON': {
      'PageDoesNotExist': 'La página no existe',
    },
    'INSURANCE': {
      'InsuranceCompanyNotFound': 'Empresa de seguros no encontrada',
      'InsuranceAssistanceNotFound': 'Asistencia no encontrada',
      'InsuranceAssistanceInvalidStatus':
          'La asistencia tiene un estado inválido',
      'InsuranceAssistanceCannotBeCancelled':
          'La asistencia no puede ser cancelada',
      'InsuranceAssistanceCannotBeUpdated':
          'La asistencia no puede ser actualizada',
      'InsuranceCompanyAlreadyExists': 'La empresa de seguros ya existe',
    },
  };

  /// Devuelve el mensaje amigable en español para [errorType] (ej: "USER.NewPasswordSameAsCurrent").
  /// Si no hay traducción, devuelve null.
  static String? getFriendlyMessage(String? errorType) {
    if (errorType == null || errorType.isEmpty) return null;
    final parts = errorType.split('.');
    if (parts.length != 2) return null;
    final category = parts[0];
    final code = parts[1];
    return _friendlyMessagesByCategory[category]?[code];
  }
}
