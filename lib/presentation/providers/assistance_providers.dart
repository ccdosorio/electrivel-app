import 'package:electrivel_app/services/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';

final assistanceListProvider = FutureProvider.family<
    List<AssistanceManagementModel>, bool>((ref, isEmployee) async {
  return AssistanceManagementDatasource().getAssistanceList(isEmployee);
});

final assistanceDetailProvider = StateProvider<AssistanceManagementModel>((ref) {
  return AssistanceManagementModel();
});