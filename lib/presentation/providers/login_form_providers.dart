// External dependencies
import 'package:electrivel_app/services/datasources/auth_datasource.dart';
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/legacy.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isObscure;
  final bool isLoading;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isObscure = true,
    this.isLoading = false,
  });

  LoginState copyWith({String? email, String? password, bool? isObscure, bool? isLoading}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isObscure: isObscure ?? this.isObscure,
      isLoading: isLoading ?? this.isLoading
    );
  }

  String? get validateEmail {
    if (email.trim().isEmpty) return 'Requerido';

    return null;
  }

  String? get validatePassword {
    if (password.trim().isEmpty) return 'Requerido';

    return null;
  }

  @override
  List<Object?> get props => [email, password, isObscure, isLoading];
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState());

  void cleanState() {
    state = LoginState();
  }

  void obscureText() {
    state = state.copyWith(isObscure: !state.isObscure);
  }

  void email(String email) {
    state = state.copyWith(email: email);
  }

  void password(String password) {
    state = state.copyWith(password: password);
  }

  void isLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  Future<(ResponseModel, AuthModel)> login() async {
    isLoading(true);
    final loginResponse = await AuthDatasource().login(state.email, state.password);
    isLoading(false);
    return loginResponse;
  }

  Future<void> logout() async {
    state = LoginState();
    await AuthDatasource().logout();
  }
}


final loginFormProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) {
  return LoginNotifier();
});