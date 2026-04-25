import 'package:go_router/go_router.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/home/home_screen.dart';
import '../features/panic/panic_screen.dart';
import '../features/admin/admin_dashboard.dart';
import '../features/admin/admin_booking_screen.dart';
import '../features/admin/admin_complaints.dart';
import '../features/admin/create_slot_screen.dart';
import '../features/admin/booking_requests.dart';
import '../features/services/requirement_screen.dart';
import '../features/booking/slot_list_screen.dart';
import '../features/booking/my_bookings_screen.dart';
import '../features/feedback/complaint_screen.dart';
import '../features/feedback/my_complaint_screen.dart';
import '../features/directory/facilities_list.dart';

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

    if (token == null && !isPublicRoute) {
      return "/login";
    }

    if (token != null &&
        (state.uri.path == "/login" || state.uri.path == "/signup")) {
      return "/home";
    }

    if (state.uri.path.startsWith("/admin") && role != "admin") {
      return "/home";
    }

    return null;
  },

  routes: [
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/signup', builder: (_, __) => SignupScreen()),
    GoRoute(path: '/home', builder: (_, __) => HomeScreen()),

    GoRoute(
      path: '/requirements',
      builder: (_, __) => const RequirementScreen(),
    ),
    GoRoute(path: '/complaint', builder: (_, __) => ComplaintScreen()),
    GoRoute(path: '/slots', builder: (_, __) => SlotListScreen()),
    GoRoute(path: "/my-bookings", builder: (_, __) => MyBookingsScreen()),
    GoRoute(path: "/my-complaints", builder: (_, __) => MyComplaintsScreen()),

    // ✅ FIXED PARAMS
    GoRoute(
      path: '/facilities/:id',
      builder: (context, state) {
        final idStr = state.pathParameters['id'] ?? '0';
        final id = int.tryParse(idStr) ?? 0;

        final title = state.uri.queryParameters['title'] ?? 'Facilities';

        return FacilitiesListScreen(categoryId: id, title: title);
      },
    ),

    GoRoute(path: '/panic', builder: (_, __) => PanicScreen()),

    GoRoute(
      path: "/admin",
      builder: (_, __) => AdminDashboard(),
      routes: [
        GoRoute(path: "create-slot", builder: (_, __) => CreateSlotScreen()),
        GoRoute(path: "bookings", builder: (_, __) => AdminBookingScreen()),
        GoRoute(
          path: "booking-requests",
          builder: (_, __) => BookingRequestsPage(),
        ),
        GoRoute(path: "complaints", builder: (_, __) => AdminComplaints()),
      ],
    ),
  ],
);
