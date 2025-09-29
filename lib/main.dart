// Flutter
import 'package:flutter/material.dart';

// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Internal dependencies
import 'package:electrivel_app/config/config.dart';

Future<void> main() async {
  await _loadEnvironmentVariables();
  runApp(const ProviderScope(child: MyApp()));
}

Future<void> _loadEnvironmentVariables() async {
  const envFile = String.fromEnvironment('ENV_FILE', defaultValue: '.env');
  await dotenv.load(fileName: envFile);
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
      title: 'Electrivel',
    );
  }
}
