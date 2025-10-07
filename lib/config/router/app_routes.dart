// Flutter
import 'package:flutter/cupertino.dart';

// External dependencies
import 'package:go_router/go_router.dart';

// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';

class AppRoutes {

  static final String attendance = '/attendance';
  static final String tools = '/tools';
  static final String assistance = '/assistance';
  static final String attendanceCheckIn = '/attendance/check-in';
  static final String attendanceCheckOut = '/attendance/check-out';
  static final String toolsAssigned = '/tools-assigned';
  static final String toolsRegister = '/tools-register';
  static final String assistanceAssigned = '/assistance-assigned';

  static final String login = '/login';
  static final String home = '/home';
  static final String moduleChildren = '/moduleChildren';

  static final String users = '/users';
  static final String usersCreate = '/users/create';

  static final String toolsManagement = '/tools/management';
  static final String toolsManagementCreate = '/tools/management/create';

  static final navigatorKey = GlobalKey<NavigatorState>();
  static final routes = GoRouter(
    initialLocation: login,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(path: login, builder: (context, state) => LoginScreen()),
      GoRoute(path: home, builder: (context, state) => HomeModulesScreen()),
      GoRoute(path: moduleChildren, builder: (context, state) => HomeServicesScreen()),
      GoRoute(path: attendanceCheckIn, builder: (context, state) => RegisterScreen(isEntry: true)),
      GoRoute(path: attendanceCheckOut, builder: (context, state) => RegisterScreen(isEntry: false)),
      GoRoute(path: users, builder: (context, state) => UsersListScreen()),
      GoRoute(path: usersCreate, builder: (context, state) => CreateUserScreen()),
      GoRoute(path: toolsManagement, builder: (context, state) => ToolsListScreen()),
      //GoRoute(path: toolsManagementCreate, builder: (context, state) => CreateToolScreen()),
    ],
  );

}