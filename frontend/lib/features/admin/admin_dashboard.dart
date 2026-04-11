import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Command Center")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.admin_panel_settings, size: 80),
            const SizedBox(height: 10),

            Text(
              "Welcome Admin",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 30),

            // 📅 CREATE SLOT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_box),
                label: const Text("Create Slots"),
                onPressed: () => context.go("/admin/create-slot"),
              ),
            ),

            const SizedBox(height: 15),

            // 📦 BOOKINGS
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.book_online),
                label: const Text("Manage Bookings"),
                onPressed: () => context.go("/admin/bookings"),
              ),
            ),

            const SizedBox(height: 15),

            // 📩 COMPLAINTS
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.report_problem),
                label: const Text("View Complaints"),
                onPressed: () => context.go("/admin/complaints"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
