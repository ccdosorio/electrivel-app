// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/config/config.dart';

class ToolsListScreen extends HookConsumerWidget {
  const ToolsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final toolsState = ref.watch(toolsProvider);
    final toolsNotifier = ref.read(toolsProvider.notifier);

    // Cargar herramientas y empresas cuando se monta la pantalla
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        toolsNotifier.loadCompanies();
        toolsNotifier.loadTools();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Herramientas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet(context, ref);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tools/management/create'),
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Chip de filtro activo
          if (toolsState.selectedCompanyId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Chip(
                    label: Text(
                      toolsState.companies
                          .firstWhere(
                            (c) => c.id == toolsState.selectedCompanyId,
                          )
                          .name,
                    ),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () {
                      toolsNotifier.selectCompany(null);
                    },
                    backgroundColor: AppTheme.secondaryColor.withValues(
                      alpha: 0.1,
                    ),
                    labelStyle: TextStyle(
                      color: AppTheme.secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => toolsNotifier.loadTools(),
              child: toolsState.tools.isEmpty && toolsState.isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : toolsState.error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${toolsState.error}'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => toolsNotifier.loadTools(),
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    )
                  : toolsState.tools.isEmpty
                  ? const Center(child: Text('No hay herramientas'))
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent * 0.9) {
                          if (!toolsState.isLoading &&
                              toolsState.currentPage < toolsState.totalPages) {
                            toolsNotifier.loadTools(loadMore: true);
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            toolsState.tools.length +
                            (toolsState.currentPage < toolsState.totalPages
                                ? 1
                                : 0),
                        itemBuilder: (context, index) {
                          if (index == toolsState.tools.length) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            );
                          }

                          final tool = toolsState.tools[index];
                          return ToolCard(
                            tool: tool,
                            onEdit: () => context.push(
                              '/tools/management/create',
                              extra: tool.id,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterBottomSheet(),
    );
  }
}

class _FilterBottomSheet extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final companies = ref.watch(
      toolsProvider.select((state) => state.companies),
    );
    final selectedCompanyId = ref.watch(
      toolsProvider.select((state) => state.selectedCompanyId),
    );

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtrar por empresa',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (selectedCompanyId != null)
                TextButton(
                  onPressed: () {
                    ref.read(toolsProvider.notifier).selectCompany(null);
                    Navigator.pop(context);
                  },
                  child: const Text('Limpiar'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          ...companies.map((company) {
            final isSelected = selectedCompanyId == company.id;
            return ListTile(
              leading: Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                color: isSelected ? AppTheme.secondaryColor : Colors.grey,
              ),
              title: Text(company.name),
              selected: isSelected,
              onTap: () {
                ref.read(toolsProvider.notifier).selectCompany(company.id);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
