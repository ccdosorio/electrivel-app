import 'package:electrivel_app/config/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:electrivel_app/services/services.dart';

class ToolAssignmentCard extends StatelessWidget {
  const ToolAssignmentCard({
    super.key,
    required this.assignment,
    this.onReturn,
  });

  final ToolAssignmentModel assignment;
  final VoidCallback? onReturn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totalTools = assignment.tools.fold<int>(0, (acc, t) => acc + (t.quantity));
    final checkout = assignment.checkOutTimestamp?.toLocal();
    final date = checkout == null
        ? '—'
        : DateFormat("d MMM - HH:mm", 'es').format(checkout);

    final (pillColor, pillText) = _statusChipData(assignment.status, theme);

    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: .35)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Kit #${assignment.id}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: pillColor.withValues(alpha: .15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pillText,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: pillColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            const SizedBox(height: 8),
            Divider(height: 16, color: theme.dividerColor.withValues(alpha: .6)),

            Row(
              children: [
                Expanded(
                  child: _InfoColumn(
                    label: 'Herramientas',
                    value: '$totalTools',
                    alignEnd: false,
                  ),
                ),
                Expanded(
                  child: _InfoColumn(
                    label: 'Retirado',
                    value: date,
                    alignEnd: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Center(
              child: ElevatedButton(
                onPressed: onReturn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('Devolver', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  (Color, String) _statusChipData(String status, ThemeData theme) {
    final lower = status.toLowerCase().trim();

    if (lower == 'in_use' || lower == 'en_uso' || lower == 'active') {
      return (Colors.green.shade700, 'En uso');
    }
    if (lower == 'returned' || lower == 'devuelto' || lower == 'closed') {
      return (theme.colorScheme.primary, 'Devuelto');
    }
    if (lower == 'pending' || lower == 'pendiente') {
      return (Colors.orange.shade700, 'Pendiente');
    }
    // default
    return (theme.colorScheme.secondary, status.isEmpty ? '—' : status);
  }
}

class _InfoColumn extends StatelessWidget {
  const _InfoColumn({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final align = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: .8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
