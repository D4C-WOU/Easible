import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../services/booking_request_service.dart';

class BookingRequestsPage extends StatefulWidget {
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
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final list = snap.data ?? [];
          if (list.isEmpty)
            return const Center(child: Text('No booking requests'));
          return ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (_, i) {
              final r = list[i];
              return Card(
                child: ListTile(
                  title: Text(r['name'] ?? 'Unknown'),
                  subtitle: Text(
                    '${r['phone'] ?? ''} • ${r['preferred_time'] ?? ''}',
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
