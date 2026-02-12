import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/add_edit_screen.dart';
import 'screens/detail_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddEditScreen(),
    ),
    GoRoute(
      path: '/edit/:id',
      builder: (context, state) => const AddEditScreen(),
    ),
    GoRoute(
      path: '/detail/:id',
      builder: (context, state) => const DetailScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Page not found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            state.error?.toString() ?? 'Unknown error',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    ),
  ),
);
