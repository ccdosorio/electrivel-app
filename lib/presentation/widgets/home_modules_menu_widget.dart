// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

// Internal dependencies
import 'package:electrivel_app/config/config.dart';
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';

class HomeModulesMenuWidget extends ConsumerWidget {
  const HomeModulesMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(homeProvider.select((state) => state.menu));

    return HomeGridMenuLayout<HomeMenuModel>(
      items: menu,
      onTap: (item) {
        // Si tiene hijos, navegar a la pantalla de submódulos
        if (item.children.isNotEmpty) {
          final notifier = ref.read(homeProvider.notifier);
          notifier.loadModuleMenu(item.children, item.name);
          context.push(AppRoutes.moduleChildren);
        } else {
          // Si no tiene hijos, navegar directamente a la URL del item
          context.push(item.url);
        }
      },
      itemBuilderChild: (item) => HomeMenuCard(
        title: item.name,
        icon: SharedConstants.iconNative[item.icon] ?? Icons.keyboard_command_key_rounded,
      ),
    );
  }
}