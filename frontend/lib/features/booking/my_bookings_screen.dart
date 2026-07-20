import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/status_chip.dart';
import '../../services/booking_service.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<Map<String, dynamic>> bookings = [];
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await BookingService.getMyBookings();
      if (!mounted) return;
      setState(() {
        bookings = (res as List).cast<Map<String, dynamic>>();
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

  /// Safely parse datetime strings from the API.
  /// MySQL may return "2026-08-01 09:00:00" (space) or
  /// "2026-08-01T09:00:00" (T). Both are handled here.
  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(raw.replaceAll(' ', 'T'));
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year}';
    } catch (_) {
      return raw.split(' ').first; // fallback: return date portion as-is
    }
  }

  String _formatTime(String? raw) {
    if (raw == null || raw.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(raw.replaceAll(' ', 'T'));
      return '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      // fallback: grab the time portion after the space or T
      final parts = raw.split(RegExp(r'[T ]'));
      return parts.length > 1 ? parts[1].substring(0, 5) : raw;
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'accepted':
        return const Color(0xFF2E7D32);
      case 'cancelled':
      case 'rejected':
        return const Color(0xFFD32F2F);
      case 'completed':
        return const Color(0xFF1565C0);
      default:
        return const Color(0xFFF9A825);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'My Bookings',
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(
                    error,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        loading = true;
                        error = '';
                      });
                      load();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            )
          : bookings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 56,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No bookings yet.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Book an appointment from the slots screen.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                setState(() => loading = true);
                await load();
              },
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (_, i) {
                  final b = bookings[i];
                  final id = b['id']?.toString() ?? '?';
                  final status = b['status']?.toString() ?? 'pending';
                  final facilityName =
                      b['facility_name']?.toString() ?? 'Public Service Centre';
                  final facilityAddress =
                      b['facility_address']?.toString() ?? '';
                  final facilityCity = b['facility_city']?.toString() ?? '';
                  final categoryName =
                      b['category_name']?.toString() ?? 'General';
                  final date = _formatDate(b['start_time']?.toString());
                  final time = _formatTime(b['start_time']?.toString());
                  final endTime = _formatTime(b['end_time']?.toString());

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
                                  'Booking #$id',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              StatusChip(status),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Category + facility
                          Row(
                            children: [
                              const Icon(
                                Icons.local_hospital_outlined,
                                size: 16,
                                color: Color(0xFF0F4C81),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '$categoryName • $facilityName',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (facilityAddress.isNotEmpty ||
                              facilityCity.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    [
                                      facilityAddress,
                                      facilityCity,
                                    ].where((s) => s.isNotEmpty).join(', '),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF4FB),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Color(0xFF0F4C81),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$date  •  $time – $endTime',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0F4C81),
                                  ),
                                ),
                              ],
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
