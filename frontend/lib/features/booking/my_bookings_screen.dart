import 'package:flutter/material.dart';
import '../../services/booking_service.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/app_scaffold.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<Map<String, dynamic>> bookings = [];
  bool loading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await BookingService.getMyBookings();
      if (mounted) {
        setState(() {
          bookings = (res as List).cast<Map<String, dynamic>>();
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
      title: "My Bookings",
      scrollable: false,
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : bookings.isEmpty
          ? const Center(child: Text("No bookings yet"))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (_, i) {
                final b = bookings[i];
                final id = b["id"]?.toString() ?? "?";
                final slotId = b["slot_id"]?.toString() ?? "?";
                final status = b["status"]?.toString() ?? "unknown";

                return Card(
                  child: ListTile(
                    title: Text("Booking #$id"),
                    subtitle: Text("Slot ID: $slotId"),
                    trailing: StatusChip(status),
                  ),
                );
              },
            ),
    );
  }
}
