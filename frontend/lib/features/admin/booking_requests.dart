import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../services/booking_request_service.dart';

class BookingRequestsPage extends StatefulWidget {
  const BookingRequestsPage({super.key});

  @override
  State<BookingRequestsPage> createState() => _BookingRequestsPageState();
}

class _BookingRequestsPageState extends State<BookingRequestsPage> {
  late Future<List<dynamic>> _requests;

  @override
  void initState() {
    super.initState();
    _requests = BookingRequestService.fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Booking Requests',
      child: FutureBuilder<List<dynamic>>(
        future: _requests,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final list = snap.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('No booking requests'));
          }
          return ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (_, i) {
              final r = list[i];
              final status = r['status']?.toString() ?? 'pending';
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r['name']?.toString() ?? 'Unknown',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${r['phone'] ?? ''} • ${r['preferred_time'] ?? ''}',
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Category: ${r['category_name'] ?? 'General'}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${status.toUpperCase()}',
                        style: TextStyle(
                          color: status == 'approved' || status == 'completed'
                              ? Colors.green
                              : status == 'rejected'
                              ? Colors.red
                              : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              await BookingRequestService.updateStatus(
                                r['id'],
                                'accepted',
                              );
                              if (!mounted) return;
                              setState(
                                () => _requests =
                                    BookingRequestService.fetchRequests(),
                              );
                            },
                            child: const Text('Accept'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () async {
                              await BookingRequestService.updateStatus(
                                r['id'],
                                'rejected',
                              );
                              if (!mounted) return;
                              setState(
                                () => _requests =
                                    BookingRequestService.fetchRequests(),
                              );
                            },
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
