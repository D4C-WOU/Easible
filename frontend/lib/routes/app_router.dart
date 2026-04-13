import 'package:flutter/material.dart';
import 'package:frontend/features/admin/admin_complaints.dart';
import 'package:frontend/features/feedback/complaint_screen.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/home/home_screen.dart';
import '../features/panic/panic_screen.dart';
import '../features/admin/admin_dashboard.dart';
import '../features/booking/slot_list_screen.dart';
import '../features/admin/create_slot_screen.dart';
import '../features/admin/admin_booking_screen.dart';
import '../features/services/service_screen.dart';
import '../features/booking/my_bookings_screen.dart';
import '../features/feedback/my_complaint_screen.dart';
import '../services/storage_service.dart';
import '../services/auth_service.dart';

final GoRouter router = GoRouter(
  redirect: (context, state) async {
    final token = await StorageService.getToken();
    final role = await AuthService.getRole();

    final isPublicRoute =
        state.uri.path == "/login" ||
        state.uri.path == "/signup" ||
        state.uri.path == "/panic";

    // ❌ Not logged in → allow only public routes
    if (token == null && !isPublicRoute) {
      return "/login";
    }

    // ❌ Logged in but trying auth pages
    if (token != null &&
        (state.uri.path == "/login" || state.uri.path == "/signup")) {
      return "/home";
    }

    // 🔐 Admin protection
    if (state.uri.path.startsWith("/admin") && role != "admin") {
      return "/home";
    }

    return null;
  },

  routes: [
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),

    GoRoute(path: '/signup', builder: (context, state) => SignupScreen()),

    GoRoute(path: '/home', builder: (_, __) => HomeScreen()),

    GoRoute(path: '/services', builder: (_, __) => ServiceScreen()),
    GoRoute(path: '/complaint', builder: (_, __) => ComplaintScreen()),
    GoRoute(path: '/slots', builder: (_, __) => SlotListScreen()),
    GoRoute(path: "/my-bookings", builder: (_, __) => MyBookingsScreen()),
    GoRoute(path: "/my-complaints", builder: (_, __) => MyComplaintsScreen()),

    // 🚨 Panic route (public access)
    GoRoute(path: '/panic', builder: (_, __) => PanicScreen()),

    GoRoute(
      path: "/admin",
      builder: (_, __) => AdminDashboard(),
      routes: [
        GoRoute(path: "create-slot", builder: (_, __) => CreateSlotScreen()),
        GoRoute(path: "bookings", builder: (_, __) => AdminBookingScreen()),
        GoRoute(path: "complaints", builder: (_, __) => AdminComplaints()),
      ],
    ),
  ],
);
