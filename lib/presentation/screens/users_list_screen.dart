// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/config/config.dart';

class UsersListScreen extends HookConsumerWidget {
  const UsersListScreen({super.key});

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    int userId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar este usuario?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Cerrar diálogo

              // Llamar al provider
              final success = await ref
                  .read(usersProvider.notifier)
                  .deleteUser(userId);

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Usuario eliminado correctamente'),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al eliminar usuario'),
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersProvider);
    final usersNotifier = ref.read(usersProvider.notifier);

    // Cargar usuarios cuando se monta la pantalla
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        usersNotifier.loadUsers();
      });
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/users/create'),
        backgroundColor: AppTheme.secondaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () => usersNotifier.loadUsers(),
        child: usersState.users.isEmpty && usersState.isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : usersState.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${usersState.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => usersNotifier.loadUsers(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
            : usersState.users.isEmpty
            ? const EmptyListWidget()
            : NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent * 0.9) {
                    if (!usersState.isLoading &&
                        usersState.currentPage < usersState.totalPages) {
                      usersNotifier.loadUsers(loadMore: true);
                    }
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      usersState.users.length +
                      (usersState.currentPage < usersState.totalPages ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == usersState.users.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      );
                    }

                    final employee = usersState.users[index];
                    return UserCard(
                      employee: employee,
                      onDelete: () => _showDeleteConfirmation(
                        context,
                        ref,
                        employee
                            .id, // Asumiendo que UserModel tiene un campo 'id'
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
