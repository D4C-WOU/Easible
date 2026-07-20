import 'package:flutter/material.dart';
import '../../services/booking_service.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/app_scaffold.dart';

class AdminBookingScreen extends StatefulWidget {
  /// null = pending queue (Manage Bookings, actionable)
  /// 'accepted' = Confirmed Bookings (read-only)
  final String? filterStatus;
  const AdminBookingScreen({super.key, this.filterStatus});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  List<Map<String, dynamic>> bookings = [];
  bool loading = true;
  String error = '';

  bool get isManageView => widget.filterStatus == null;

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      final res = await BookingService.getBookings();
      if (!mounted) return;
      List<Map<String, dynamic>> all = (res as List)
          .cast<Map<String, dynamic>>();
      setState(() {
        bookings = isManageView
            ? all.where((b) => b['status'] == 'pending').toList()
            : all.where((b) => b['status'] == widget.filterStatus).toList();
        loading = false;
      });
    } catch (e) {
      if (mounted)
        setState(() {
          error = e.toString();
          loading = false;
        });
    }
  }

  Future<void> _update(int id, String status) async {
    try {
      await BookingService.updateBooking(id, status);
      if (mounted) await loadBookings();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              status == 'accepted' ? 'Booking confirmed' : 'Booking rejected',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  String _fmtDatetime(String? raw) {
    if (raw == null || raw.isEmpty) return 'N/A';
    try {
      final dt = DateTime.parse(raw.replaceAll(' ', 'T'));
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: isManageView ? 'Manage Bookings' : 'Confirmed Bookings',
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : bookings.isEmpty
          ? Center(
              child: Text(
                isManageView
                    ? 'No pending requests. All caught up!'
                    : 'No confirmed bookings yet.',
              ),
            )
          : RefreshIndicator(
              onRefresh: loadBookings,
              child: ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (_, i) {
                  final b = bookings[i];
                  final bookingId = b['id'] as int?;
                  if (bookingId == null) return const SizedBox.shrink();

                  final status = b['status']?.toString() ?? 'pending';
                  final userName = b['user_name']?.toString() ?? 'Unknown';
                  final userEmail = b['user_email']?.toString() ?? '';
                  final userPhone = b['user_phone']?.toString() ?? '';
                  final facilityName = b['facility_name']?.toString() ?? 'N/A';
                  final facilityCity = b['facility_city']?.toString() ?? '';
                  final categoryName =
                      b['category_name']?.toString() ?? 'General';
                  final startTime = _fmtDatetime(b['start_time']?.toString());
                  final endTime = _fmtDatetime(b['end_time']?.toString());

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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Booking #$bookingId',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              StatusChip(status),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_city,
                                size: 15,
                                color: Color(0xFF0F4C81),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '$categoryName • $facilityName'
                                  '${facilityCity.isNotEmpty ? ' ($facilityCity)' : ''}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '$startTime  –  $endTime',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.person_outline,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '$userName'
                                  '${userEmail.isNotEmpty ? ' • $userEmail' : ''}'
                                  '${userPhone.isNotEmpty ? ' • $userPhone' : ''}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isManageView) ...[
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        _update(bookingId, 'accepted'),
                                    icon: const Icon(Icons.check, size: 16),
                                    label: const Text('Accept'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF1B5E20),
                                      foregroundColor: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        _update(bookingId, 'rejected'),
                                    icon: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    label: const Text(
                                      'Reject',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
