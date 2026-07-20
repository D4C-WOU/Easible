import 'package:flutter/material.dart';
import '../../services/complaint_service.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/status_chip.dart';

class AdminComplaints extends StatefulWidget {
  const AdminComplaints({super.key});

  @override
  State<AdminComplaints> createState() => _AdminComplaintsState();
}

class _AdminComplaintsState extends State<AdminComplaints> {
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

  Future<void> _update(int id, String status) async {
    try {
      await ComplaintService.update(id, status);
      if (mounted) await load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  String _fmtDate(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    try {
      final dt = DateTime.parse(raw.replaceAll(' ', 'T'));
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Complaints',
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : complaints.isEmpty
          ? const Center(child: Text('No complaints'))
          : RefreshIndicator(
              onRefresh: load,
              child: ListView.builder(
                itemCount: complaints.length,
                itemBuilder: (_, i) {
                  final c = complaints[i];
                  final complaintId = c['id'] as int?;
                  if (complaintId == null) {
                    return const SizedBox.shrink();
                  }

                  final message = c['message']?.toString() ?? 'No message';
                  final status = c['status']?.toString() ?? 'open';
                  final facilityName =
                      c['facility_name']?.toString() ?? 'General';
                  final facilityCity = c['facility_city']?.toString() ?? '';
                  final categoryName = c['category_name']?.toString() ?? '';
                  final createdAt = c['created_at']?.toString();
                  final isOpen = status == 'open';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Complaint #$complaintId',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              StatusChip(status),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Facility / category
                          if (categoryName.isNotEmpty ||
                              facilityName != 'General') ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_city_outlined,
                                  size: 14,
                                  color: Color(0xFF0F4C81),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    categoryName.isNotEmpty
                                        ? '$categoryName • $facilityName'
                                              '${facilityCity.isNotEmpty ? ', $facilityCity' : ''}'
                                        : facilityName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                          ],

                          // Date
                          if (createdAt != null && createdAt.isNotEmpty) ...[
                            Row(
                              children: [
                                const Icon(
                                  Icons.schedule,
                                  size: 13,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _fmtDate(createdAt),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                          ],

                          // Message
                          Text(
                            message,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),

                          // Action button
                          SizedBox(
                            width: double.infinity,
                            child: isOpen
                                ? ElevatedButton.icon(
                                    onPressed: () =>
                                        _update(complaintId, 'resolved'),
                                    icon: const Icon(
                                      Icons.check_circle,
                                      size: 16,
                                    ),
                                    label: const Text('Mark as Resolved'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF2E7D32),
                                      foregroundColor: Colors.white,
                                    ),
                                  )
                                : OutlinedButton.icon(
                                    onPressed: () =>
                                        _update(complaintId, 'open'),
                                    icon: const Icon(Icons.undo, size: 16),
                                    label: const Text('Reopen'),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
