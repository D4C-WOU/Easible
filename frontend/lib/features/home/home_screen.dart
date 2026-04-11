import 'package:flutter/material.dart';
import '../directory/directory_screen.dart';
import 'crowd_widget.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CrowdWidget(),

        const SizedBox(height: 10),

        // 📄 SERVICES
        ElevatedButton.icon(
          icon: const Icon(Icons.description),
          label: const Text("Service Requirements"),
          onPressed: () => context.go("/services"),
        ),

        const SizedBox(height: 10),

        // 📩 COMPLAINT
        ElevatedButton.icon(
          icon: const Icon(Icons.feedback),
          label: const Text("Submit Complaint"),
          onPressed: () => context.go("/complaint"),
        ),
        //My Bookings
        ElevatedButton.icon(
          icon: const Icon(Icons.history),
          label: const Text("My Bookings"),
          onPressed: () => context.go("/my-bookings"),
        ),

        const SizedBox(height: 10),

        Expanded(child: DirectoryScreen()),
      ],
    );
  }
}
