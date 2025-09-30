// Flutter
import 'package:flutter/material.dart';

// Exnternal dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

// Internal dependencies
import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/presentation/presentation.dart';

class HomeServicesScreen extends ConsumerWidget {
  const HomeServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuState = ref.watch(homeProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        context.go(AppRoutes.home);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(menuState.titleAppBar),
          leading: IconButton(onPressed: () => context.go(AppRoutes.home), icon: const Icon(Icons.arrow_back)),
        ),
        body: HomeServicesMenuWidget(menuOptions: menuState.services),
      ),
    );
  }
}
