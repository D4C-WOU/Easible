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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'My Bookings',
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : bookings.isEmpty
          ? const Center(child: Text('No bookings yet.'))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (_, i) {
                final b = bookings[i];
                final id = b['id']?.toString() ?? '?';
                final status = b['status']?.toString() ?? 'pending';
                final facilityName =
                    b['facility_name']?.toString() ?? 'Public service centre';
                final facilityAddress = b['facility_address']?.toString() ?? '';
                final categoryName =
                    b['category_name']?.toString() ?? 'General';
                final date = (b['start_time'] ?? '')
                    .toString()
                    .split('T')
                    .first;
                final time =
                    (b['start_time'] ?? '').toString().split('T').length > 1
                    ? (b['start_time'] ?? '')
                          .toString()
                          .split('T')[1]
                          .substring(0, 5)
                    : '';

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Booking #$id',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            StatusChip(status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$categoryName • $facilityName',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (facilityAddress.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            facilityAddress,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Text('Appointment: $date at $time'),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Chip(label: Text('Queue No. 12')),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Details'),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Navigate'),
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
