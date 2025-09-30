// Flutter
import 'package:electrivel_app/services/services.dart';
import 'package:flutter/material.dart';
// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';
import 'package:electrivel_app/shared/shared.dart';

class HomeServicesMenuWidget extends ConsumerWidget {
  final List<HomeMenuModel> menuOptions;
  const HomeServicesMenuWidget({super.key, required this.menuOptions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeGridMenuLayout<HomeMenuModel>(
      items: menuOptions,
      onTap: (service) {
        context.push(service.url);
      },
      itemBuilderChild: (service) => HomeMenuCard(
        title: service.name,
        icon: SharedConstants.iconNative[service.icon] ?? Icons.keyboard_command_key_rounded,
      ),
    );
  }
}
