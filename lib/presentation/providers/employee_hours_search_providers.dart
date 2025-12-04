import 'package:electrivel_app/services/services.dart';
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
  final AttendanceDetailModel? result;

  const EmployeeHoursSearchState({
    this.isLoading = false,
    this.isUsersLoading = false,
    this.error,
    this.startDate,
    this.endDate,
    this.selectedUser,
    this.availableUsers = const [],
    this.result,
  });

  // Validamos que ambas existan para habilitar el botón
  bool get canSearch =>
      selectedUser != null && startDate != null && endDate != null;

  AttendanceDetailModel? get data => result;

  EmployeeHoursSearchState copyWith({
    bool? isLoading,
    bool? isUsersLoading,
    String? error,
    DateTime? startDate,
    DateTime? endDate,
    UserModel? selectedUser,
    List<UserModel>? availableUsers,
    AttendanceDetailModel? result,
  }) {
    return EmployeeHoursSearchState(
      isLoading: isLoading ?? this.isLoading,
      isUsersLoading: isUsersLoading ?? this.isUsersLoading,
      error: error,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedUser: selectedUser ?? this.selectedUser,
      availableUsers: availableUsers ?? this.availableUsers,
      result: result ?? this.result,
    );
  }

  // Método especial para limpiar fechas si es necesario
  EmployeeHoursSearchState clearDates() {
    return EmployeeHoursSearchState(
      isLoading: isLoading,
      isUsersLoading: isUsersLoading,
      error: error,
      selectedUser: selectedUser,
      availableUsers: availableUsers,
      result: result,
      startDate: null, // Limpiamos
      endDate: null, // Limpiamos
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
    result,
  ];
}

// --- NOTIFIER ---
class EmployeeHoursSearchNotifier
    extends StateNotifier<EmployeeHoursSearchState> {
  EmployeeHoursSearchNotifier()
    : super(const EmployeeHoursSearchState());

  final _attendanceDatasource = AttendanceDatasource();
  final _usersDatasource = UsersDatasource();

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
    } else {
    }

    state = EmployeeHoursSearchState(
      isLoading: state.isLoading,
      isUsersLoading: state.isUsersLoading,
      error: state.error,
      selectedUser: state.selectedUser,
      availableUsers: state.availableUsers,
      result: state.result,
      startDate: date,
      endDate: newEnd,
    );
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

    final (:response, :attendanceDetail) = await _attendanceDatasource
        .getEmployeeAttendanceDetail(
          username: username,
          startDate: start,
          endDate: end,
        );

    if (response.isError) {
      state = state.copyWith(isLoading: false, error: response.error);
      return;
    }

    state = state.copyWith(isLoading: false, result: attendanceDetail);
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
