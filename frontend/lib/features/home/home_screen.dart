import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/storage_service.dart';
import '../directory/directory_screen.dart';
import 'crowd_widget.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/app_scaffold.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Home",
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await StorageService.clearToken();
            context.go("/login");
          },
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Welcome 👋", style: Theme.of(context).textTheme.headlineSmall),

          const SizedBox(height: 20),

          CrowdWidget(),

          const SizedBox(height: 20),

          PrimaryButton(
            text: "View Slots",
            icon: Icons.schedule,
            onPressed: () => context.go("/slots"),
          ),

          const SizedBox(height: 12),

          PrimaryButton(
            text: "My Bookings",
            icon: Icons.history,
            onPressed: () => context.go("/my-bookings"),
          ),

          const SizedBox(height: 12),

          PrimaryButton(
            text: "My Complaints",
            icon: Icons.report,
            onPressed: () => context.go("/my-complaints"),
          ),

          const SizedBox(height: 12),

          PrimaryButton(
            text: "Service Requirements",
            icon: Icons.description,
            onPressed: () => context.go("/services"),
          ),

          const SizedBox(height: 12),

          PrimaryButton(
            text: "Submit Complaint",
            icon: Icons.feedback,
            onPressed: () => context.go("/complaint"),
          ),

          const SizedBox(height: 20),

          Text("Directory", style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 10),

          SizedBox(height: 400, child: DirectoryScreen()),
        ],
      ),
    );
  }
}
