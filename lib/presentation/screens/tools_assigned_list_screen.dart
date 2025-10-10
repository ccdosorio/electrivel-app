import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:electrivel_app/shared/shared.dart';

class ToolsAssignedList extends HookConsumerWidget {
  const ToolsAssignedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final pageController = useMemoized(
          () => PagingController<int, ToolAssignmentModel>(firstPageKey: 1),
    );

    useFetchPagedItems<ToolAssignmentModel>(
      controller: pageController,
      fetch: ToolsAssignmentDatasource().getPageList,
    );

    ref.listen(reloadToolAssignedList, (previous, next) {
      if (!next) return;

      pageController.refresh();
      ref.read(reloadToolAssignedList.notifier).state = false;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Herramientas a mi cargo'),
      ),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          pageController.refresh();
        },
        child: Padding(padding: EdgeInsets.only(bottom: 10), child: PagedListView(
            pagingController: pageController,
            builderDelegate: PagedChildBuilderDelegate<ToolAssignmentModel>(
              itemBuilder: (context, item, index) => GestureDetector(
                onTap: () {
                  ref.read(toolsAssignedSelected.notifier).state = item;
                  context.push(AppRoutes.toolsAssignedDetail);
                },
                child: ToolAssignmentCard(
                    assignment: item,
                    onReturn: () {

                    },
                ),
              ),
              noItemsFoundIndicatorBuilder: (context) => SizedBox.shrink(),
            )
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppRoutes.toolsAssignedCreate);
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
