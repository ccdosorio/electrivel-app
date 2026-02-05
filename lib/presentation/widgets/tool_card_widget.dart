// Flutter
import 'package:flutter/material.dart';

// Internal dependencies
import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/services/services.dart';

class ToolCard extends StatelessWidget {
  final ToolModel tool;
  final VoidCallback? onEdit;

  const ToolCard({super.key, required this.tool, this.onEdit});

  Color _getStatusColor() {
    if (!tool.isAvailable) return Colors.red.shade50;
    return tool.condition == 'BUENA' ? Colors.green.shade50 : Colors.orange.shade50;
  }

  Color _getStatusTextColor() {
    if (!tool.isAvailable) return Colors.red.shade700;
    return tool.condition == 'BUENA' ? Colors.green.shade700 : Colors.orange.shade700;
  }

  String _getStatusText() {
    if (!tool.isAvailable) return 'No disponible';
    return tool.condition;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
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
                      tool.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tool.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (onEdit != null)
                IconButton(
                  onPressed: onEdit,
                  icon: Icon(
                    Icons.edit_outlined,
                    size: 22,
                    color: AppTheme.secondaryColor,
                  ),
                  tooltip: 'Modificar herramienta',
                ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusTextColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.qr_code_2, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                tool.id,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.category_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                tool.category,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (tool.brand != null) ...[
                const SizedBox(width: 16),
                Icon(Icons.branding_watermark_outlined, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  tool.brand!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.business_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 6),
              Text(
                tool.company,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}