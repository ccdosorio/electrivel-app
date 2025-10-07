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

    // Cargar herramientas cuando se monta la pantalla
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        toolsNotifier.loadTools();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Herramientas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/tools/management/create'),
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
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
                          itemCount: toolsState.tools.length +
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
                            return ToolCard(tool: tool);
                          },
                        ),
                      ),
      ),
    );
  }
}