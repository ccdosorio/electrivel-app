import 'package:dio/dio.dart';

class HttpResponseSharedModel {
  final dynamic data;
  final int statusCode;
  final bool isError;
  final String? errorMessage;
  final String? errorType;
  final Map<String, dynamic>? headers;
  final DioException? httpException;

  HttpResponseSharedModel({
    required this.data,
    required this.statusCode,
    required this.isError,
    required this.errorMessage,
    required this.errorType,
    required this.headers,
    this.httpException,
  });

  HttpResponseSharedModel copyWith({
    dynamic data,
    int? statusCode,
    bool? isError,
    String? errorMessage,
    String? errorType,
    Map<String, dynamic>? headers,
    DioException? httpException,
  }) {
    return HttpResponseSharedModel(
      data: data ?? this.data,
      statusCode: statusCode ?? this.statusCode,
      isError: isError ?? this.isError,
      errorMessage: errorMessage ?? this.errorMessage,
      errorType: errorMessage ?? this.errorType,
      headers: headers ?? this.headers,
      httpException: httpException ?? this.httpException,
    );
  }
}
