import 'package:flutter/material.dart';
import '../../services/booking_service.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text("Manage Bookings")),
      body: ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (_, i) {
          final b = bookings[i];

          return ListTile(
            title: Text("Booking #${b["id"]}"),
            subtitle: Text("Slot ID: ${b["slot_id"]} • ${b["status"]}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
          );
        },
      ),
    );
  }
}
