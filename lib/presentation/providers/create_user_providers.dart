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
  final String? validateUsername;
  final String? validateFullName;
  final String? validatePassword;

  const CreateUserState({
    this.isLoading = false,
    this.roles = const [],
    this.companies = const [],
    this.selectedRoleId,
    this.selectedCompanyId,
    this.validateUsername,
    this.validateFullName,
    this.validatePassword,
  });

  @override
  List<Object?> get props => [
    isLoading,
    roles,
    companies,
    selectedRoleId,
    selectedCompanyId,
    validateUsername,
    validateFullName,
    validatePassword,
  ];

  CreateUserState copyWith({
    bool? isLoading,
    List<RoleModel>? roles,
    List<CompanyModel>? companies,
    String? selectedRoleId,
    String? selectedCompanyId,
    String? validateUsername,
    String? validateFullName,
    String? validatePassword,
  }) {
    return CreateUserState(
      isLoading: isLoading ?? this.isLoading,
      roles: roles ?? this.roles,
      companies: companies ?? this.companies,
      selectedRoleId: selectedRoleId ?? this.selectedRoleId,
      selectedCompanyId: selectedCompanyId ?? this.selectedCompanyId,
      validateUsername: validateUsername,
      validateFullName: validateFullName,
      validatePassword: validatePassword,
    );
  }
}

class CreateUserNotifier extends StateNotifier<CreateUserState> {
  CreateUserNotifier() : super(const CreateUserState());

  final _usersDatasource = UsersDatasource();
  final _companiesDatasource = CompaniesDatasource();

  String _username = '';
  String _fullName = '';
  String _password = '';

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
    _username = value;
    _validateUsername();
  }

  void fullName(String value) {
    _fullName = value;
    _validateFullName();
  }

  void password(String value) {
    _password = value;
    _validatePassword();
  }

  void selectRole(String roleId) {
    state = state.copyWith(selectedRoleId: roleId);
  }

  void selectCompany(String companyId) {
    state = state.copyWith(selectedCompanyId: companyId);
  }

  void _validateUsername() {
    if (_username.isEmpty) {
      state = state.copyWith(validateUsername: 'El nombre de usuario es requerido');
      return;
    }
    state = state.copyWith(validateUsername: null);
  }

  void _validateFullName() {
    if (_fullName.isEmpty) {
      state = state.copyWith(validateFullName: 'El nombre completo es requerido');
      return;
    }
    state = state.copyWith(validateFullName: null);
  }

  void _validatePassword() {
    if (_password.isEmpty) {
      state = state.copyWith(validatePassword: 'La contraseña es requerida');
      return;
    }
    if (_password.length < 6) {
      state = state.copyWith(validatePassword: 'La contraseña debe tener al menos 6 caracteres');
      return;
    }
    state = state.copyWith(validatePassword: null);
  }

  bool validateForm() {
    _validateUsername();
    _validateFullName();
    _validatePassword();

    return state.validateUsername == null &&
        state.validateFullName == null &&
        state.validatePassword == null &&
        state.selectedRoleId != null &&
        state.selectedCompanyId != null;
  }

void resetForm() {
  _username = '';
  _fullName = '';
  _password = '';
  state = state.copyWith(
    selectedRoleId: null,
    selectedCompanyId: null,
    validateUsername: null,
    validateFullName: null,
    validatePassword: null,
  );
}

Future<ResponseModel> createUser() async {
  if (!validateForm()) {
    return ResponseModel(error: 'Por favor completa todos los campos');
  }

  state = state.copyWith(isLoading: true);

  final user = CreateUserModel(
    username: _username,
    fullName: _fullName,
    password: _password,
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
    _username = '';
    _fullName = '';
    _password = '';
    state = const CreateUserState();
  }
}

final createUserProvider = StateNotifierProvider<CreateUserNotifier, CreateUserState>((ref) {
  return CreateUserNotifier();
});