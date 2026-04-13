import 'package:flutter/material.dart';
import '../../services/complaint_service.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/primary_button.dart';

class AdminComplaints extends StatefulWidget {
  const AdminComplaints({super.key});

  @override
  State<AdminComplaints> createState() => _AdminComplaintsState();
}

class _AdminComplaintsState extends State<AdminComplaints> {
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
      final res = await ComplaintService.getAll();
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

  Future<void> update(int id, String status) async {
    try {
      await ComplaintService.update(id, status);
      if (mounted) {
        await load();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Complaints",
      scrollable: false,
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : complaints.isEmpty
          ? const Center(child: Text("No complaints"))
          : ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (_, i) {
                final c = complaints[i];
                final message = c["message"]?.toString() ?? "No message";
                final status = c["status"]?.toString() ?? "unknown";
                final complaintId = c["id"];

                if (complaintId == null) return const SizedBox.shrink();

                final isClosed = status == "open";

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Status: $status",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        PrimaryButton(
                          text: isClosed ? "Mark as Resolved" : "Reopen",
                          icon: isClosed ? Icons.check_circle : Icons.undo,
                          onPressed: () {
                            final newStatus = isClosed ? "resolved" : "open";
                            update(complaintId, newStatus);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
