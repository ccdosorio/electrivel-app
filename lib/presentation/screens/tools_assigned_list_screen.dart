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
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final textEditingController = useTextEditingController();

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
      appBar: AppBar(title: Text('Herramientas a mi cargo')),
      body: RefreshIndicator.adaptive(
        onRefresh: () async {
          pageController.refresh();
        },
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: PagedListView<int, ToolAssignmentModel>(
            pagingController: pageController,
            builderDelegate: PagedChildBuilderDelegate<ToolAssignmentModel>(
              itemBuilder: (context, item, index) => GestureDetector(
                onTap: () {
                  ref.read(toolsAssignedSelected.notifier).state = item;
                  context.push(AppRoutes.toolsAssignedDetail);
                },
                child: ToolAssignmentCard(
                  assignment: item,
                  onReturn: () async {
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => DialogWidget(
                        title: 'Confirmar esta acción',
                        content: Form(
                          key: formKey,
                          child: TextFormField(
                            controller: textEditingController,
                            decoration: InputDecorations.decoration(
                              labelText: 'Notas de retiro',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Requerido';
                              }
                              return null;
                            },
                          ),
                        ),
                        actions: [
                          DialogButtonWidget(
                            onPressed: () {
                              context.pop();
                            },
                            textButton: 'Cancelar',
                            isPrimary: false,
                          ),
                          DialogButtonWidget(
                            onPressed: () async {
                              final toolsIds = item.tools
                                  .map((item) => item.toolId)
                                  .toList();

                              final validate =
                                  formKey.currentState?.validate() ?? false;
                              if (!validate) return;

                              final response = await ToolsAssignmentDatasource()
                                  .returnAssignment(
                                    assignmentId: item.id,
                                    toolsIds: toolsIds,
                                    checkInNotes:
                                        textEditingController.value.text,
                                  );

                              if (response.isError) {
                                SnackBarNotifications.showGeneralSnackBar(
                                  title: 'Error',
                                  content: response.error!,
                                  theme: InfoThemeSnackBar.alert,
                                );
                                return;
                              }
                              pageController.refresh();

                              SnackBarNotifications.showGeneralSnackBar(
                                title: 'Éxito',
                                content: '¡Se ha devuelto con éxito!',
                                theme: InfoThemeSnackBar.ok,
                              );

                              if (!context.mounted) return;
                              textEditingController.clear();
                              context.pop();
                            },
                            textButton: 'Confirmar',
                            isPrimary: true,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              noItemsFoundIndicatorBuilder: (context) => const EmptyListWidget(
                message: 'No se encontraron resultados',
              ),
            ),
          ),
        ),
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
