

import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class ToolAssignmentPageListModel extends PageListSharedModel<ToolAssignmentModel> {
  const ToolAssignmentPageListModel({ super.items, super.totalPages, super.currentPage });

  @override
  List<Object?> get props => [super.items, super.totalPages, super.currentPage];
}