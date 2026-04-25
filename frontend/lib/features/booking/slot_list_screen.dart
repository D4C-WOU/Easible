import 'package:flutter/material.dart';
import '../../services/slot_service.dart';
import '../../services/booking_service.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/primary_button.dart';

class SlotListScreen extends StatefulWidget {
  const SlotListScreen({super.key});

  @override
  State<SlotListScreen> createState() => _SlotListScreenState();
}

class _SlotListScreenState extends State<SlotListScreen> {
  List<Map<String, dynamic>> slots = [];
  bool loading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    fetchSlots();
  }

  Future<void> fetchSlots() async {
    try {
      final res = await SlotService.getSlots();

      if (mounted) {
        setState(() {
          slots = (res as List).cast<Map<String, dynamic>>();
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

  Future<void> _bookSlot(int slotId) async {
    try {
      await BookingService.createBooking(slotId);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Booking Requested")));

        await fetchSlots(); // ✅ refresh list
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Booking failed: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Available Slots",
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : slots.isEmpty
          ? const Center(child: Text("No slots available"))
          : ListView.builder(
              itemCount: slots.length,
              itemBuilder: (_, i) {
                final s = slots[i];

                final end = s["end_time"]?.toString() ?? "";

                final start = s["start_time"]?.toString() ?? "";

                String date = "N/A";
                String time = "N/A";

                if (start.contains("T")) {
                  final parts = start.split("T");
                  if (parts.length >= 2) {
                    date = parts[0];
                    time = parts[1].substring(0, 5); // HH:MM only
                  }
                }

                final isAvailable =
                    s["available"] == true || s['available'] == 1;
                final facilityId = s["facility_id"]?.toString() ?? "?";
                final slotId = s["id"];

                if (slotId == null) return const SizedBox.shrink();

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$date - $time",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text("Facility ID: $facilityId"),
                        const SizedBox(height: 8),
                        Text(
                          isAvailable ? "Available" : "Booked",
                          style: TextStyle(
                            color: isAvailable ? Colors.green : Colors.red,
                          ),
                        ),
                        const SizedBox(height: 12),
                        PrimaryButton(
                          text: isAvailable ? "Book" : "Unavailable",
                          icon: Icons.shopping_cart,
                          onPressed: isAvailable
                              ? () => _bookSlot(slotId)
                              : () {}, // NEVER NULL
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
