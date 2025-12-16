// External dependencies
import 'package:dio/dio.dart';
import 'package:electrivel_app/services/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// External dependencies
import 'package:go_router/go_router.dart';

// Internal dependencies
import 'package:electrivel_app/shared/shared.dart';
import 'package:electrivel_app/config/config.dart';

class DioInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.contains('auth')) {
      super.onRequest(options, handler);
      return;
    }

    final tokenResponse = await AuthDatasource().fetchTokenSession();
    if (tokenResponse.response.isError || tokenResponse.token == null) {
      handler.reject(
          DioException(
            requestOptions: options,
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {
                'error': {'type': 'UnauthorizedException'}
              },
            ),
          ),
          true);
      return;
    }

    options.headers['Authorization'] = 'Bearer ${tokenResponse.token}';
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    try {
      if (err.response == null || err.response?.data == null) {
        super.onError(err, handler);
        return;
      }

      final errorData = err.response!.data['error']['data'];
      final errorType = err.response!.data['error']['type'];
      final errorDataParsed = Map<String, dynamic>.from(errorData ?? {});

      if (err.response!.data['error']['type'] == 'UnauthorizedException') {
        final context = AppRoutes.navigatorKey.currentContext;
        await SharedPreferencesPlugin.clearAll();
        await SecureStoragePlugin.deleteAllStorage();
        await FlutterForegroundTask.stopService();
        context?.go(AppRoutes.login);
      }

      err = err.copyWith(
          message: FormatFunctions.formatError(errorType, errorDataParsed, err.response!.statusCode ?? 500));
      super.onError(err, handler);
    } catch (e) {
      super.onError(err, handler);
      return;
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      if (response.data == null || response.data is! Map<String, dynamic>) {
        super.onResponse(response, handler);
        return;
      }

      if (!response.data.containsKey('data')) {
        super.onResponse(response, handler);
        return;
      }

      response.data = response.data['data'];
      super.onResponse(response, handler);
    } catch (e) {
      super.onResponse(response, handler);
      return;
    }
  }

}