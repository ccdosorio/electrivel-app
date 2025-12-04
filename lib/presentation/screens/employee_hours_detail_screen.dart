import 'package:electrivel_app/config/theme/app_theme.dart';
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class EmployeeHoursDetailScreen extends HookConsumerWidget {
  const EmployeeHoursDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeDetailSearchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reporte de horas')),

      // BOTÓN FLOTANTE PARA ABRIR FILTROS
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => const EmployeeFilterModal(),
          );
        },
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.filter_list_rounded, color: Colors.white),
      ),

      body: Builder(
        builder: (context) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (state.error != null) {
            return Center(
              child: Text(
                'Error: ${state.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          // ESTADO INICIAL (Antes de buscar)
          if (state.result == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.manage_search_rounded,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Utiliza los filtros para generar el reporte',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          final data = state.result!;

          if (data.dailyRecords.isEmpty) {
            return const EmptyListWidget(
              message: 'No hay registros en este rango de fechas',
            );
          }

          // LISTA DE RESULTADOS
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              80,
            ), // Padding extra abajo para el FAB
            children: [
              // HEADER CON INFO DE LO QUE SE FILTRÓ
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text(
                  state.selectedUser?.fullName ?? '',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // KPI CARD PRINCIPAL
              _TotalHoursCard(
                totalDuration: data.totalWorkDuration,
                totalDays: data.totalDays,
                totalRecords: data.totalRecords,
              ),
              const SizedBox(height: 20),

              Text(
                'Detalle de ingresos y salidas',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // LISTA DE DÍAS
              ...data.dailyRecords.map(
                (daily) => _DailyRecordCard(daily: daily),
              ),
            ],
          );
        },
      ),
    );
  }
}

// --- WIDGET: TARJETA DE TOTALES (KPI) ---
class _TotalHoursCard extends StatelessWidget {
  final String totalDuration;
  final int totalDays;
  final int totalRecords;

  const _TotalHoursCard({
    required this.totalDuration,
    required this.totalDays,
    required this.totalRecords,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade700.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TOTAL HORAS',
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                totalDuration,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ],
          ),
          Container(height: 50, width: 1, color: Colors.white24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _miniStat('Días trabajados', '$totalDays'),
              const SizedBox(height: 8),
              _miniStat('Asistencias realizadas', '$totalRecords'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// --- WIDGET: TARJETA DE REGISTRO DIARIO ---
class _DailyRecordCard extends StatelessWidget {
  final DailyRecordModel daily;

  const _DailyRecordCard({required this.daily});

  @override
  Widget build(BuildContext context) {
    final fmtDate = DateFormat('EEE d, MMM', 'es').format(daily.workDate);
    final fmtTime = DateFormat('HH:mm');

    // Validamos si hay salida
    final hasCheckout = daily.checkOutTime != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                fmtDate.toUpperCase(),
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  daily.workDuration,
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: _timeColumn(
                  'Entrada',
                  fmtTime.format(daily.checkInTime),
                  daily.checkInLocation,
                  Icons.login_rounded,
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _timeColumn(
                  'Salida',
                  hasCheckout ? fmtTime.format(daily.checkOutTime!) : '--:--',
                  daily.checkOutLocation ?? 'Pendiente',
                  Icons.logout_rounded,
                  hasCheckout ? Colors.orange : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeColumn(
    String label,
    String time,
    String location,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          location,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
