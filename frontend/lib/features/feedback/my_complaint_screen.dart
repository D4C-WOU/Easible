import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/status_chip.dart';
import '../../services/complaint_service.dart';

class MyComplaintsScreen extends StatefulWidget {
  const MyComplaintsScreen({super.key});

  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  List<Map<String, dynamic>> complaints = [];
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await ComplaintService.getMyComplaints();
      if (!mounted) return;
      setState(() {
        complaints = (res as List).cast<Map<String, dynamic>>();
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'My Complaints',
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : complaints.isEmpty
          ? const Center(child: Text('No complaints have been submitted yet.'))
          : ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (_, i) {
                final c = complaints[i];
                final message = c['message']?.toString() ?? 'No message';
                final status = c['status']?.toString() ?? 'pending';
                final created =
                    c['created_at']?.toString() ?? 'Recently submitted';
                final priority = status.toLowerCase() == 'resolved'
                    ? 'Low'
                    : 'High';

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Complaint ID #${i + 1}',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            StatusChip(status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          message,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 6),
                        Text('Submitted: $created'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Chip(label: Text('Priority: $priority')),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Details'),
                            ),
                          ],
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
