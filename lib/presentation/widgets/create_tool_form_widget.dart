// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Internal dependencies
import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/shared/shared.dart';
import 'package:electrivel_app/presentation/presentation.dart';

class CreateToolFormWidget extends HookConsumerWidget {
  const CreateToolFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final idController = useTextEditingController();
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    final brandController = useTextEditingController();
    final modelController = useTextEditingController();
    final serialNumberController = useTextEditingController();

    final state = ref.watch(createToolProvider);
    // Rellenar campos cuando se cargan datos en modo edición
    useEffect(
      () {
        if (state.editingToolId != null &&
            state.id.isNotEmpty &&
            idController.text != state.id) {
          idController.text = state.id;
          nameController.text = state.name;
          descriptionController.text = state.description;
          brandController.text = state.brand;
          modelController.text = state.model;
          serialNumberController.text = state.serialNumber;
        }
        return null;
      },
      [
        state.editingToolId,
        state.id,
        state.name,
        state.description,
        state.brand,
        state.model,
        state.serialNumber,
      ],
    );

    final validateId = ref.watch(
      createToolProvider.select((state) => state.validateId),
    );
    final validateName = ref.watch(
      createToolProvider.select((state) => state.validateName),
    );
    final validateDescription = ref.watch(
      createToolProvider.select((state) => state.validateDescription),
    );
    final isLoading = ref.watch(
      createToolProvider.select((state) => state.isLoading),
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: !isLoading,
            controller: idController,
            decoration: InputDecorations.decoration(
              hintText: 'MARTILLO01',
              labelText: 'ID de herramienta *',
            ),
            onChanged: ref.read(createToolProvider.notifier).setId,
            validator: (_) => validateId,
            textCapitalization: TextCapitalization.characters,
          ),

          const SizedBox(height: 24),

          TextFormField(
            enabled: !isLoading,
            controller: nameController,
            decoration: InputDecorations.decoration(
              hintText: 'Martillo de Bola 16oz',
              labelText: 'Nombre *',
            ),
            onChanged: ref.read(createToolProvider.notifier).setName,
            validator: (_) => validateName,
          ),

          const SizedBox(height: 24),

          TextFormField(
            enabled: !isLoading,
            controller: descriptionController,
            decoration: InputDecorations.decoration(
              hintText: 'Descripción detallada de la herramienta',
              labelText: 'Descripción *',
            ),
            onChanged: ref.read(createToolProvider.notifier).setDescription,
            validator: (_) => validateDescription,
            maxLines: 3,
          ),

          const SizedBox(height: 24),

          TextFormField(
            enabled: !isLoading,
            controller: brandController,
            decoration: InputDecorations.decoration(
              hintText: 'Stanley',
              labelText: 'Marca',
            ),
            onChanged: ref.read(createToolProvider.notifier).setBrand,
          ),

          const SizedBox(height: 24),

          TextFormField(
            enabled: !isLoading,
            controller: modelController,
            decoration: InputDecorations.decoration(
              hintText: '51-165',
              labelText: 'Modelo',
            ),
            onChanged: ref.read(createToolProvider.notifier).setModel,
          ),

          const SizedBox(height: 24),

          TextFormField(
            enabled: !isLoading,
            controller: serialNumberController,
            decoration: InputDecorations.decoration(
              hintText: 'ST2024-567890',
              labelText: 'Número de serie',
            ),
            onChanged: ref.read(createToolProvider.notifier).setSerialNumber,
          ),

          const SizedBox(height: 24),

          const _CategoryDropdown(),

          const SizedBox(height: 24),

          const _ConditionDropdown(),

          const SizedBox(height: 24),

          const _CompanyDropdown(),

          const SizedBox(height: 32),

          _SubmitButton(formKey: formKey),
        ],
      ),
    );
  }
}

class _CategoryDropdown extends HookConsumerWidget {
  const _CategoryDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(
      createToolProvider.select((state) => state.selectedCategory),
    );
    final isLoading = ref.watch(
      createToolProvider.select((state) => state.isLoading),
    );

    return DropdownButtonFormField<String>(
      initialValue: selectedCategory,
      decoration: InputDecorations.decoration(
        labelText: 'Categoría *',
        hintText: 'Selecciona una categoría',
      ),
      items: ToolCategory.values.map((category) {
        return DropdownMenuItem<String>(
          value: category.value,
          child: Text(category.value),
        );
      }).toList(),
      onChanged: isLoading
          ? null
          : (value) {
              if (value != null) {
                ref.read(createToolProvider.notifier).selectCategory(value);
              }
            },
      validator: (value) {
        if (value == null) return 'Selecciona una categoría';
        return null;
      },
    );
  }
}

class _ConditionDropdown extends HookConsumerWidget {
  const _ConditionDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCondition = ref.watch(
      createToolProvider.select((state) => state.selectedCondition),
    );
    final isLoading = ref.watch(
      createToolProvider.select((state) => state.isLoading),
    );

    return DropdownButtonFormField<String>(
      initialValue: selectedCondition,
      decoration: InputDecorations.decoration(
        labelText: 'Condición *',
        hintText: 'Selecciona la condición',
      ),
      items: ToolCondition.values.map((condition) {
        return DropdownMenuItem<String>(
          value: condition.value,
          child: Text(condition.value),
        );
      }).toList(),
      onChanged: isLoading
          ? null
          : (value) {
              if (value != null) {
                ref.read(createToolProvider.notifier).selectCondition(value);
              }
            },
      validator: (value) {
        if (value == null) return 'Selecciona una condición';
        return null;
      },
    );
  }
}

class _CompanyDropdown extends HookConsumerWidget {
  const _CompanyDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = ref.watch(
      createToolProvider.select((state) => state.companies),
    );
    final selectedCompanyId = ref.watch(
      createToolProvider.select((state) => state.selectedCompanyId),
    );
    final isLoading = ref.watch(
      createToolProvider.select((state) => state.isLoading),
    );

    return DropdownButtonFormField<String>(
      initialValue: selectedCompanyId,
      decoration: InputDecorations.decoration(
        labelText: 'Empresa *',
        hintText: 'Selecciona una empresa',
      ),
      items: companies.map((company) {
        return DropdownMenuItem<String>(
          value: company.id,
          child: Text(company.name),
        );
      }).toList(),
      onChanged: isLoading
          ? null
          : (value) {
              if (value != null) {
                ref.read(createToolProvider.notifier).selectCompany(value);
              }
            },
      validator: (value) {
        if (value == null) return 'Selecciona una empresa';
        return null;
      },
    );
  }
}

class _SubmitButton extends HookConsumerWidget {
  final GlobalKey<FormState> formKey;
  const _SubmitButton({required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      createToolProvider.select((state) => state.isLoading),
    );
    final isEditMode = ref.watch(
      createToolProvider.select((state) => state.isEditMode),
    );
    final notifier = ref.read(createToolProvider.notifier);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: AppTheme.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadowColor: Colors.black26,
        ),
        onPressed: isLoading
            ? null
            : () async {
                final isValidate = formKey.currentState?.validate() ?? false;
                if (!isValidate) return;

                final response = isEditMode
                    ? await notifier.updateTool()
                    : await notifier.createTool();

                if (!response.isError) {
                  // 1. Refrescar los datos en el provider de la lista
                  ref
                      .read(toolsProvider.notifier)
                      .loadTools(forceRefresh: true);

                  // 2. Mostrar el SnackBar
                  SnackBarNotifications.showGeneralSnackBar(
                    title: 'Éxito',
                    content: isEditMode
                        ? 'Herramienta actualizada correctamente'
                        : 'Herramienta creada correctamente',
                    theme: InfoThemeSnackBar.ok,
                  );

                  // 3. NAVEGACIÓN AUTOMÁTICA
                  // Verificamos si el widget sigue montado para evitar errores
                  if (context.mounted) {
                    // .pop() cierra la pantalla actual y te regresa a la anterior (el listado)
                    context.pop();
                  }
                  return;
                }

                // Manejo de error...
                SnackBarNotifications.showGeneralSnackBar(
                  title: 'Error',
                  content: response.error ?? 'Error desconocido',
                  theme: InfoThemeSnackBar.alert,
                );
              },
        child: Text(
          isLoading
              ? (isEditMode ? 'Guardando...' : 'Creando...')
              : (isEditMode ? 'Guardar cambios' : 'Crear Herramienta'),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
