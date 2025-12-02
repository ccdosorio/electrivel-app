// Flutter
import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/shared/dialogs/dialog_button_widget.dart'
    show DialogButtonWidget;
import 'package:electrivel_app/shared/dialogs/dialog_widget.dart';
import 'package:electrivel_app/shared/models/models.dart';
import 'package:electrivel_app/shared/notification/snack_bar_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// External dependencies
import 'package:intl/intl.dart';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';

// ======= PÁGINA PRINCIPAL =======
class AssistanceManagementScreen extends HookConsumerWidget {
  final bool isEmployee;
  const AssistanceManagementScreen({super.key, this.isEmployee = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItems = ref.watch(assistanceListProvider(isEmployee));

    useEffect(() {
      ref.invalidate(assistanceListProvider(isEmployee));
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Asistencias en curso'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(assistanceListProvider(isEmployee));
        },
        child: asyncItems.when(
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
          error: (_, __) =>
              const Center(child: Text('Error al cargar asistencias')),
          data: (items) {
            if (items.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: const EmptyListWidget(
                      message: 'No hay asistencias asignadas',
                      icon: Icons.assignment_late_outlined,
                    ),
                  ),
                ),
              );
            }
            // ---------------------------------

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, i) =>
                  AssistanceCard(item: items[i], isEmployee: isEmployee),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemCount: items.length,
            );
          },
        ),
      ),
      floatingActionButton: isEmployee
          ? null
          : FloatingActionButton(
              onPressed: () async {
                context.push(AppRoutes.assistanceManagementCreate);
              },
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}

// ======= CARD =======
class AssistanceCard extends HookConsumerWidget {
  const AssistanceCard({
    super.key,
    required this.item,
    required this.isEmployee,
  });
  final AssistanceManagementModel item;
  final bool isEmployee;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final textEditingController = useTextEditingController();

    final theme = Theme.of(context);
    final dateFmt = DateFormat('dd/MM/yyyy • HH:mm');

    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header con gradiente y número de caso
          Container(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    'No. de caso: ${item.caseNumber}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _StatusPill(text: item.status),
              ],
            ),
          ),

          // Contenido
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.badge_rounded,
                  label: 'Empleado',
                  value: item.username,
                ),
                _InfoRow(
                  icon: Icons.apartment_rounded,
                  label: 'Aseguradora',
                  value: item.insuranceCompanyName,
                ),
                _InfoRow(
                  icon: Icons.person_rounded,
                  label: 'Cliente',
                  value: item.clientName,
                ),
                _InfoRow(
                  icon: Icons.phone_rounded,
                  label: 'Teléfono',
                  value: item.clientPhone,
                ),
                _InfoRow(
                  icon: Icons.location_on_rounded,
                  label: 'Dirección',
                  value: item.serviceAddress,
                ),
                _InfoRow(
                  icon: Icons.notes_rounded,
                  label: 'Descripción',
                  value: item.description,
                  maxLines: 2,
                ),
                const SizedBox(height: 8),
                _ChipLine(
                  icon: Icons.play_circle_fill_rounded,
                  label: 'Inicio',
                  value: item.startTimestamp != null
                      ? dateFmt.format(item.startTimestamp!)
                      : '',
                ),
                const SizedBox(height: 10),
                _ChipLine(
                  icon: Icons.stop_circle_rounded,
                  label: 'Fin',
                  value: item.endTimestamp != null
                      ? dateFmt.format(item.endTimestamp!)
                      : '',
                ),
              ],
            ),
          ),

          const Divider(height: 16, thickness: 1),

          // Acciones
          if (!isEmployee) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.visibility_rounded),
                      onPressed: () {
                        // TODO: abrir detalle
                      },
                      label: const Text('Ver'),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (isEmployee) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                      ),
                      onPressed: () {
                        showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => DialogWidget(
                            title: 'Confirmar esta acción',
                            content: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '¿Está seguro de ${item.startTimestamp == null ? 'iniciar' : 'finalizar'} la asistencia?',
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: textEditingController,
                                    decoration: InputDecorations.decoration(
                                      labelText: 'Notas',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty)
                                        return 'Requerido';
                                      return null;
                                    },
                                  ),
                                ],
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
                                  final validate =
                                      formKey.currentState?.validate() ?? false;
                                  if (!validate) return;

                                  final asyncPos = await ref.read(
                                    locationProvider.future,
                                  );
                                  final isStart = item.startTimestamp == null;

                                  var response = ResponseModel();

                                  if (isStart) {
                                    response =
                                        await AssistanceManagementDatasource()
                                            .start(
                                              item.id,
                                              pos: asyncPos,
                                              startNotes:
                                                  textEditingController.text,
                                            );
                                  } else {
                                    response =
                                        await AssistanceManagementDatasource()
                                            .complete(
                                              item.id,
                                              pos: asyncPos,
                                              endNotes:
                                                  textEditingController.text,
                                            );
                                  }

                                  textEditingController.clear();
                                  if (response.isError) {
                                    SnackBarNotifications.showGeneralSnackBar(
                                      title: 'Error',
                                      content: response.error!,
                                      theme: InfoThemeSnackBar.alert,
                                    );
                                    return;
                                  }

                                  SnackBarNotifications.showGeneralSnackBar(
                                    title: 'Éxito',
                                    content: '¡Se ha devuelto con éxito!',
                                    theme: InfoThemeSnackBar.ok,
                                  );

                                  ref.invalidate(
                                    assistanceListProvider(isEmployee),
                                  );
                                  if (!context.mounted) return;
                                  context.pop();
                                },
                                textButton: 'Confirmar',
                                isPrimary: true,
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        item.startTimestamp == null ? 'Iniciar' : 'Finalizar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ======= WIDGETS AUXILIARES =======

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  WidgetSpan(
                    child: Text(
                      value,
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipLine extends StatelessWidget {
  const _ChipLine({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.labelMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.text});
  final String text;

  Color _bg(String s, ColorScheme scheme) {
    switch (s) {
      case 'EN_PROCESO':
      case 'ongoing':
        return Colors.green.shade600.withValues(alpha: .18);
      case 'completado':
      case 'completed':
        return Colors.blue.shade700.withValues(alpha: .18);
      case 'cancelado':
      case 'canceled':
        return Colors.red.shade700.withValues(alpha: .18);
      case 'ASIGNADA':
      case 'pending':
        return Colors.orange.shade800.withValues(alpha: .18);
      default:
        return scheme.secondary.withValues(alpha: .18);
    }
  }

  Color _fg(String s) {
    switch (s) {
      case 'EN_PROCESO':
      case 'ongoing':
        return Colors.green.shade800;
      case 'completado':
      case 'completed':
        return Colors.blue.shade900;
      case 'cancelado':
      case 'canceled':
        return Colors.red.shade900;
      case 'ASIGNADA':
      case 'pending':
        return Colors.orange.shade900;
      default:
        return Colors.black87;
    }
  }

  String _description(String s) {
    switch (s) {
      case 'EN_PROCESO':
        return 'En proceso';
      case 'ASIGNADA':
        return 'Asignada';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _bg(text, scheme),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _fg(text).withValues(alpha: .2)),
      ),
      child: Text(
        _description(text),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: _fg(text),
          letterSpacing: .2,
        ),
      ),
    );
  }
}
