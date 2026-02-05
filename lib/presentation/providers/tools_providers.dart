// External dependencies
import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/legacy.dart';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';

class ToolsState extends Equatable {
  final List<ToolModel> tools;
  final bool isLoading;
  final int currentPage;
  final int totalPages;
  final int total;
  final String? error;
  final List<CompanyModel> companies;
  final String? selectedCompanyId;

  const ToolsState({
    this.tools = const [],
    this.isLoading = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
    this.error,
    this.companies = const [],
    this.selectedCompanyId,
  });

  @override
  List<Object?> get props => [
    tools,
    isLoading,
    currentPage,
    totalPages,
    total,
    error,
    companies,
    selectedCompanyId,
  ];

  ToolsState copyWith({
    List<ToolModel>? tools,
    bool? isLoading,
    int? currentPage,
    int? totalPages,
    int? total,
    String? error,
    List<CompanyModel>? companies,
    String? selectedCompanyId,
    bool clearCompanyId = false,
  }) {
    return ToolsState(
      tools: tools ?? this.tools,
      isLoading: isLoading ?? this.isLoading,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      error: error,
      companies: companies ?? this.companies,
      selectedCompanyId: clearCompanyId
          ? null
          : (selectedCompanyId ?? this.selectedCompanyId),
    );
  }
}

class ToolsNotifier extends StateNotifier<ToolsState> {
  ToolsNotifier() : super(const ToolsState());

  final _datasource = ToolsDatasource();
  final _companiesDatasource = CompaniesDatasource();

  Future<void> loadCompanies() async {
    final (:response, :companies) = await _companiesDatasource.getCompanies();

    if (!response.isError) {
      state = state.copyWith(companies: companies ?? []);
    }
  }

  void selectCompany(String? companyId) {
    if (companyId == null) {
      state = state.copyWith(clearCompanyId: true);
    } else {
      state = state.copyWith(selectedCompanyId: companyId);
    }
    loadTools(); // Recargar con el nuevo filtro
  }

  Future<void> loadTools({bool loadMore = false, bool forceRefresh = false}) async {
    if (!forceRefresh && state.isLoading) return;

    state = state.copyWith(isLoading: true);

    final page = loadMore ? state.currentPage + 1 : 1;
    final (:response, :toolList) = await _datasource.getTools(
      page: page,
      companyId: state.selectedCompanyId,
    );

    if (response.isError) {
      state = state.copyWith(isLoading: false, error: response.error);
      return;
    }

    final data = toolList!;
    final tools = loadMore ? [...state.tools, ...data.tools] : data.tools;

    state = state.copyWith(
      isLoading: false,
      tools: tools,
      currentPage: data.currentPage,
      totalPages: data.totalPages,
      total: data.total,
      error: null,
    );
  }

  void reset() {
    state = const ToolsState();
  }
}

final toolsProvider = StateNotifierProvider<ToolsNotifier, ToolsState>((ref) {
  return ToolsNotifier();
});
