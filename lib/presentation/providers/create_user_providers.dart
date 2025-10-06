// External dependencies
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/legacy.dart';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class CreateUserState extends Equatable {
  final bool isLoading;
  final List<RoleModel> roles;
  final List<CompanyModel> companies;
  final String? selectedRoleId;
  final String? selectedCompanyId;
  final String username;
  final String fullName;
  final String password;

  const CreateUserState({
    this.isLoading = false,
    this.roles = const [],
    this.companies = const [],
    this.selectedRoleId,
    this.selectedCompanyId,
    this.username = '',
    this.fullName = '',
    this.password = '',
  });

  @override
  List<Object?> get props => [
    isLoading,
    roles,
    companies,
    selectedRoleId,
    selectedCompanyId,
    username,
    fullName,
    password,
  ];

  String? get validateUsername {
    if (username.trim().isEmpty) return 'Requerido';
    return null;
  }

  String? get validateFullName {
    if (fullName.trim().isEmpty) return 'Requerido';
    return null;
  }

  String? get validatePassword {
    if (password.trim().isEmpty) return 'Requerido';
    if (password.length < 6) return 'La contraseña debe tener al menos 6 caracteres';
    return null;
  }

  CreateUserState copyWith({
    bool? isLoading,
    List<RoleModel>? roles,
    List<CompanyModel>? companies,
    String? selectedRoleId,
    String? selectedCompanyId,
    String? username,
    String? fullName,
    String? password,
  }) {
    return CreateUserState(
      isLoading: isLoading ?? this.isLoading,
      roles: roles ?? this.roles,
      companies: companies ?? this.companies,
      selectedRoleId: selectedRoleId ?? this.selectedRoleId,
      selectedCompanyId: selectedCompanyId ?? this.selectedCompanyId,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
    );
  }
}

class CreateUserNotifier extends StateNotifier<CreateUserState> {
  CreateUserNotifier() : super(const CreateUserState());

  final _usersDatasource = UsersDatasource();
  final _companiesDatasource = CompaniesDatasource();

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true);

    final rolesResult = await _usersDatasource.getRoles();
    final companiesResult = await _companiesDatasource.getCompanies();

    state = state.copyWith(
      isLoading: false,
      roles: rolesResult.roles ?? [],
      companies: companiesResult.companies ?? [],
    );
  }

  void username(String value) {
    state = state.copyWith(username: value);
  }

  void fullName(String value) {
    state = state.copyWith(fullName: value);
  }

  void password(String value) {
    state = state.copyWith(password: value);
  }

  void selectRole(String roleId) {
    state = state.copyWith(selectedRoleId: roleId);
  }

  void selectCompany(String companyId) {
    state = state.copyWith(selectedCompanyId: companyId);
  }

  bool validateForm() {
    return state.validateUsername == null &&
        state.validateFullName == null &&
        state.validatePassword == null &&
        state.selectedRoleId != null &&
        state.selectedCompanyId != null;
  }

  void resetForm() {
    state = state.copyWith(
      username: '',
      fullName: '',
      password: '',
      selectedRoleId: null,
      selectedCompanyId: null,
    );
  }

  Future<ResponseModel> createUser() async {
    if (!validateForm()) {
      return ResponseModel(error: 'Por favor completa todos los campos');
    }

    state = state.copyWith(isLoading: true);

    final user = CreateUserModel(
      username: state.username,
      fullName: state.fullName,
      password: state.password,
      roleId: state.selectedRoleId!,
      companyId: state.selectedCompanyId!,
    );

    final response = await _usersDatasource.createUser(user);

    state = state.copyWith(isLoading: false);

    if (!response.isError) {
      resetForm();
    }

    return response;
  }

  void reset() {
    state = const CreateUserState();
  }
}

final createUserProvider = StateNotifierProvider<CreateUserNotifier, CreateUserState>((ref) {
  return CreateUserNotifier();
});