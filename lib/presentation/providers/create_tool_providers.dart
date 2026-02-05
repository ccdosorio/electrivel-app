// External dependencies
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/legacy.dart';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

// Enum para categorías (valores coinciden con el tipo tool_category en BD/API)
enum ToolCategory {
  electricity('ELECTRICIDAD'),
  metalwork('HERRERÍA'),
  drywall('TABLAYESO'),
  painting('PINTURA'),
  carpentry('CARPINTERÍA'),
  cordless('INALÁMBRICOS'),
  electrical('ELÉCTRICOS'),
  plumbing('PLOMERÍA'),
  masonry('ALBAÑILERÍA'),
  ladders('ESCALERAS'),
  data('DATOS'),
  miscellaneous('VARIOS');

  final String value;
  const ToolCategory(this.value);
}

// Enum para condiciones
enum ToolCondition {
  good('BUENA'),
  regular('REGULAR'),
  poor('MALA');

  final String value;
  const ToolCondition(this.value);
}

class CreateToolState extends Equatable {
  final bool isLoading;
  final List<CompanyModel> companies;
  final String? selectedCompanyId;
  final String? selectedCategory;
  final String? selectedCondition;
  final String id;
  final String name;
  final String description;
  final String brand;
  final String model;
  final String serialNumber;
  /// Cuando no es null, estamos editando esta herramienta (originalId).
  final String? editingToolId;

  const CreateToolState({
    this.isLoading = false,
    this.companies = const [],
    this.selectedCompanyId,
    this.selectedCategory,
    this.selectedCondition,
    this.id = '',
    this.name = '',
    this.description = '',
    this.brand = '',
    this.model = '',
    this.serialNumber = '',
    this.editingToolId,
  });

  bool get isEditMode => editingToolId != null;

  @override
  List<Object?> get props => [
    isLoading,
    companies,
    selectedCompanyId,
    selectedCategory,
    selectedCondition,
    id,
    name,
    description,
    brand,
    model,
    serialNumber,
    editingToolId,
  ];

  String? get validateId {
    if (id.trim().isEmpty) return 'Requerido';
    if (id.trim().length < 4) return 'Mínimo 4 caracteres';
    if (id.trim().length > 10) return 'Máximo 10 caracteres';
    return null;
  }

  String? get validateName {
    if (name.trim().isEmpty) return 'Requerido';
    return null;
  }

  String? get validateDescription {
    if (description.trim().isEmpty) return 'Requerido';
    return null;
  }

  CreateToolState copyWith({
    bool? isLoading,
    List<CompanyModel>? companies,
    String? selectedCompanyId,
    String? selectedCategory,
    String? selectedCondition,
    String? id,
    String? name,
    String? description,
    String? brand,
    String? model,
    String? serialNumber,
    String? editingToolId,
  }) {
    return CreateToolState(
      isLoading: isLoading ?? this.isLoading,
      companies: companies ?? this.companies,
      selectedCompanyId: selectedCompanyId ?? this.selectedCompanyId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCondition: selectedCondition ?? this.selectedCondition,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      serialNumber: serialNumber ?? this.serialNumber,
      editingToolId: editingToolId ?? this.editingToolId,
    );
  }
}

class CreateToolNotifier extends StateNotifier<CreateToolState> {
  CreateToolNotifier() : super(const CreateToolState());

  final _toolsDatasource = ToolsDatasource();
  final _companiesDatasource = CompaniesDatasource();

  Future<void> loadInitialData() async {
    state = state.copyWith(isLoading: true);

    final companiesResult = await _companiesDatasource.getCompanies();

    state = state.copyWith(
      isLoading: false,
      companies: companiesResult.companies ?? [],
    );
  }

  void setId(String value) {
    state = state.copyWith(id: value);
  }

  void setName(String value) {
    state = state.copyWith(name: value);
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  void setBrand(String value) {
    state = state.copyWith(brand: value);
  }

  void setModel(String value) {
    state = state.copyWith(model: value);
  }

  void setSerialNumber(String value) {
    state = state.copyWith(serialNumber: value);
  }

  void selectCompany(String companyId) {
    state = state.copyWith(selectedCompanyId: companyId);
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void selectCondition(String condition) {
    state = state.copyWith(selectedCondition: condition);
  }

  bool validateForm() {
    return state.validateId == null &&
        state.validateName == null &&
        state.validateDescription == null &&
        state.selectedCompanyId != null &&
        state.selectedCategory != null &&
        state.selectedCondition != null;
  }

  void resetForm() {
    state = state.copyWith(
      id: '',
      name: '',
      description: '',
      brand: '',
      model: '',
      serialNumber: '',
      selectedCompanyId: null,
      selectedCategory: null,
      selectedCondition: null,
      editingToolId: null,
    );
  }

  /// Carga los datos de una herramienta para editar. Debe haberse llamado loadInitialData antes.
  Future<ResponseModel> loadToolForEdit(String toolId) async {
    state = state.copyWith(isLoading: true);
    final result = await _toolsDatasource.getToolById(toolId);
    state = state.copyWith(isLoading: false);

    if (result.response.isError || result.tool == null) {
      return ResponseModel(error: result.response.error ?? 'Herramienta no encontrada');
    }

    final tool = result.tool!;
    String? companyId;
    for (final c in state.companies) {
      if (c.name == tool.company) {
        companyId = c.id;
        break;
      }
    }

    state = state.copyWith(
      editingToolId: toolId,
      id: tool.id,
      name: tool.name,
      description: tool.description,
      brand: tool.brand ?? '',
      model: tool.model ?? '',
      serialNumber: tool.serialNumber ?? '',
      selectedCategory: tool.category,
      selectedCondition: tool.condition,
      selectedCompanyId: companyId,
    );
    return ResponseModel();
  }

  void clearEditMode() {
    state = state.copyWith(editingToolId: null);
  }

  Future<ResponseModel> createTool() async {
    if (!validateForm()) {
      return ResponseModel(error: 'Por favor completa todos los campos requeridos');
    }

    state = state.copyWith(isLoading: true);

    final tool = CreateToolModel(
      id: state.id.trim(),
      companyId: state.selectedCompanyId!,
      name: state.name.trim(),
      description: state.description.trim(),
      brand: state.brand.trim().isEmpty ? null : state.brand.trim(),
      model: state.model.trim().isEmpty ? null : state.model.trim(),
      serialNumber: state.serialNumber.trim().isEmpty ? null : state.serialNumber.trim(),
      category: state.selectedCategory!,
      condition: state.selectedCondition!,
    );

    final response = await _toolsDatasource.createTool(tool);

    state = state.copyWith(isLoading: false);

    if (!response.isError) {
      resetForm();
    }

    return response;
  }

  Future<ResponseModel> updateTool() async {
    final editingId = state.editingToolId;
    if (editingId == null) {
      return ResponseModel(error: 'No se está editando ninguna herramienta');
    }
    if (!validateForm()) {
      return ResponseModel(error: 'Por favor completa todos los campos requeridos');
    }

    state = state.copyWith(isLoading: true);

    final tool = CreateToolModel(
      id: state.id.trim(),
      companyId: state.selectedCompanyId!,
      name: state.name.trim(),
      description: state.description.trim(),
      brand: state.brand.trim().isEmpty ? null : state.brand.trim(),
      model: state.model.trim().isEmpty ? null : state.model.trim(),
      serialNumber: state.serialNumber.trim().isEmpty ? null : state.serialNumber.trim(),
      category: state.selectedCategory!,
      condition: state.selectedCondition!,
    );

    final response = await _toolsDatasource.updateTool(editingId, tool);
    state = state.copyWith(isLoading: false);

    if (!response.isError) {
      resetForm();
    }

    return response;
  }

  void reset() {
    state = const CreateToolState();
  }
}

final createToolProvider = StateNotifierProvider<CreateToolNotifier, CreateToolState>((ref) {
  return CreateToolNotifier();
});