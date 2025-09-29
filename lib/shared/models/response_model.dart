class ResponseModel {
  final String? error;
  final String? errorType;

  ResponseModel({this.error, this.errorType});

  bool get isError => error != null;
}