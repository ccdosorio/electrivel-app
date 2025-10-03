import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:electrivel_app/presentation/presentation.dart';


class CurrentLocationCard extends HookConsumerWidget {
  const CurrentLocationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final asyncPos = ref.watch(locationStreamProvider);

    Widget content = asyncPos.when(
      loading: () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 8),
          Text('Obteniendo ubicación…',
              style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280))),
        ],
      ),
      error: (e, _) => Text(
        'Ubicación no disponible',
        style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280)),
        textAlign: TextAlign.center,
      ),
      data: (pos) {
        final lat = pos.latitude.toStringAsFixed(6);
        final lng = pos.longitude.toStringAsFixed(6);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ubicación Actual',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1D1B20),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '$lat, $lng',
              style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF6B7280)),
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );

    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: content,
      ),
    );
  }
}