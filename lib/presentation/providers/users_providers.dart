// External dependencies
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/legacy.dart';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';

class UsersState extends Equatable {
  final List<UserModel> users;
  final bool isLoading;
  final int currentPage;
  final int totalPages;
  final int total;
  final String? error;

  const UsersState({
    this.users = const [],
    this.isLoading = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
    this.error,
  });

  @override
  List<Object?> get props => [
    users,
    isLoading,
    currentPage,
    totalPages,
    total,
    error,
  ];

  UsersState copyWith({
    List<UserModel>? users,
    bool? isLoading,
    int? currentPage,
    int? totalPages,
    int? total,
    String? error,
  }) {
    return UsersState(
      users: users ?? this.users,
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

  Future<void> loadUsers({bool loadMore = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    final page = loadMore ? state.currentPage + 1 : 1;
    final (:response, :employeeList) = await _datasource.getUsers(page: page);

    if (response.isError) {
      state = state.copyWith(isLoading: false, error: response.error);
      return;
    }

    final data = employeeList!;
    final users = loadMore ? [...state.users, ...data.users] : data.users;

    state = state.copyWith(
      isLoading: false,
      users: users,
      currentPage: data.currentPage,
      totalPages: data.totalPages,
      total: data.total,
      error: null,
    );
  }

  Future<bool> deleteUser(int userId) async {
    final response = await _datasource.deactivateUser(userId);

    if (response.isError) {
      return false;
    }

    await loadUsers(loadMore: false);
    return true;
  }

  void reset() {
    state = const UsersState();
  }
}

final usersProvider = StateNotifierProvider<UsersNotifier, UsersState>((ref) {
  return UsersNotifier();
});
