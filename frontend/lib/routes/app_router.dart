import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/home/home_screen.dart';
import '../features/panic/panic_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(path: "/login", builder: (_, __) => LoginScreen()),
    GoRoute(path: "/signup", builder: (_, __) => SignupScreen()),
    GoRoute(path: "/home", builder: (_, __) => HomeScreen()),
    GoRoute(path: "/panic", builder: (_, __) => PanicScreen()),
  ],
);
