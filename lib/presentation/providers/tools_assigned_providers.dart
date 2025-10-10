import 'package:electrivel_app/services/services.dart';
import 'package:hooks_riverpod/legacy.dart';

final toolsAssignedSelected = StateProvider<ToolAssignmentModel>((ref) {
  return ToolAssignmentModel();
});

final reloadToolAssignedList = StateProvider<bool>((ref) {
  return false;
});
