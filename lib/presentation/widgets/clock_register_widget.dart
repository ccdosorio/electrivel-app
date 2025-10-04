
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ClockText extends HookConsumerWidget {
  const ClockText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTime = ref.watch(clockProvider);
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall?.copyWith(
      fontWeight: FontWeight.w700,
      color: const Color(0xFF3C4756),
    );

    return asyncTime.when(
      data: (now) {
        final h = now.hour.toString().padLeft(2, '0');
        final m = now.minute.toString().padLeft(2, '0');
        final s = now.second.toString().padLeft(2, '0');

        return Text('$h:$m:$s', style: style);
      },
      loading: () => Text("Cargando...", style: style),
      error: (e, _) => Text("Error: $e"),
    );
  }
}