import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/models/response_model.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:intl/intl.dart';

// --- ESTADO ---
class EmployeeHoursSearchState extends Equatable {
  final bool isLoading;
  final bool isUsersLoading;
  final String? error;

  final DateTime? startDate;
  final DateTime? endDate;

  final UserModel? selectedUser;
  final List<UserModel> availableUsers;

  // Resultado 1: Asistencias (Entradas/Salidas)
  // Renombrado de 'result' a 'attendanceResult' para ser explícitos
  final AttendanceDetailModel? attendanceResult;

  // Resultado 2: Asistencias Técnicas (Servicios completados)
  final UserCompletedAssistancesModel? assistanceResult;

  const EmployeeHoursSearchState({
    this.isLoading = false,
    this.isUsersLoading = false,
    this.error,
    this.startDate,
    this.endDate,
    this.selectedUser,
    this.availableUsers = const [],
    this.attendanceResult,
    this.assistanceResult,
  });

  // Validamos que ambas existan para habilitar el botón
  bool get canSearch =>
      selectedUser != null && startDate != null && endDate != null;

  EmployeeHoursSearchState copyWith({
    bool? isLoading,
    bool? isUsersLoading,
    String? error,
    DateTime? startDate,
    DateTime? endDate,
    UserModel? selectedUser,
    List<UserModel>? availableUsers,
    AttendanceDetailModel? attendanceResult,
    UserCompletedAssistancesModel? assistanceResult,
  }) {
    return EmployeeHoursSearchState(
      isLoading: isLoading ?? this.isLoading,
      isUsersLoading: isUsersLoading ?? this.isUsersLoading,
      error: error,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedUser: selectedUser ?? this.selectedUser,
      availableUsers: availableUsers ?? this.availableUsers,
      attendanceResult: attendanceResult ?? this.attendanceResult,
      assistanceResult: assistanceResult ?? this.assistanceResult,
    );
  }

  // Método especial para limpiar fechas
  EmployeeHoursSearchState clearDates() {
    return EmployeeHoursSearchState(
      isLoading: isLoading,
      isUsersLoading: isUsersLoading,
      error: error,
      selectedUser: selectedUser,
      availableUsers: availableUsers,
      attendanceResult: attendanceResult,
      assistanceResult: assistanceResult,
      startDate: null,
      endDate: null,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isUsersLoading,
    error,
    startDate,
    endDate,
    selectedUser,
    availableUsers,
    attendanceResult,
    assistanceResult,
  ];
}

// --- NOTIFIER ---
class EmployeeHoursSearchNotifier
    extends StateNotifier<EmployeeHoursSearchState> {
  EmployeeHoursSearchNotifier() : super(const EmployeeHoursSearchState());

  final _attendanceDatasource = AttendanceDatasource();
  final _usersDatasource = UsersDatasource();
  // Inyectamos el nuevo datasource
  final _assistanceDatasource = AssistanceManagementDatasource();

  Future<void> loadUsersCatalog() async {
    state = state.copyWith(isUsersLoading: true);
    final (:response, :users) = await _usersDatasource.getUsersCatalog();

    if (response.isError) {
      state = state.copyWith(isUsersLoading: false, error: response.error);
      return;
    }
    state = state.copyWith(isUsersLoading: false, availableUsers: users);
  }

  // --- SETTERS ---

  void setStartDate(DateTime date) {
    DateTime? newEnd = state.endDate;
    if (newEnd != null && date.isAfter(newEnd)) {
      newEnd = null;
    }

    // Usamos copyWith para mantener los otros estados (como availableUsers o resultados previos)
    state = state.copyWith(startDate: date, endDate: newEnd);
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(endDate: date);
  }

  void setUser(UserModel user) {
    state = state.copyWith(selectedUser: user);
  }

  Future<void> search() async {
    if (!state.canSearch) return;

    state = state.copyWith(isLoading: true, error: null);

    final start = DateFormat('yyyy-MM-dd').format(state.startDate!);
    final end = DateFormat('yyyy-MM-dd').format(state.endDate!);
    final username = state.selectedUser!.username;

    try {
      // Usamos Future.wait para paralelizar las peticiones
      final results = await Future.wait([
        // 1. Asistencia (Reloj)
        _attendanceDatasource.getEmployeeAttendanceDetail(
          username: username,
          startDate: start,
          endDate: end,
        ),
        // 2. Servicios Técnicos
        _assistanceDatasource.getUserCompletedAssistances(
          username: username,
          startDate: start,
          endDate: end,
        ),
      ]);

      // Casteamos los resultados (Dart Records)
      final attendanceResp =
          results[0]
              as ({
                ResponseModel response,
                AttendanceDetailModel? attendanceDetail,
              });
      final assistanceResp =
          results[1]
              as ({
                ResponseModel response,
                UserCompletedAssistancesModel? data,
              });

      // Validamos errores
      if (attendanceResp.response.isError) {
        state = state.copyWith(
          isLoading: false,
          error: attendanceResp.response.error,
        );
        return;
      }

      if (assistanceResp.response.isError) {
        state = state.copyWith(
          isLoading: false,
          error: assistanceResp.response.error,
        );
        return;
      }

      // Éxito: Guardamos ambos modelos
      state = state.copyWith(
        isLoading: false,
        attendanceResult: attendanceResp.attendanceDetail,
        assistanceResult: assistanceResp.data,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void reset() {
    state = const EmployeeHoursSearchState();
    loadUsersCatalog();
  }
}

final employeeDetailSearchProvider =
    StateNotifierProvider.autoDispose<
      EmployeeHoursSearchNotifier,
      EmployeeHoursSearchState
    >((ref) {
      final notifier = EmployeeHoursSearchNotifier();
      notifier.loadUsersCatalog();
      return notifier;
    });
