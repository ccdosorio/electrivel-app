import 'package:electrivel_app/services/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final assistanceListProvider = FutureProvider.family<
    List<AssistanceManagementModel>, bool>((ref, isEmployee) async {
  return AssistanceManagementDatasource().getAssistanceList(isEmployee);
});
