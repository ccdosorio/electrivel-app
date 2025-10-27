// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';

class AttendanceManagementScreen extends HookConsumerWidget {
  const AttendanceManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceState = ref.watch(attendanceProvider);
    final attendanceNotifier = ref.read(attendanceProvider.notifier);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        attendanceNotifier.loadAttendance();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingreso/Salida Empleados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(attendanceState.selectedDate),
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (selectedDate != null) {
                attendanceNotifier.selectDate(selectedDate);
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => attendanceNotifier.loadAttendance(),
        child: attendanceState.isLoading && attendanceState.attendanceSummary == null
            ? const Center(child: CircularProgressIndicator.adaptive())
            : attendanceState.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${attendanceState.error}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => attendanceNotifier.loadAttendance(),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  )
                : attendanceState.attendanceSummary == null
                    ? const Center(child: Text('No hay datos'))
                    : Column(
                        children: [
                          AttendanceDateHeader(
                            date: attendanceState.selectedDate,
                          ),
                          AttendanceSummaryCards(
                            summary: attendanceState.attendanceSummary!.summary,
                            totalEmployees: attendanceState.attendanceSummary!.totalEmployees,
                          ),
                          Expanded(
                            child: AttendanceEmployeeList(
                              employees: attendanceState.attendanceSummary!.employees,
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }
}