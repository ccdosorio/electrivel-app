// Flutter
import 'package:electrivel_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// External dependencies
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../config/router/app_routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _session();
  }

  Future<void> _session() async {
    await Future.delayed(Duration(seconds: 1));
    final res = await AuthDatasource().fetchTokenSession();

    if (!mounted) return;

    if (res.response.isError) {
      context.go(AppRoutes.login);
      return;
    }

    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/splash.jpeg', width: 200, height: 200, fit: BoxFit.contain)),
    );
  }
}

