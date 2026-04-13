import 'package:flutter/material.dart';
import '../../services/slot_service.dart';
import '../../services/booking_service.dart';
import '../../core/widgets/app_scaffold.dart';

class SlotListScreen extends StatefulWidget {
  @override
  State<SlotListScreen> createState() => _SlotListScreenState();
}

class _SlotListScreenState extends State<SlotListScreen> {
  List<dynamic> slots = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchSlots();
  }

  void fetchSlots() async {
    final res = await SlotService.getSlots();

    setState(() {
      slots = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Available Slots",
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: slots.length,
              itemBuilder: (_, i) {
                final s = slots[i];
                return Card(
                  child: ListTile(
                    title: Text("${s["date"]} - ${s["time"]}"),
                    subtitle: Text("Facility ID: ${s["facility_id"]}"),
                    trailing: ElevatedButton(
                      onPressed: s["status"] == "available"
                          ? () async {
                              await BookingService.createBooking(s["id"]);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Booking Requested"),
                                ),
                              );
                            }
                          : null,
                      child: const Text("Book"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
