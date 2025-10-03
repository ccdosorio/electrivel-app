// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class SessionData {
  final DateTime expirationDate;
  final String token;
  final String refreshToken;
  final DateTime refreshTokenExpiresIn;

  SessionData({
    required this.expirationDate,
    required this.token,
    required this.refreshToken,
    required this.refreshTokenExpiresIn,
  });
}

class AuthDatasource {

  Future<ResponseModel> login(String email, String password) async {
    final response = await HttpPlugin.post('/auth/login', data: {
      'username': email,
      'password': password
    });


    if (response.isError) {
      return ResponseModel(error: response.errorMessage);
    }

    final authModel = AuthModel.fromJson(response.data);
    await _saveToken(authModel);
    return ResponseModel();
  }

  Future<void> logout() async {
    await SharedPreferencesPlugin.clearAll();
    await SecureStoragePlugin.deleteAllStorage();
  }

  Future<void> _saveToken(AuthModel auth) async {
    await Future.wait([
      SharedPreferencesPlugin.writeStringValue(key: SecureStorageConstants.token, value: auth.accessToken),
      SharedPreferencesPlugin.writeStringValue(
          key: SecureStorageConstants.refreshToken, value: auth.refreshToken),
      SharedPreferencesPlugin.writeIntValue(
        key: SharedPreferencesConstants.expirationToken,
        value: auth.expireIn,
      ),
      SharedPreferencesPlugin.writeIntValue(
        key: SharedPreferencesConstants.refreshTokenExpiresIn,
        value: auth.refreshExpiresIn,
      ),
      SharedPreferencesPlugin.writeStringValue(
          key: SharedPreferencesConstants.username, value: auth.user.username),
      SharedPreferencesPlugin.writeStringValue(
          key: SharedPreferencesConstants.fullName,
          value: auth.user.fullName
      )
    ]);
  }

  Future<SessionData> _readSessionData() async {
    final results = await Future.wait([
      SharedPreferencesPlugin.getIntValue(key: SharedPreferencesConstants.expirationToken),
      SharedPreferencesPlugin.getStringValue(key: SecureStorageConstants.token),
      SharedPreferencesPlugin.getStringValue(key: SecureStorageConstants.refreshToken),
      SharedPreferencesPlugin.getIntValue(key: SharedPreferencesConstants.refreshTokenExpiresIn),
    ]);

    return SessionData(
      expirationDate: DateTime.fromMillisecondsSinceEpoch((results[0] as int) * 1000),
      token: results[1] as String,
      refreshToken: results[2] as String,
      refreshTokenExpiresIn: DateTime.fromMillisecondsSinceEpoch((results[3] as int) * 1000),
    );
  }

  Future<({ResponseModel response, String? token})> fetchTokenSession() async {
    final sessionData = await _readSessionData();

    final expirationDate = sessionData.expirationDate;
    final token = sessionData.token;
    final refreshTokenContent = sessionData.refreshToken;

    if (token.isEmpty && refreshTokenContent.isEmpty) {
      return (response: ResponseModel(error: 'No existe sesión'), token: null);
    }

    final timeLeft = expirationDate.difference(DateTime.now()).inMinutes;
    if (timeLeft > 60) {
      return (response: ResponseModel(), token: token);
    }

    final refreshResult = await HttpPlugin.post('/auth/refresh-token', data: {
      'refreshToken': sessionData
    });

    final authModel = AuthModel.fromJson(refreshResult.data);
    if (!refreshResult.isError && authModel.accessToken != '') {
      await _saveToken(authModel);
      return (response: ResponseModel(), token: authModel.accessToken);
    }

    return (response: ResponseModel(error: 'Error al refrescar el token'), token: null);
  }
}