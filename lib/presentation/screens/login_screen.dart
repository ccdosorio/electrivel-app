// Flutter
// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:flutter/material.dart';
// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [LoginHeaderWidget(), LoginFormWidget()],
                  ),
                ),
              ),
            ),
    );
  }
}
