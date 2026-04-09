import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/home/home_screen.dart';
import '../features/panic/panic_screen.dart';
import '../features/admin/admin_dashboard.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login', // or wherever you want
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/panic', builder: (context, state) => PanicScreen()),
    GoRoute(path: '/admin', builder: (context, state) => AdminDashboard()),
  ],
);
