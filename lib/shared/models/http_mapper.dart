// External dependencies
import 'package:dio/dio.dart';

// Internal dependencies
import 'package:electrivel_app/shared/shared.dart';

class HttpMapper {
  static Options httpOptionsModelToDioOptions(HttpOptionsSharedModel? httpOptions) {
    if (httpOptions == null) {
      return Options(contentType: 'application/json');
    }

    return Options(
      sendTimeout: httpOptions.sendTimeout,
      receiveTimeout: httpOptions.receiveTimeout,
      headers: httpOptions.headers,
      responseType: httpOptions.responseType == null ? null : ResponseType.values[httpOptions.responseType!.index],
      contentType: httpOptions.contentType,
    );
  }

  static HttpResponseSharedModel dioResponseToHttpResponseModel(DioException? exception, Response<dynamic>? response) {
    final isError = exception != null;
    final responseData = exception?.response?.data ?? response?.data;
    return HttpResponseSharedModel(
      data: response?.data,
      headers: response?.headers.map,
      statusCode: exception?.response?.statusCode ?? response?.statusCode ?? 200,
      isError: isError,
      errorMessage: _extractErrorMessage(exception, responseData),
      errorType: _extractErrorType(responseData),
      httpException: exception,
    );
  }

  /// Extrae el mensaje del cuerpo de error del backend ({ error: { message: ... } }).
  static String? _extractErrorMessage(DioException? exception, dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final error = responseData['error'];
      if (error is Map<String, dynamic>) {
        final message = error['message'];
        if (message is String) return message;
        if (message is List && message.isNotEmpty) {
          return message.first is String ? message.first as String : message.first.toString();
        }
      }
    }
    return exception?.message;
  }

  /// Extrae el tipo de error del cuerpo del backend ({ error: { type: ... } }).
  static String? _extractErrorType(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final error = responseData['error'];
      if (error is Map<String, dynamic>) {
        final type = error['type'];
        if (type is String) return type;
      }
    }
    return null;
  }
}
