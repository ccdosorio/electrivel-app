// Flutter
import 'package:flutter/material.dart';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/presentation/presentation.dart';

class AttendanceEmployeeList extends StatelessWidget {
  final List<AttendanceEmployeeModel> employees;

  const AttendanceEmployeeList({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return const Center(child: Text('No hay empleados'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        final employee = employees[index];
        return AttendanceEmployeeCard(employee: employee);
      },
    );
  }
}