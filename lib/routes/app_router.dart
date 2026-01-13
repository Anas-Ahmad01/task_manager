import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/task_form_screen.dart';
import '../models/task_model.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/task-form',
        pageBuilder: (context, state) {
          final taskToEdit = state.extra as TaskModel?;
          return MaterialPage(
            fullscreenDialog: true,
            child: TaskFormScreen(task: taskToEdit),
          );
        },
      ),
    ],
  );
}