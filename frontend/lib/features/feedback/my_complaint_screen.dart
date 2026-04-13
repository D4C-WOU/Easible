import 'package:flutter/material.dart';
import '../../services/complaint_service.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/app_scaffold.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  List<Map<String, dynamic>> complaints = [];
  bool loading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await ComplaintService.getMyComplaints();
      if (mounted) {
        setState(() {
          complaints = (res as List).cast<Map<String, dynamic>>();
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "My Complaints",
      scrollable: false,
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : complaints.isEmpty
          ? const Center(child: Text("No complaints yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: complaints.length,
              itemBuilder: (_, i) {
                final c = complaints[i];
                final message = c["message"]?.toString() ?? "No message";
                final status = c["status"]?.toString() ?? "unknown";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(blurRadius: 5, color: Colors.black12),
                    ],
                  ),
                  child: ListTile(
                    title: Text(message),
                    trailing: StatusChip(status),
                  ),
                );
              },
            ),
    );
  }
}
