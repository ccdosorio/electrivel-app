// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/shared/shared.dart';

class HomeModulesScreen extends ConsumerWidget {
  const HomeModulesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return FutureBuilder(
        future: ref.read(homeProvider.notifier).loadMenu(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) return LoadingFeedbackWidget();

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () async {
                  final authProvider = ref.read(loginFormProvider.notifier);
                  await authProvider.logout();

                  if (!context.mounted) return;
                  context.go(AppRoutes.login);
                },
                icon: const Icon(Icons.login_outlined),
              ),
            ),
            body: RefreshIndicator(
              onRefresh: ref.read(homeProvider.notifier).loadMenu,
              child: const HomeModulesMenuWidget(),
            ),
          );
        });
  }
}
