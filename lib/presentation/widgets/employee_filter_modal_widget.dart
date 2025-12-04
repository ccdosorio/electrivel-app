import 'package:electrivel_app/config/theme/app_theme.dart';
import 'package:electrivel_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:electrivel_app/presentation/presentation.dart';

class EmployeeFilterModal extends HookConsumerWidget {
  const EmployeeFilterModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeDetailSearchProvider);
    final notifier = ref.read(employeeDetailSearchProvider.notifier);
    final theme = Theme.of(context);

    // Helpers visuales
    final startLabel = state.startDate != null
        ? DateFormat('dd/MM/yyyy').format(state.startDate!)
        : 'Desde';

    final endLabel = state.endDate != null
        ? DateFormat('dd/MM/yyyy').format(state.endDate!)
        : 'Hasta';

    // Colores para indicar si está activo o vacío
    final startColor = state.startDate != null ? Colors.black87 : Colors.grey;
    final endColor = state.endDate != null ? Colors.black87 : Colors.grey;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header (Barrita y Título)
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => notifier.reset(),
                child: Text(
                  'Limpiar',
                  style: TextStyle(color: Colors.red.shade400),
                ),
              ),
              Text(
                'Filtros',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 60),
            ],
          ),
          const SizedBox(height: 20),

          // 1. EMPLEADO
          Text(
            'Empleado',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<UserModel>(
            value: state.selectedUser,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person_outline_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            isExpanded: true,
            items: state.availableUsers.map((user) {
              return DropdownMenuItem(
                value: user,
                child: Text(user.fullName, overflow: TextOverflow.ellipsis),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) notifier.setUser(val);
            },
            hint: state.isUsersLoading
                ? const Text('Cargando...')
                : const Text('Seleccionar empleado'),
          ),

          const SizedBox(height: 20),

          // 2. RANGO DE FECHAS
          Text(
            'Rango de fechas',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // FECHA INICIO
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      locale: const Locale('es', 'ES'),
                      initialDate: state.startDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      helpText: 'Fecha Inicio',
                    );
                    if (picked != null) {
                      notifier.setStartDate(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          startLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: startColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // FECHA FIN
              Expanded(
                child: InkWell(
                  onTap: () async {
                    // Validamos: No puede elegir fin si no hay inicio
                    if (state.startDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Seleccione primero la fecha de inicio',
                          ),
                        ),
                      );
                      return;
                    }

                    final picked = await showDatePicker(
                      context: context,
                      locale: const Locale('es', 'ES'),
                      initialDate: state.endDate ?? state.startDate!,
                      firstDate: state
                          .startDate!, // Bloqueamos fechas anteriores al inicio
                      lastDate: DateTime.now(),
                      helpText: 'Fecha Fin',
                    );
                    if (picked != null) {
                      notifier.setEndDate(picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.event_busy_outlined,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          endLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: endColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // BOTÓN
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            // Solo habilitado si las 3 cosas están seleccionadas
            onPressed: state.canSearch
                ? () {
                    Navigator.pop(context);
                    notifier.search();
                  }
                : null,
            child: const Text(
              'Buscar registros',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
