enum ResponseTypeModel { json, stream, plain, bytes }

class HttpOptionsSharedModel {
  final Duration? sendTimeout;
  final Duration? receiveTimeout;
  final Map<String, dynamic>? headers;
  final ResponseTypeModel? responseType;
  final String? contentType;

  HttpOptionsSharedModel({
    this.sendTimeout,
    this.receiveTimeout,
    this.headers,
    this.responseType,
    this.contentType = 'application/json',
  });

  HttpOptionsSharedModel copyWith({
    Duration? sendTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? headers,
    ResponseTypeModel? responseType,
    String? contentType,
  }) {
    return HttpOptionsSharedModel(
      sendTimeout: sendTimeout ?? this.sendTimeout,
      receiveTimeout: receiveTimeout ?? this.receiveTimeout,
      headers: headers ?? this.headers,
      responseType: responseType ?? this.responseType,
      contentType: contentType ?? this.contentType,
    );
  }
}
