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

class CreateUserFormWidget extends HookConsumerWidget {
  const CreateUserFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final usernameController = useTextEditingController();
    final fullNameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPasswordVisible = useState(false);

    final validateUsername = ref.watch(
      createUserProvider.select((state) => state.validateUsername),
    );
    final validateFullName = ref.watch(
      createUserProvider.select((state) => state.validateFullName),
    );
    final validatePassword = ref.watch(
      createUserProvider.select((state) => state.validatePassword),
    );
    final isLoading = ref.watch(
      createUserProvider.select((state) => state.isLoading),
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: !isLoading,
            controller: usernameController,
            decoration: InputDecorations.decoration(
              hintText: 'usuario123',
              labelText: 'Nombre de usuario',
            ),
            onChanged: ref.read(createUserProvider.notifier).username,
            validator: (_) => validateUsername,
          ),

          const SizedBox(height: 24),

          TextFormField(
            enabled: !isLoading,
            controller: fullNameController,
            decoration: InputDecorations.decoration(
              hintText: 'Juan Pérez',
              labelText: 'Nombre completo',
            ),
            onChanged: ref.read(createUserProvider.notifier).fullName,
            validator: (_) => validateFullName,
          ),

          const SizedBox(height: 24),

          TextFormField(
            enabled: !isLoading,
            controller: passwordController,
            obscureText: !isPasswordVisible.value,
            decoration: InputDecorations.decoration(
              hintText: '••••••••••',
              labelText: 'Contraseña',
              suffixIcon: IconButton(
                onPressed: () =>
                    isPasswordVisible.value = !isPasswordVisible.value,
                icon: Icon(
                  isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
            ),
            onChanged: ref.read(createUserProvider.notifier).password,
            validator: (_) => validatePassword,
          ),

          const SizedBox(height: 24),

          const _RoleDropdown(),

          const SizedBox(height: 24),

          const _CompanyDropdown(),

          const SizedBox(height: 32),

          _SubmitButton(formKey: formKey),
        ],
      ),
    );
  }
}

class _RoleDropdown extends HookConsumerWidget {
  const _RoleDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = ref.watch(createUserProvider.select((state) => state.roles));
    final selectedRoleId = ref.watch(
      createUserProvider.select((state) => state.selectedRoleId),
    );
    final isLoading = ref.watch(
      createUserProvider.select((state) => state.isLoading),
    );

    return DropdownButtonFormField<String>(
      initialValue: selectedRoleId,
      decoration: InputDecorations.decoration(
        labelText: 'Rol',
        hintText: 'Selecciona un rol',
      ),
      items: roles.map((role) {
        return DropdownMenuItem<String>(
          value: role.id,
          child: Text(role.description),
        );
      }).toList(),
      onChanged: isLoading
          ? null
          : (value) {
              if (value != null) {
                ref.read(createUserProvider.notifier).selectRole(value);
              }
            },
      validator: (value) {
        if (value == null) return 'Selecciona un rol';
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
      createUserProvider.select((state) => state.companies),
    );
    final selectedCompanyId = ref.watch(
      createUserProvider.select((state) => state.selectedCompanyId),
    );
    final isLoading = ref.watch(
      createUserProvider.select((state) => state.isLoading),
    );

    return DropdownButtonFormField<String>(
      initialValue: selectedCompanyId,
      decoration: InputDecorations.decoration(
        labelText: 'Empresa',
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
                ref.read(createUserProvider.notifier).selectCompany(value);
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
      createUserProvider.select((state) => state.isLoading),
    );

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

                final response = await ref
                    .read(createUserProvider.notifier)
                    .createUser();

                if (!response.isError) {
                  SnackBarNotifications.showGeneralSnackBar(
                    title: 'Éxito',
                    content: 'Usuario creado correctamente',
                    theme: InfoThemeSnackBar.ok,
                  );

                  if (context.mounted) {
                    ref.read(usersProvider.notifier);
                    context.pop(
                      true,
                    ); // Retornar true para indicar que se creó un usuario
                  }
                  return;
                }

                SnackBarNotifications.showGeneralSnackBar(
                  title: 'Error',
                  content: response.error!,
                  theme: InfoThemeSnackBar.alert,
                );
              },
        child: Text(
          isLoading ? 'Creando...' : 'Crear Usuario',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
