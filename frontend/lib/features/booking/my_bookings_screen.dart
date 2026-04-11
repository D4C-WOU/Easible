import 'package:flutter/material.dart';
import '../../services/booking_service.dart';

class MyBookingsScreen extends StatefulWidget {
  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<dynamic> bookings = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final res = await BookingService.getMyBookings();

    setState(() {
      bookings = res;
      loading = false;
    });
  }

  Color getColor(String status) {
    switch (status) {
      case "accepted":
        return Colors.green;
      case "rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Bookings")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
          ? const Center(child: Text("No bookings yet"))
          : ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (_, i) {
                final b = bookings[i];

                return Card(
                  child: ListTile(
                    title: Text("Booking #${b["id"]}"),
                    subtitle: Text("Slot ID: ${b["slot_id"]}"),
                    trailing: Text(
                      b["status"].toUpperCase(),
                      style: TextStyle(
                        color: getColor(b["status"]),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
