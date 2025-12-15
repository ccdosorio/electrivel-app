import 'dart:convert';

UserCompletedAssistancesModel userCompletedAssistancesModelFromJson(String str) =>
    UserCompletedAssistancesModel.fromJson(json.decode(str));

String userCompletedAssistancesModelToJson(UserCompletedAssistancesModel data) =>
    json.encode(data.toJson());

class UserCompletedAssistancesModel {
  final String username;
  final QueryPeriodModel queryPeriod;
  final AssistanceMetricsModel metrics;
  final List<CompletedAssistanceItemModel> assistances;

  UserCompletedAssistancesModel({
    required this.username,
    required this.queryPeriod,
    required this.metrics,
    required this.assistances,
  });

  UserCompletedAssistancesModel copyWith({
    String? username,
    QueryPeriodModel? queryPeriod,
    AssistanceMetricsModel? metrics,
    List<CompletedAssistanceItemModel>? assistances,
  }) =>
      UserCompletedAssistancesModel(
        username: username ?? this.username,
        queryPeriod: queryPeriod ?? this.queryPeriod,
        metrics: metrics ?? this.metrics,
        assistances: assistances ?? this.assistances,
      );

  factory UserCompletedAssistancesModel.fromJson(Map<String, dynamic> json) =>
      UserCompletedAssistancesModel(
        username: json["username"],
        queryPeriod: QueryPeriodModel.fromJson(json["queryPeriod"]),
        metrics: AssistanceMetricsModel.fromJson(json["metrics"]),
        assistances: List<CompletedAssistanceItemModel>.from(
            json["assistances"].map((x) => CompletedAssistanceItemModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "queryPeriod": queryPeriod.toJson(),
        "metrics": metrics.toJson(),
        "assistances": List<dynamic>.from(assistances.map((x) => x.toJson())),
      };
}

class QueryPeriodModel {
  final String from;
  final String to;

  QueryPeriodModel({
    required this.from,
    required this.to,
  });

  QueryPeriodModel copyWith({
    String? from,
    String? to,
  }) =>
      QueryPeriodModel(
        from: from ?? this.from,
        to: to ?? this.to,
      );

  factory QueryPeriodModel.fromJson(Map<String, dynamic> json) => QueryPeriodModel(
        from: json["from"],
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
      };
}

class AssistanceMetricsModel {
  final int totalCompleted;
  final int totalDurationMs;
  final String formattedDuration;
  final double totalHoursDecimal;

  AssistanceMetricsModel({
    required this.totalCompleted,
    required this.totalDurationMs,
    required this.formattedDuration,
    required this.totalHoursDecimal,
  });

  AssistanceMetricsModel copyWith({
    int? totalCompleted,
    int? totalDurationMs,
    String? formattedDuration,
    double? totalHoursDecimal,
  }) =>
      AssistanceMetricsModel(
        totalCompleted: totalCompleted ?? this.totalCompleted,
        totalDurationMs: totalDurationMs ?? this.totalDurationMs,
        formattedDuration: formattedDuration ?? this.formattedDuration,
        totalHoursDecimal: totalHoursDecimal ?? this.totalHoursDecimal,
      );

  factory AssistanceMetricsModel.fromJson(Map<String, dynamic> json) =>
      AssistanceMetricsModel(
        totalCompleted: json["totalCompleted"],
        totalDurationMs: json["totalDurationMs"],
        formattedDuration: json["formattedDuration"],
        totalHoursDecimal: (json["totalHoursDecimal"] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "totalCompleted": totalCompleted,
        "totalDurationMs": totalDurationMs,
        "formattedDuration": formattedDuration,
        "totalHoursDecimal": totalHoursDecimal,
      };
}

class CompletedAssistanceItemModel {
  final int id;
  final String caseNumber;
  final String clientName;
  final String serviceAddress;
  final DateTime startTimestamp;
  final DateTime endTimestamp;
  final String duration;

  CompletedAssistanceItemModel({
    required this.id,
    required this.caseNumber,
    required this.clientName,
    required this.serviceAddress,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.duration,
  });

  CompletedAssistanceItemModel copyWith({
    int? id,
    String? caseNumber,
    String? clientName,
    String? serviceAddress,
    DateTime? startTimestamp,
    DateTime? endTimestamp,
    String? duration,
  }) =>
      CompletedAssistanceItemModel(
        id: id ?? this.id,
        caseNumber: caseNumber ?? this.caseNumber,
        clientName: clientName ?? this.clientName,
        serviceAddress: serviceAddress ?? this.serviceAddress,
        startTimestamp: startTimestamp ?? this.startTimestamp,
        endTimestamp: endTimestamp ?? this.endTimestamp,
        duration: duration ?? this.duration,
      );

  factory CompletedAssistanceItemModel.fromJson(Map<String, dynamic> json) =>
      CompletedAssistanceItemModel(
        id: json["id"],
        caseNumber: json["caseNumber"],
        clientName: json["clientName"],
        serviceAddress: json["serviceAddress"],
        startTimestamp: DateTime.parse(json["startTimestamp"]),
        endTimestamp: DateTime.parse(json["endTimestamp"]),
        duration: json["duration"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "caseNumber": caseNumber,
        "clientName": clientName,
        "serviceAddress": serviceAddress,
        "startTimestamp": startTimestamp.toIso8601String(),
        "endTimestamp": endTimestamp.toIso8601String(),
        "duration": duration,
      };
}