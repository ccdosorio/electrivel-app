import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


class RegisterScreen extends HookConsumerWidget {
  final bool isEntry;
  const RegisterScreen({super.key, required this.isEntry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validateLocation = ref.watch(validateAccessToLocation);
    
    return Scaffold(
      appBar: AppBar(),
      body: validateLocation.when(
          data: (_) => _Body(isEntry: isEntry),
          error: (e, _) => Text('Error $e'), 
          loading: () => Center(child: CircularProgressIndicator.adaptive())
      ),
    );
  }
}

class _Body extends HookConsumerWidget {
  final bool isEntry;
  const _Body({required this.isEntry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final addressController = useTextEditingController();
    final notesController= useTextEditingController();

    final theme = Theme.of(context);

    final titleText   = isEntry ? 'Ingreso' : 'Salida';
    final buttonText  = isEntry ? 'Marcar Ingreso' : 'Marcar Salida';
    final buttonColor = isEntry ? const Color(0xFF62B357) : const Color(0xFFF25B67);
    
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(
                titleText,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1D1B20),
                ),
              ),
              const SizedBox(height: 24),

              Center(
                  child: ClockText()
              ),
              const SizedBox(height: 8),

              Center(
                child: FormattedDateText(),
              ),

              const SizedBox(height: 28),

              _FormField(controller: addressController, label: 'Dirección'),

              const SizedBox(height: 16),

              _FormField(controller: notesController, label: 'Notas'),

              const SizedBox(height: 24),

              Center(
                child: CurrentLocationCard()
              ),

              Expanded(child: SizedBox()),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final validate = formKey.currentState?.validate() ?? false;
                    if (!validate) return;

                    final asyncPos = ref.read(locationStreamProvider);
                    final pos = asyncPos.value;

                    if (pos == null) {
                      SnackBarNotifications.showContextSnackBar(context: context,
                          title: 'Error',
                          content: 'Ubicación aún no disponible. \nIntenta de nuevo.',
                          theme: InfoThemeSnackBar.alert
                      );
                      return;
                    }

                    final registerModel = AttendanceRegister(
                      locationAddress: addressController.text,
                      notes: notesController.text,
                      latitude: pos.latitude,
                      longitude: pos.longitude
                    );

                    final response = await RegisterDatasource().register(isEntry, registerModel);
                    if (response.isError) {
                      SnackBarNotifications.showGeneralSnackBar(
                          title: 'Error',
                          content: response.error ?? '',
                          theme: InfoThemeSnackBar.alert
                      );
                      return;
                    }


                    SnackBarNotifications.showGeneralSnackBar(
                        title: 'Éxito',
                        content: 'Registro con éxito',
                        theme: InfoThemeSnackBar.ok
                    );

                    if (!context.mounted) return;
                    context.pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class _FormField extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController controller;
  final String? label;
  const _FormField({required this.controller, this.label, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecorations.decoration(
          labelText: label
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Requerido';
        return null;
      },
      onChanged: onChanged,
    );
  }
}
