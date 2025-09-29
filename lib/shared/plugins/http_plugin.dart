// External dependencies
import 'dart:developer';

import 'package:dio/dio.dart';

// Internal dependencies
import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/shared/shared.dart';

class HttpPlugin {
  static Dio _getInstance() {
    final dio = Dio(BaseOptions(baseUrl: SharedConstants.urlBase));
    dio.interceptors.add(DioInterceptor());
    return dio;
  }

  static Future<HttpResponseSharedModel> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        HttpOptionsSharedModel? httpOptions,
      }) async {
    final http = _getInstance();
    final options = HttpMapper.httpOptionsModelToDioOptions(httpOptions);

    try {
      final response = await http.get(path, queryParameters: queryParameters, options: options);

      return HttpMapper.dioResponseToHttpResponseModel(null, response);
    } on DioException catch (e) {
      return HttpMapper.dioResponseToHttpResponseModel(e, e.response);
    }
  }

  static Future<HttpResponseSharedModel> post(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        HttpOptionsSharedModel? httpOptions,
      }) async {
    final http = _getInstance();
    final options = HttpMapper.httpOptionsModelToDioOptions(httpOptions);
    try {
      final response = await http.post(path, data: data, queryParameters: queryParameters, options: options);

      return HttpMapper.dioResponseToHttpResponseModel(null, response);
    } on DioException catch (e) {
      return HttpMapper.dioResponseToHttpResponseModel(e, e.response);
    } catch (e) {
      return HttpMapper.dioResponseToHttpResponseModel(null, null);
    }
  }

  static Future<HttpResponseSharedModel> put(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        HttpOptionsSharedModel? httpOptions,
      }) async {
    final http = _getInstance();
    final options = HttpMapper.httpOptionsModelToDioOptions(httpOptions);

    try {
      final response = await http.put(path, data: data, queryParameters: queryParameters, options: options);

      return HttpMapper.dioResponseToHttpResponseModel(null, response);
    } on DioException catch (e) {
      return HttpMapper.dioResponseToHttpResponseModel(e, e.response);
    }
  }

  static Future<HttpResponseSharedModel> patch(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        HttpOptionsSharedModel? httpOptions,
      }) async {
    final http = _getInstance();
    final options = HttpMapper.httpOptionsModelToDioOptions(httpOptions);

    try {
      final response = await http.patch(path, data: data, queryParameters: queryParameters, options: options);

      return HttpMapper.dioResponseToHttpResponseModel(null, response);
    } on DioException catch (e) {
      return HttpMapper.dioResponseToHttpResponseModel(e, e.response);
    }
  }

  static Future<HttpResponseSharedModel> delete(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        HttpOptionsSharedModel? httpOptions,
      }) async {
    final http = _getInstance();
    final options = HttpMapper.httpOptionsModelToDioOptions(httpOptions);

    try {
      final response = await http.delete(path, data: data, queryParameters: queryParameters, options: options);

      return HttpMapper.dioResponseToHttpResponseModel(null, response);
    } on DioException catch (e) {
      return HttpMapper.dioResponseToHttpResponseModel(e, e.response);
    }
  }
}
