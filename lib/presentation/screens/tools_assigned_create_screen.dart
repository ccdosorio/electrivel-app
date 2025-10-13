import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ToolsAssignedCreateScreen extends HookConsumerWidget {
  const ToolsAssignedCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final notesController = useTextEditingController();

    final selectedTool = useState<String?>(null);
    final allTools        = useState<List<ToolModel>>([]);
    final availableTools  = useState<List<ToolModel>>([]);
    final selectedTools   = useState<List<ToolModel>>([]);

    final toolsCatalogFuture = useMemoized(
      () => ToolsDatasource().getToolsCatalog(),
    );
    final toolsSnap = useFuture(toolsCatalogFuture);

    void calculateAvailable() {
      final selectedIds = selectedTools.value.map((e) => e.id).toSet();
      availableTools.value = allTools.value
          .where((t) => !selectedIds.contains(t.id))
          .toList();
    }

    useEffect(() {
      if (toolsSnap.hasData) {
        allTools.value = toolsSnap.data!;
        calculateAvailable();
      }
      return null;
    }, [toolsSnap.data]);

    void onAdd() {
      final id = selectedTool.value;
      if (id == null) return;

      final tool = allTools.value.firstWhere((t) => t.id == id);
      selectedTools.value = [...selectedTools.value, tool];

      selectedTool.value = null;
      calculateAvailable();
    }

    void onRemove(String id) {
      selectedTools.value =
          selectedTools.value.where((t) => t.id != id).toList();
      calculateAvailable();
    }

    final isLoading = toolsSnap.connectionState == ConnectionState.waiting;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Retirar Herramientas')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _Title(
                title: 'Agregar Herramienta',
                icon: Icons.search,
              ),
              const SizedBox(height: 20),
              _NotesTextArea(notesController),
              const SizedBox(height: 20),
              CustomFormDropDown<ToolModel, String>(
                getLabel: (t) => Text(t.name),
                getValue: (t) => t.id,
                labelText: 'Selecciona una herramienta',
                active: (value) => value.isActive && value.isAvailable,
                value: selectedTool.value,
                options: availableTools.value,
                onChanged: (value) => selectedTool.value = value,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton.tonal(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.secondaryColor,
                    disabledBackgroundColor: Colors.grey.shade300,
                    disabledForegroundColor: Colors.grey.shade700,
                  ),
                  onPressed: (selectedTool.value == null) ? null : onAdd,
                  child: Text(
                    'Agergar Herramienta',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _Title(
                title: 'Herramientas seleccionadas',
                icon: FontAwesomeIcons.toolbox,
              ),
              const SizedBox(height: 20),
              ...selectedTools.value.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ToolCard(
                  tool: t,
                  onRemove: () => onRemove(t.id),
                ),
              ))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          final validate = formKey.currentState?.validate() ?? false;
          if (!validate) return;

          if (selectedTools.value.isEmpty) {
            SnackBarNotifications.showGeneralSnackBar(
                title: 'Error',
                content: 'No seleccionó ninguna herramienta',
                theme: InfoThemeSnackBar.alert
            );
            return;
          }

          final response = await ToolsAssignmentDatasource().save(
              notes: notesController.text,
              selectedTools: selectedTools.value
          );

          if (response.isError) {
            SnackBarNotifications.showGeneralSnackBar(
                title: 'Error',
                content: response.error ?? '',
                theme: InfoThemeSnackBar.alert
            );
            return;
          }

          SnackBarNotifications.showGeneralSnackBar(
              title: 'Éxito',
              content: 'Herramientas retiradas correctamente',
              theme: InfoThemeSnackBar.ok
          );
          ref.read(reloadToolAssignedList.notifier).state = true;
          if (!context.mounted) return;

          context.push(AppRoutes.tools);
        },
        child: Icon(Icons.save, color: Colors.white),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final IconData icon;
  final String title;

  const _Title({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, color: AppTheme.secondaryColor),
        const SizedBox(width: 10),
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _ToolCard extends StatelessWidget {
  final ToolModel tool;
  final VoidCallback onRemove;

  const _ToolCard({required this.tool, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 2),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    tool.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (tool.category.isNotEmpty == true)
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor.withOpacity(.12),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      tool.category.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.secondaryColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: .2,
                      ),
                    ),
                  ),
                const SizedBox(width: 10),
                IconButton(
                  tooltip: 'Eliminar',
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onRemove,
                )
              ],
            ),

            const SizedBox(height: 6),
            Text('ID: ${tool.id}',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: Colors.grey[700])),

            const SizedBox(height: 12),

            // Caja de notas (placeholder)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(.06),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.note_outlined, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Notas:',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(
                          tool.maintenanceNotes?.isNotEmpty == true
                              ? tool.maintenanceNotes!
                              : '—',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _NotesTextArea extends StatelessWidget {
  final TextEditingController controller;
  const _NotesTextArea(this.controller);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notas del Retiro',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          minLines: 3,
          maxLines: 6,
          textInputAction: TextInputAction.newline,
          decoration: InputDecoration(
            hintText: 'Escribe cualquier observación sobre la herramienta...',
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          validator: (v) {
            if (v == null || v.isEmpty) return 'Requerido';
            return null;
          },
        ),
      ],
    );
  }
}
