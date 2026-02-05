// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';

class CreateToolScreen extends HookConsumerWidget {
  /// Si se pasa [toolId], la pantalla carga la herramienta y se muestra en modo edición.
  final String? toolId;

  const CreateToolScreen({super.key, this.toolId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(createToolProvider.notifier);
    final isEditMode = ref.watch(createToolProvider.select((state) => state.isEditMode));

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (toolId == null || toolId!.isEmpty) {
          notifier.clearEditMode();
        }
        await notifier.loadInitialData();
        if (toolId != null && toolId!.isNotEmpty) {
          await notifier.loadToolForEdit(toolId!);
        }
      });
      return null;
    }, [toolId]);

    final isLoading = ref.watch(createToolProvider.select((state) => state.isLoading));

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Editar Herramienta' : 'Crear Herramienta'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: CreateToolFormWidget(),
              ),
            ),
    );
  }
}