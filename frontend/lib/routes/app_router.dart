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

final GoRouter router = GoRouter(
  initialLocation: '/login', // or wherever you want
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(
      path: "/home",
      builder: (_, __) => HomeScreen(),
      routes: [
        GoRoute(
          path: "slots", // 👈 no slash
          builder: (_, __) => SlotListScreen(),
        ),
        GoRoute(path: '/complaint', builder: (_, __) => ComplaintScreen()),
        GoRoute(path: "/services", builder: (_, __) => ServiceScreen()),
      ],
    ),
    GoRoute(path: '/panic', builder: (context, state) => PanicScreen()),
    GoRoute(
      path: "/admin",
      builder: (_, __) => AdminDashboard(),
      routes: [
        GoRoute(path: "/create-slot", builder: (_, __) => CreateSlotScreen()),
        GoRoute(path: "/bookings", builder: (_, __) => AdminBookingScreen()),
        GoRoute(path: '/complaints', builder: (_, __) => AdminComplaints()),
      ],
    ),
  ],
);
