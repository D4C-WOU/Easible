import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchAdminData();
  }

  void fetchAdminData() async {
    try {
      final res = await ApiService.getWithAuth("/admin/dashboard");

      setState(() {
        data = res;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Command Center")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : data == null
          ? const Center(child: Text("Access Denied"))
          : Column(
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.admin_panel_settings, size: 80),
                Text(
                  "Welcome Admin",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Text("User ID: ${data!["admin_data"]["user_id"]}"),
                Text("Role: ${data!["admin_data"]["role"]}"),
              ],
            ),
    );
  }
}
