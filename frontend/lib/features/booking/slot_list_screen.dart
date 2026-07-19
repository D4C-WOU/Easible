import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../services/booking_service.dart';
import '../../services/slot_service.dart';

class SlotListScreen extends StatefulWidget {
  const SlotListScreen({super.key});

  @override
  State<SlotListScreen> createState() => _SlotListScreenState();
}

class _SlotListScreenState extends State<SlotListScreen> {
  List<Map<String, dynamic>> slots = [];
  bool loading = true;
  String error = '';

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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Appointment request submitted successfully.'),
        ),
      );
      await fetchSlots();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Book Appointment',
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : slots.isEmpty
          ? const Center(
              child: Text('No appointment slots are available right now.'),
            )
          : ListView.builder(
              itemCount: slots.length,
              itemBuilder: (_, i) {
                final s = slots[i];
                final start = s['start_time']?.toString() ?? '';
                String date = 'N/A';
                String time = 'N/A';
                if (start.contains('T')) {
                  final parts = start.split('T');
                  if (parts.length >= 2) {
                    date = parts[0];
                    time = parts[1].substring(0, 5);
                  }
                }
                final isAvailable =
                    s['available'] == true || s['available'] == 1;
                final facilityName =
                    s['facility_name']?.toString() ?? 'Public service centre';
                final address = s['facility_address']?.toString() ?? '';
                final slotId = s['id'];
                if (slotId == null) return const SizedBox.shrink();

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
                                '$date • $time',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Chip(
                              label: Text(isAvailable ? 'Available' : 'Booked'),
                              backgroundColor: isAvailable
                                  ? const Color(0xFFE8F5E9)
                                  : const Color(0xFFFFEBEE),
                              side: BorderSide.none,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          facilityName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (address.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            address,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: isAvailable
                                    ? 'Reserve slot'
                                    : 'Unavailable',
                                icon: Icons.event_available,
                                onPressed: isAvailable
                                    ? () => _bookSlot(slotId)
                                    : () {},
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
