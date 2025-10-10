import 'package:electrivel_app/services/services.dart';
import 'package:flutter/material.dart';

class ToolItemCard extends StatelessWidget {
  const ToolItemCard({
    super.key,
    required this.tool,
  });

  final Tool tool;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final brand = (tool.toolBrand.isEmpty) ? 'No especificado' : tool.toolBrand;
    final model = (tool.toolModel.isEmpty) ? '' : ' / ${tool.toolModel}';
    final condText = _conditionText(tool.conditionCheckOut);
    final condColor = _conditionColor(tool.conditionCheckOut, theme);
    final category = tool.category.isEmpty ? null : tool.category.toUpperCase();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.dividerColor.withValues(alpha: .35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  tool.toolName.isEmpty ? 'Herramienta' : tool.toolName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (category != null)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: .08),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    category,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .3,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'ID: ${tool.toolId.isEmpty ? '—' : tool.toolId}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: .9),
            ),
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _LabeledValue(
                  label: 'Cantidad',
                  value: '${tool.quantity}',
                ),
              ),
              Expanded(
                child: _LabeledValue(
                  label: 'Condición',
                  value: condText,
                  valueStyle: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: condColor,
                    letterSpacing: .4,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          _LabeledValue(
            label: 'Marca / Modelo',
            value: '$brand$model',
          ),

          const SizedBox(height: 14),
          if (tool.checkOutNotes.isNotEmpty)
            _NoteBubble(
              title: 'Notas de retiro:',
              text: tool.checkOutNotes,
            ),
        ],
      ),
    );
  }

  String _conditionText(String raw) {
    final v = raw.trim().toLowerCase();
    if (v.isEmpty) return '—';
    if (v.contains('excelente') || v.contains('good')) return 'EXCELENTE';
    if (v.contains('regular') || v.contains('fair')) return 'REGULAR';
    if (v.contains('malo') || v.contains('bad') || v.contains('dañado')) {
      return 'DAÑADO';
    }
    return raw.toUpperCase();
  }

  Color _conditionColor(String raw, ThemeData theme) {
    final v = raw.trim().toLowerCase();
    if (v.contains('excelente') || v.contains('good')) return Colors.green.shade700;
    if (v.contains('regular') || v.contains('fair')) return Colors.amber.shade800;
    if (v.contains('malo') || v.contains('bad') || v.contains('dañado')) {
      return Colors.red.shade700;
    }
    return theme.colorScheme.primary;
  }
}

class _LabeledValue extends StatelessWidget {
  const _LabeledValue({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withValues(alpha: .85),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: valueStyle ??
              theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _NoteBubble extends StatelessWidget {
  const _NoteBubble({required this.title, required this.text});

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withValues(alpha: .9),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
