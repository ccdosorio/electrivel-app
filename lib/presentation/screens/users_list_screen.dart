// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';

class UsersListScreen extends HookConsumerWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersProvider);
    final usersNotifier = ref.read(usersProvider.notifier);

    // Cargar usuarios cuando se monta la pantalla
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        usersNotifier.loadEmployees();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/users/create'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => usersNotifier.loadEmployees(),
        child: usersState.employees.isEmpty && usersState.isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : usersState.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${usersState.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => usersNotifier.loadEmployees(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
            : usersState.employees.isEmpty
            ? const Center(child: Text('No hay usuarios'))
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent * 0.9) {
                    if (!usersState.isLoading &&
                        usersState.currentPage < usersState.totalPages) {
                      usersNotifier.loadEmployees(loadMore: true);
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      usersState.employees.length +
                      (usersState.currentPage < usersState.totalPages ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == usersState.employees.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    final employee = usersState.employees[index];
                    return UserCard(employee: employee);
                  },
                ),
              ),
      ),
    );
  }
}
