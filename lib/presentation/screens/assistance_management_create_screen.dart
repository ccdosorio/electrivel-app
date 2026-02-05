import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/presentation/providers/assistance_providers.dart';
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AssistanceManagementCreateScreen extends HookConsumerWidget {
  const AssistanceManagementCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final caseNumberController = useTextEditingController();
    final clientNameController = useTextEditingController();
    final clientPhoneController = useTextEditingController(text: '+502 ');
    final serviceAddressController = useTextEditingController();
    final descriptionController = useTextEditingController();

    final selectedCompany = useState(0);
    final selectedUser = useState(0);
    final isLoading = useState(false);

    final companies = useState<List<AssistanceCompanyModel>>([]);
    final users = useState<List<UserModel>>([]);

    final companiesFuture = useMemoized(
      () => AssistanceManagementDatasource().getAssistanceCompanies(),
    );

    final usersFuture = useMemoized(
      () => UsersDatasource().getUsers(limit: 100000),
    );

    final companiesSnap = useFuture(companiesFuture);
    final usersSnap = useFuture(usersFuture);

    useEffect(() {
      if (companiesSnap.hasData) {
        companies.value = companiesSnap.data ?? [];
      }
      return null;
    }, [companiesSnap.data]);

    useEffect(() {
      if (usersSnap.hasData) {
        final allUsers = usersSnap.data!.employeeList?.users ?? [];
        users.value = allUsers
            .where((u) =>
                u.role.toUpperCase().contains('EMPLEADO'))
            .toList();
      }
      return null;
    }, [usersSnap.data]);

    return Scaffold(
      appBar: AppBar(title: const Text('Crear asistencia')),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              CustomFormDropDown(
                options: companies.value,
                getValue: (v) => v.id,
                getLabel: (v) => Text(v.name),
                active: (v) => v.isActive,
                labelText: 'Aseguradora',
                onChanged: (value) {
                  selectedCompany.value = value ?? 0;
                },
                validator: (value) {
                  if (value == null) return 'Requerido';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              CustomFormDropDown(
                options: users.value,
                getValue: (v) => v.id,
                getLabel: (v) => Text(v.fullName),
                labelText: 'Empleado',
                onChanged: (value) {
                  selectedUser.value = value ?? 0;
                },
                validator: (value) {
                  if (value == null) return 'Requerido';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: caseNumberController,
                decoration: InputDecorations.decoration(labelText: 'No. de caso'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requerido';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: clientNameController,
                decoration: InputDecorations.decoration(labelText: 'Nombre de cliente'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]"),
                  ),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Requerido';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: clientPhoneController,
                decoration: InputDecorations.decoration(labelText: 'Teléfono de cliente'),
                keyboardType: TextInputType.phone,
                inputFormatters: [_GuatemalaPhoneFormatter()],
                validator: (value) {
                  if (value == null || value.trim().length < 8) {
                    return 'Número inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: serviceAddressController,
                decoration: InputDecorations.decoration(labelText: 'Dirección de servicio'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requerido';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: descriptionController,
                minLines: 4,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                decoration: InputDecorations.decoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Requerido';
                  return null;
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),

      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: isLoading.value ? null : () async {
              isLoading.value = true;
              final validate = formKey.currentState?.validate() ?? false;
              if (!validate) {
               isLoading.value = false;
               return;
              }

              final model = AssistanceCreateModel(
                  insuranceCompanyId: selectedCompany.value,
                  userId: selectedUser.value,
                  caseNumber: caseNumberController.text,
                  clientName: clientNameController.text,
                  clientPhone: clientPhoneController.text,
                  serviceAddress: serviceAddressController.text,
                  description: descriptionController.text
              );

              final response = await AssistanceManagementDatasource().create(model);

              if (response.isError) {
                isLoading.value = false;
                SnackBarNotifications.showGeneralSnackBar(
                  title: 'Error',
                  content: response.error!,
                  theme: InfoThemeSnackBar.alert,
                );
                return;
              }

              SnackBarNotifications.showGeneralSnackBar(
                title: 'Éxito',
                content: 'Asistencia creada correctamente',
                theme: InfoThemeSnackBar.ok,
              );

              if (!context.mounted) return;
              ref.invalidate(assistanceListProvider(false));
              context.pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.secondaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
            ),
            child: Text(
              isLoading.value ? 'Cargando...' : 'Crear',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class _GuatemalaPhoneFormatter extends TextInputFormatter {
  static const _prefix = '+502 ';
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (!newValue.text.startsWith(_prefix)) {
      return TextEditingValue(
        text: _prefix,
        selection: TextSelection.collapsed(offset: _prefix.length),
      );
    }

    final digits = newValue.text
        .substring(_prefix.length)
        .replaceAll(RegExp(r'[^0-9]'), '');
    final limitedDigits = digits.length > 8 ? digits.substring(0, 8) : digits;

    final formatted = '$_prefix$limitedDigits';
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
