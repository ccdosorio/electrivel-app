import 'package:electrivel_app/config/theme/app_theme.dart';
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class EmployeeHoursDetailScreen extends HookConsumerWidget {
  const EmployeeHoursDetailScreen({super.key});

  /// CORRECCIÓN PUNTO 3: Parser robusto para formato "16h 2m" o "HH:mm"
  String _sumDurations(String? duration1, String? duration2) {
    Duration parseDuration(String s) {
      if (s.isEmpty) return Duration.zero;

      // Caso 1: Formato "16h 2m" (El que viene de tu backend)
      if (s.contains('h') || s.contains('m')) {
        int hours = 0;
        int minutes = 0;

        // Regex para extraer números antes de 'h'
        final hoursMatch = RegExp(r'(\d+)\s*h').firstMatch(s);
        if (hoursMatch != null) {
          hours = int.parse(hoursMatch.group(1)!);
        }

        // Regex para extraer números antes de 'm'
        final minutesMatch = RegExp(r'(\d+)\s*m').firstMatch(s);
        if (minutesMatch != null) {
          minutes = int.parse(minutesMatch.group(1)!);
        }
        return Duration(hours: hours, minutes: minutes);
      }

      // Caso 2: Formato "HH:mm:ss" o "HH:mm" (Fallback)
      if (s.contains(':')) {
        try {
          final parts = s.split(':').map(int.parse).toList();
          int h = parts[0];
          int m = parts.length > 1 ? parts[1] : 0;
          return Duration(hours: h, minutes: m);
        } catch (_) {}
      }

      return Duration.zero;
    }

    final d1 = parseDuration(duration1 ?? "0");
    final d2 = parseDuration(duration2 ?? "0");
    final total = d1 + d2;

    final h = total.inHours.toString().padLeft(2, '0');
    final m = (total.inMinutes % 60).toString().padLeft(2, '0');

    // Retornamos formato limpio HH:mm para el Card Principal
    return "$h:$m";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeDetailSearchProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Reporte de Actividad')),

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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.attendanceResult == null ||
              state.assistanceResult == null) {
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

          final attendanceData = state.attendanceResult!;
          final assistanceData = state.assistanceResult!;

          if (attendanceData.dailyRecords.isEmpty &&
              assistanceData.assistances.isEmpty) {
            return const EmptyListWidget(
              message: 'No hay actividad registrada en este rango de fechas',
            );
          }

          // CÁLCULO DEL TOTAL
          final grandTotalDuration = _sumDurations(
            attendanceData.totalWorkDuration,
            assistanceData.metrics.formattedDuration,
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
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
                totalDuration: grandTotalDuration,
                totalDays: attendanceData.totalDays,
                totalServices: assistanceData.metrics.totalCompleted,
              ),
              const SizedBox(height: 25),

              // --- SECCIÓN 1: ASISTENCIA (RELOJ) ---
              // Siempre mostramos el título, aunque esté vacío (opcional, pero consistente con la petición de abajo)
              if (attendanceData.dailyRecords.isNotEmpty) ...[
                // CORRECCIÓN PUNTO 2: Header con total de tiempo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Detalle de ingresos y salidas',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors
                            .green
                            .shade50, // Verde para diferenciar de servicios
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        attendanceData.totalWorkDuration, // Ej: "16h 2m"
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...attendanceData.dailyRecords.map(
                  (daily) => _DailyRecordCard(daily: daily),
                ),
                const SizedBox(height: 20),
              ],

              // --- SECCIÓN 2: ASISTENCIAS TÉCNICAS ---
              // CORRECCIÓN PUNTO 1: Siempre mostrar sección. Si vacío, mostrar mensaje.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalle de asistencias',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      assistanceData.metrics.formattedDuration, // Ej: "0h 3m"
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (assistanceData.assistances.isEmpty)
                // Mensaje si no hay registros
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.assignment_outlined,
                        color: Colors.grey.shade400,
                        size: 30,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "No se encontraron resultados",
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                )
              else
                // Lista si hay registros
                ...assistanceData.assistances.map(
                  (item) => _AssistanceRecordCard(item: item),
                ),
            ],
          );
        },
      ),
    );
  }
}

// --- WIDGET: CARD DE TOTALES (KPI) ---
class _TotalHoursCard extends StatelessWidget {
  final String totalDuration;
  final int totalDays;
  final int totalServices;

  const _TotalHoursCard({
    required this.totalDuration,
    required this.totalDays,
    required this.totalServices,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade700,
          ], // Un poco más oscuro para resaltar
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withOpacity(0.3),
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
                'TIEMPO TOTAL',
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
              _miniStat('Asistencias realizadas', '$totalServices'),
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

// --- WIDGET: CARD DE REGISTRO DIARIO (Existente) ---
class _DailyRecordCard extends StatelessWidget {
  final DailyRecordModel daily;

  const _DailyRecordCard({required this.daily});

  @override
  Widget build(BuildContext context) {
    final fmtDate = DateFormat('EEE d, MMM', 'es').format(daily.workDate);
    final fmtTime = DateFormat('HH:mm');
    final hasCheckout = daily.checkOutTime != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
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
          const Divider(height: 16),
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

// --- CARD DE SERVICIO TÉCNICO ---
class _AssistanceRecordCard extends StatelessWidget {
  final CompletedAssistanceItemModel item;

  const _AssistanceRecordCard({required this.item});

  @override
  Widget build(BuildContext context) {
    // Formato de fecha para el servicio
    final fmtDate = DateFormat(
      'dd MMM, HH:mm',
      'es',
    ).format(item.startTimestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.shade100,
        ), // Borde azulito para diferenciar
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade50.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Caso y Duración
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CASO #${item.caseNumber}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.blue.shade900,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 12,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.duration,
                      style: TextStyle(
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Cliente
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.clientName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          // Dirección
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.serviceAddress,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                ),
              ),
            ],
          ),

          const Divider(height: 16),

          // Footer: Fecha
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                fmtDate,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
