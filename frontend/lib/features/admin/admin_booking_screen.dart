import 'package:flutter/material.dart';
import '../../services/booking_service.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/primary_button.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  List<Map<String, dynamic>> bookings = [];
  bool loading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    try {
      final res = await BookingService.getBookings();
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

  Future<void> update(int id, String status) async {
    try {
      await BookingService.updateBooking(id, status);
      if (mounted) {
        await loadBookings();
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
      title: "Manage Bookings",
      scrollable: false,
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : bookings.isEmpty
          ? const Center(child: Text("No bookings"))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (_, i) {
                final b = bookings[i];
                final id = b["id"]?.toString() ?? "?";
                final slotId = b["slot_id"]?.toString() ?? "?";
                final status = b["status"]?.toString() ?? "unknown";
                final bookingId = b["id"];

                if (bookingId == null) return const SizedBox.shrink();

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Booking #$id",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Slot ID: $slotId",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        StatusChip(status),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: "Accept",
                                icon: Icons.check,
                                onPressed: () => update(bookingId, "accepted"),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: PrimaryButton(
                                text: "Reject",
                                icon: Icons.close,
                                onPressed: () => update(bookingId, "rejected"),
                              ),
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
