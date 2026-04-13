import 'package:flutter/material.dart';
import '../../services/booking_service.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/app_scaffold.dart';

class AdminBookingScreen extends StatefulWidget {
  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  List<dynamic> bookings = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  void loadBookings() async {
    final res = await BookingService.getBookings();
    setState(() => bookings = res);
  }

  void update(int id, String status) async {
    await BookingService.updateBooking(id, status);
    loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Manage Bookings",
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: bookings.length,
        itemBuilder: (_, i) {
          final b = bookings[i];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(blurRadius: 5, color: Colors.black12),
              ],
            ),
            child: ListTile(
              title: Text("Booking #${b["id"]}"),
              subtitle: Text("Slot ID: ${b["slot_id"]}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusChip(b["status"]),
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => update(b["id"], "accepted"),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => update(b["id"], "rejected"),
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
