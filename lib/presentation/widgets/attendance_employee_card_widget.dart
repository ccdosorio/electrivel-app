// Flutter
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';

class AttendanceEmployeeCard extends StatelessWidget {
  final AttendanceEmployeeModel employee;

  const AttendanceEmployeeCard({super.key, required this.employee});

  Color _getStatusColor() {
    switch (employee.status) {
      case 'CHECKED_IN':
        return Colors.green;
      case 'CHECKED_OUT':
        return Colors.orange;
      case 'NOT_CHECKED_IN':
      default:
        return Colors.grey;
    }
  }

  String _getStatusText() {
    switch (employee.status) {
      case 'CHECKED_IN':
        return 'Ingresado';
      case 'CHECKED_OUT':
        return 'Salida';
      case 'NOT_CHECKED_IN':
      default:
        return 'Sin marcar';
    }
  }

  String? _formatTime(String? time) {
    if (time == null) return null;
    try {
      // Parsear la fecha con zona horaria y convertir a hora local
      final parsedTime = DateTime.parse(time).toLocal();
      return DateFormat('HH:mm').format(parsedTime);
    } catch (e) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employee.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${employee.username}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getStatusColor().withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.business_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                employee.company.name,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          if (employee.checkInTime != null ||
              employee.checkOutTime != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                if (employee.checkInTime != null)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.login, size: 16, color: Colors.green[700]),
                        const SizedBox(width: 6),
                        Text(
                          'Entrada: ${_formatTime(employee.checkInTime)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (employee.checkOutTime != null)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.logout, size: 16, color: Colors.orange[700]),
                        const SizedBox(width: 6),
                        Text(
                          'Salida: ${_formatTime(employee.checkOutTime)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
          if (employee.workDuration != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  'Duración: ${employee.workDuration}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
