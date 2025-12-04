// Flutter
import 'package:electrivel_app/presentation/screens/employee_hours_detail_screen.dart';
import 'package:electrivel_app/presentation/screens/tools_assigned_create_screen.dart';
import 'package:electrivel_app/presentation/screens/tools_assigned_list_detail_screen.dart';
import 'package:flutter/material.dart';

// External dependencies
import 'package:go_router/go_router.dart';

// Internal dependencies
import 'package:electrivel_app/presentation/presentation.dart';

class AppRoutes {

  static final String login = '/login';
  static final String home = '/home';
  static final String moduleChildren = '/moduleChildren';

  // Assistance
  static final String assistance = '/assistance';
  static final String assistanceManagement = '/assistance/management';
  static final String assistanceManagementCreate = '/assistance/management-create';

  // Attendance
  static final String attendance = '/attendance';
  static final String attendanceCheckIn = '/attendance/check-in';
  static final String attendanceCheckOut = '/attendance/check-out';
  static final String attendanceManagement = '/attendance/management';
  static final String attendanceManagementDetail = '/attendance/management/detail';

  // Users
  static final String users = '/users';
  static final String usersCreate = '/users/create';

  // Tools
  static final String tools = '/tools';
  static final String toolsManagement = '/tools/management';
  static final String toolsManagementCreate = '/tools/management/create';
  static final String toolsAssignedCreate = '/tools/assigned/create';
  static final String toolsAssignedDetail = '/tools/assigned/detail';

  // Hours report
  static final String reportHours = '/report/hours';

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
      GoRoute(path: toolsManagementCreate, builder: (context, state) => CreateToolScreen()),
      GoRoute(path: tools, builder: (context, state) => ToolsAssignedList()),
      GoRoute(path: toolsAssignedDetail, builder: (context, state) => ToolsAssignedListDetail()),
      GoRoute(path: toolsAssignedCreate, builder: (context, state) => ToolsAssignedCreateScreen()),
      GoRoute(path: attendanceManagement, builder: (context, state) => AttendanceManagementScreen()),
      GoRoute(path: assistance, builder: (context, state) => AssistanceManagementScreen(isEmployee: true)),
      GoRoute(path: assistanceManagement, builder: (context, state) => AssistanceManagementScreen()),
      GoRoute(path: assistanceManagementCreate, builder: (context, state) => AssistanceManagementCreateScreen()),
      GoRoute(path: attendanceManagementDetail, builder: (context, state) => AssistanceManagementDetailScreen()),
      GoRoute(path: reportHours, builder: (context, state) => EmployeeHoursDetailScreen()),
    ],
  );

}