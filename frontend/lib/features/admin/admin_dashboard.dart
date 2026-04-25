import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/storage_service.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/app_scaffold.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Admin",

      // ✅ LOGOUT BUTTON
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await StorageService.clearToken();
            context.go("/login");
          },
        ),
      ],

      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // ✅ HEADER CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.admin_panel_settings, size: 60),
                    const SizedBox(height: 10),
                    Text(
                      "Admin Command Center",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            // ✅ ACTION BUTTONS
            PrimaryButton(
              text: "Create Slots",
              icon: Icons.add_box,
              onPressed: () => context.go("/admin/create-slot"),
            ),

            const SizedBox(height: 12),

            PrimaryButton(
              text: "Manage Bookings",
              icon: Icons.book_online,
              onPressed: () => context.go("/admin/bookings"),
            ),

            const SizedBox(height: 12),

            PrimaryButton(
              text: "Booking Requests",
              icon: Icons.pending_actions,
              onPressed: () => context.go('/admin/booking-requests'),
            ),

            const SizedBox(height: 12),

            PrimaryButton(
              text: "View Complaints",
              icon: Icons.report_problem,
              onPressed: () => context.go("/admin/complaints"),
            ),
          ],
        ),
      ),
    );
  }
}
