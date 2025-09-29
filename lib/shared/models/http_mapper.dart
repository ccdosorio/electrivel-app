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
    return HttpResponseSharedModel(
      data: response?.data,
      headers: response?.headers.map,
      statusCode: response?.statusCode ?? 200,
      isError: isError,
      errorMessage: exception?.message,
      errorType: '${exception?.response?.data is Map ? exception?.response?.data['error']['type'] : ''}',
      httpException: exception,
    );
  }
}
