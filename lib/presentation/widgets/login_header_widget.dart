// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginHeaderWidget extends HookConsumerWidget {
  const LoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Image.asset('assets/splash.jpeg', width: 200, height: 200, fit: BoxFit.contain),
        ),

        const SizedBox(height: 24),
        Text('Iniciar Sesión',
            style: textTheme.headlineMedium?.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold
            )),
        const SizedBox(height: 8),
        Text('¡Hola! Bienvenido de nuevo.',
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
        const SizedBox(height: 24),
      ],
    );
  }
}
