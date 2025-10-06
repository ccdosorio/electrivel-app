// External dependencies
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/legacy.dart';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';

class UsersState extends Equatable {
  final List<UserModel> employees;
  final bool isLoading;
  final int currentPage;
  final int totalPages;
  final int total;
  final String? error;

  const UsersState({
    this.employees = const [],
    this.isLoading = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
    this.error,
  });

  @override
  List<Object?> get props => [employees, isLoading, currentPage, totalPages, total, error];

  UsersState copyWith({
    List<UserModel>? employees,
    bool? isLoading,
    int? currentPage,
    int? totalPages,
    int? total,
    String? error,
  }) {
    return UsersState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      error: error,
    );
  }
}

class UsersNotifier extends StateNotifier<UsersState> {
  UsersNotifier() : super(const UsersState());

  final _datasource = UsersDatasource();

  Future<void> loadEmployees({bool loadMore = false}) async {
    if (state.isLoading) return;
    
    state = state.copyWith(isLoading: true);

    final page = loadMore ? state.currentPage + 1 : 1;
    final (:response, :employeeList) = await _datasource.getEmployees(page: page);

    if (response.isError) {
      state = state.copyWith(
        isLoading: false,
        error: response.error,
      );
      return;
    }

    final data = employeeList!;
    final employees = loadMore 
        ? [...state.employees, ...data.employees]
        : data.employees;

    state = state.copyWith(
      isLoading: false,
      employees: employees,
      currentPage: data.currentPage,
      totalPages: data.totalPages,
      total: data.total,
      error: null,
    );
  }

  void reset() {
    state = const UsersState();
  }
}

final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  return UsersNotifier();
});