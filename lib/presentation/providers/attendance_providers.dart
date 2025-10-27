import 'package:electrivel_app/services/services.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:intl/intl.dart';

class AttendanceState extends Equatable {
  final bool isLoading;
  final String? error;
  final AttendanceSummaryModel? attendanceSummary;
  final String selectedDate;

  const AttendanceState({
    this.isLoading = false,
    this.error,
    this.attendanceSummary,
    String? selectedDate,
  }) : selectedDate = selectedDate ?? '';

  @override
  List<Object?> get props => [isLoading, error, attendanceSummary, selectedDate];

  AttendanceState copyWith({
    bool? isLoading,
    String? error,
    AttendanceSummaryModel? attendanceSummary,
    String? selectedDate,
  }) {
    return AttendanceState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      attendanceSummary: attendanceSummary ?? this.attendanceSummary,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier() : super(AttendanceState(
    selectedDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
  ));

  final _datasource = AttendanceDatasource();

  Future<void> loadAttendance({String? date}) async {
    state = state.copyWith(isLoading: true);

    final selectedDate = date ?? state.selectedDate;
    final (:response, :attendanceSummary) = 
        await _datasource.getAttendanceEmployees(date: selectedDate);

    if (response.isError) {
      state = state.copyWith(
        isLoading: false,
        error: response.error,
      );
      return;
    }

    state = state.copyWith(
      isLoading: false,
      attendanceSummary: attendanceSummary,
      selectedDate: selectedDate,
      error: null,
    );
  }

  void selectDate(DateTime date) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);
    state = state.copyWith(selectedDate: formattedDate);
    loadAttendance(date: formattedDate);
  }

  void reset() {
    state = AttendanceState(
      selectedDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
  }
}

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  return AttendanceNotifier();
});