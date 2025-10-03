import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:electrivel_app/presentation/presentation.dart';


class FormattedDateText extends HookConsumerWidget {
  const FormattedDateText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDate = ref.watch(formattedDateProvider);
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: const Color(0xFF9AA3AF),
    );

    return asyncDate.when(
      data: (date) => Text(
        _capitalize(date),
        textAlign: TextAlign.center,
        style: style,
      ),
      loading: () => Text(
        '…',
        textAlign: TextAlign.center,
        style: style,
      ),
      error: (e, _) => Text(
        'Error',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: const Color(0xFF9AA3AF),
        ),
      ),
    );
  }

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}