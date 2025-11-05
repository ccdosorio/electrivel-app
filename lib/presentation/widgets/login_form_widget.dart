// Flutter
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

// External dependencies
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Internal dependencies
import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/shared/shared.dart';
import 'package:electrivel_app/presentation/presentation.dart';

import '../../geolocation_task_handler.dart';


Future<void> _ensureLocationPermissions() async {
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    await Geolocator.requestPermission();
  }
}

Future<void> _ensureNotificationsPermissions() async {
  final notificationPermission = await FlutterForegroundTask.checkNotificationPermission();
  if (notificationPermission != NotificationPermission.granted) {
    await FlutterForegroundTask.requestNotificationPermission();
  }
}

Future<void> _requestBatteryPermissions() async {
  if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
    await FlutterForegroundTask.requestIgnoreBatteryOptimization();
  }
}

Future<void> startTracking() async {
  await _ensureLocationPermissions();
  await _ensureNotificationsPermissions();
  await _requestBatteryPermissions();

  await FlutterForegroundTask.startService(
    serviceTypes: const [ForegroundServiceTypes.location],
    notificationTitle: 'Configurando ubicación geografica',
    notificationText: '',
    callback: startCallback,
  );
}

class LoginFormWidget extends HookConsumerWidget {
  const LoginFormWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      loginFormProvider.select((state) => state.isLoading),
    );


    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passController = useTextEditingController();

    final isObscure = ref.watch(
      loginFormProvider.select((state) => state.isObscure),
    );

    final emailValidator = ref.watch(
      loginFormProvider.select((state) => state.validateEmail)
    );

    final passwordValidator = ref.watch(
      loginFormProvider.select((state) => state.validatePassword)
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            enabled: !isLoading,
            controller: emailController,
            decoration: InputDecorations.decoration(
              hintText: 'admin',
              labelText: 'Nombre de usuario',
            ),
            onChanged: ref.read(loginFormProvider.notifier).email,
            validator: (_) => emailValidator,
          ),

          const SizedBox(height: 24),
          TextFormField(
            enabled: !isLoading,
            controller: passController,
            obscureText: isObscure,
            decoration: InputDecorations.decoration(
              hintText: '••••••••••',
              labelText: 'Contaseña',
              suffixIcon: IconButton(
                onPressed: ref.read(loginFormProvider.notifier).obscureText,
                icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            onChanged: ref.read(loginFormProvider.notifier).password,
            validator: (_) => passwordValidator,
          ),

          const SizedBox(height: 28),

          _SubmitButton(formKey: formKey),

          const SizedBox(height: 16),

          _ResetPassword(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SubmitButton extends HookConsumerWidget {
  final GlobalKey<FormState> formKey;
  const _SubmitButton({required this.formKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(
      loginFormProvider.select((state) => state.isLoading),
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
        onPressed: isLoading ? null : () async {
          final isValidate = formKey.currentState?.validate() ?? false;
          if (!isValidate) return;

          final (response, authModel) = await ref.read(loginFormProvider.notifier).login();
          if (!response.isError && context.mounted) {
            context.go(AppRoutes.home);
            if (authModel.user.role == 'BOSS') return;

            await startTracking();
            return;
          }

          SnackBarNotifications.showGeneralSnackBar(
              title: 'Error',
              content: response.error!,
              theme: InfoThemeSnackBar.alert
          );
        },
        child: Text(
          isLoading ? 'Cargando...' : 'Iniciar Sesión',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ResetPassword extends HookConsumerWidget {
  const _ResetPassword();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.grey.shade500),
        onPressed: () {},
        child: const Text('¿Olvidaste tu contraseña?'),
      ),
    );
  }
}
