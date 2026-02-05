// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:flutter_hooks/flutter_hooks.dart';

// Internal dependencies
import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/shared/shared.dart';
import 'package:electrivel_app/services/services.dart';

/// Política de contraseña igual al backend: al menos 6 caracteres,
/// una mayúscula, un dígito y un carácter especial.
String? validatePasswordPolicy(String? value) {
  if (value == null || value.isEmpty) return 'Requerido';
  if (value.length < 6) {
    return 'La contraseña debe tener al menos 6 caracteres';
  }
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'Debe contener al menos una letra mayúscula';
  }
  if (!RegExp(r'\d').hasMatch(value)) {
    return 'Debe contener al menos un número';
  }
  if (!RegExp(r'[\W_]').hasMatch(value)) {
    return 'Debe contener al menos un carácter especial';
  }
  return null;
}

/// Muestra el diálogo para reiniciar contraseña.
/// Si [userId] y [userDisplayName] se pasan, el usuario queda fijado (sin selector).
void showChangePasswordDialog(
  BuildContext context, {
  int? userId,
  String? userDisplayName,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: ChangePasswordDialogContent(
          initialUserId: userId,
          initialUserDisplayName: userDisplayName,
        ),
      ),
    ),
  );
}

class ChangePasswordDialogContent extends HookWidget {
  const ChangePasswordDialogContent({
    super.key,
    this.initialUserId,
    this.initialUserDisplayName,
  });

  final int? initialUserId;
  final String? initialUserDisplayName;

  bool get _isUserPreselected => initialUserId != null;

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final users = useState<List<UserModel>>([]);
    final isLoadingCatalog = useState(!_isUserPreselected);
    final selectedUserId = useState<int?>(initialUserId);
    final newPasswordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final isPasswordVisible = useState(false);
    final isSubmitting = useState(false);

    useEffect(() {
      if (_isUserPreselected) {
        isLoadingCatalog.value = false;
        return null;
      }
      Future<void> load() async {
        final result = await UsersDatasource().getUsersCatalog();
        if (result.users != null) {
          users.value = result.users!;
        }
        isLoadingCatalog.value = false;
      }
      load();
      return null;
    }, [_isUserPreselected]);

    Future<void> submit() async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      final userId = selectedUserId.value;
      if (userId == null) return;

      final newPassword = newPasswordController.text.trim();
      if (newPassword != confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
        return;
      }

      final passwordError = validatePasswordPolicy(newPassword);
      if (passwordError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(passwordError)),
        );
        return;
      }

      isSubmitting.value = true;
      final response = await UsersDatasource().changePassword(userId, newPassword);
      isSubmitting.value = false;

      if (!context.mounted) return;
      if (!response.isError) {
        SnackBarNotifications.showGeneralSnackBar(
          title: 'Éxito',
          content: 'Contraseña actualizada correctamente',
          theme: InfoThemeSnackBar.ok,
        );
        Navigator.of(context).pop();
        return;
      }
      SnackBarNotifications.showGeneralSnackBar(
        title: 'Error',
        content: response.error ?? 'No se pudo cambiar la contraseña',
        theme: InfoThemeSnackBar.alert,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Reiniciar contraseña',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (_isUserPreselected && initialUserDisplayName != null) ...[
              const SizedBox(height: 8),
              Text(
                initialUserDisplayName!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
              ),
            ],
            const SizedBox(height: 20),
            if (isLoadingCatalog.value)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator.adaptive(),
                ),
              )
            else ...[
              if (!_isUserPreselected) ...[
                DropdownButtonFormField<int>(
                  value: selectedUserId.value,
                  decoration: InputDecorations.decoration(
                    labelText: 'Usuario',
                    hintText: 'Selecciona un usuario',
                  ),
                  items: users.value
                      .map((u) => DropdownMenuItem<int>(
                            value: u.id,
                            child: Text('${u.fullName} (@${u.username})'),
                          ))
                      .toList(),
                  onChanged: isSubmitting.value
                      ? null
                      : (value) => selectedUserId.value = value,
                  validator: (value) {
                    if (value == null) return 'Selecciona un usuario';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: newPasswordController,
                obscureText: !isPasswordVisible.value,
                enabled: !isSubmitting.value,
                decoration: InputDecorations.decoration(
                  labelText: 'Nueva contraseña',
                  hintText: '••••••••',
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
                validator: validatePasswordPolicy,
              ),
              const SizedBox(height: 8),
              Text(
                'Mín. 6 caracteres, una mayúscula, un número y un carácter especial.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                enabled: !isSubmitting.value,
                decoration: InputDecorations.decoration(
                  labelText: 'Confirmar contraseña',
                  hintText: '••••••••',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requerido';
                  if (value != newPasswordController.text.trim()) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: isSubmitting.value
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: isSubmitting.value ? null : () => submit(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.secondaryColor,
                    ),
                    child: isSubmitting.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Cambiar contraseña'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
