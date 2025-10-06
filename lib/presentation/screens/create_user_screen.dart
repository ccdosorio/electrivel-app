// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';

class CreateUserScreen extends HookConsumerWidget {
  const CreateUserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(createUserProvider.notifier).loadInitialData();
      });
      return null;
    }, []);

    final isLoading = ref.watch(
      createUserProvider.select((state) => state.isLoading),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Crear Usuario'),
        backgroundColor: const Color(0xFFF7F8FA),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : const SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: CreateUserFormWidget(),
              ),
            ),
    );
  }
}
