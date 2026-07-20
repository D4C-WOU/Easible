import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
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
  Set<int> requestInProgress = {};

  @override
  void initState() {
    super.initState();
    fetchSlots();
  }

  Future<void> fetchSlots() async {
    try {
      final res = await SlotService.getSlots();
      if (!mounted) return;
      setState(() {
        slots = (res as List).cast<Map<String, dynamic>>();
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  DateTime? _parse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateTime.parse(raw.replaceAll(' ', 'T'));
    } catch (_) {
      return null;
    }
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return '${dt.day.toString().padLeft(2, '0')}/'
        '${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  String _fmtTime(DateTime? dt) {
    if (dt == null) return 'N/A';
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _requestSlot(int slotId) async {
    setState(() => requestInProgress.add(slotId));
    try {
      await BookingService.createBooking(slotId);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
              SizedBox(width: 8),
              Text('Request Submitted'),
            ],
          ),
          content: const Text(
            'Your appointment request has been submitted and is pending admin approval. '
            'You will be notified once it is confirmed.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      await fetchSlots(); // refresh
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => requestInProgress.remove(slotId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Book Appointment',
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(error, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        loading = true;
                        error = '';
                      });
                      fetchSlots();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            )
          : slots.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 56, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  const Text('No appointment slots available.'),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchSlots,
              child: ListView.builder(
                itemCount: slots.length,
                itemBuilder: (_, i) {
                  final s = slots[i];
                  final slotId = s['id'] as int?;
                  if (slotId == null) return const SizedBox.shrink();

                  final startDt = _parse(s['start_time']?.toString());
                  final endDt = _parse(s['end_time']?.toString());
                  final isAvailable =
                      s['available'] == true || s['available'] == 1;
                  final facilityName =
                      s['facility_name']?.toString() ?? 'Public Service Centre';
                  final address = s['facility_address']?.toString() ?? '';
                  final city = s['facility_city']?.toString() ?? '';
                  final isRequesting = requestInProgress.contains(slotId);

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date + availability badge
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _fmtDate(startDt),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: isAvailable
                                      ? const Color(0xFFE8F5E9)
                                      : const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  isAvailable ? 'Available' : 'Booked',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: isAvailable
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFFD32F2F),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Time
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 14,
                                color: Color(0xFF0F4C81),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${_fmtTime(startDt)}  –  ${_fmtTime(endDt)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0F4C81),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 6),

                          // Facility
                          Row(
                            children: [
                              const Icon(
                                Icons.location_city,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  facilityName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          if (address.isNotEmpty || city.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 13,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    [
                                      address,
                                      city,
                                    ].where((s) => s.isNotEmpty).join(', '),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 12),

                          // Request button
                          SizedBox(
                            width: double.infinity,
                            child: isRequesting
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: isAvailable
                                        ? () => _requestSlot(slotId)
                                        : null,
                                    icon: Icon(
                                      isAvailable
                                          ? Icons.calendar_month
                                          : Icons.block,
                                      size: 18,
                                    ),
                                    label: Text(
                                      isAvailable
                                          ? 'Request Appointment'
                                          : 'Not Available',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isAvailable
                                          ? const Color(0xFF0F4C81)
                                          : Colors.grey.shade300,
                                      foregroundColor: isAvailable
                                          ? Colors.white
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                          ),

                          if (isAvailable)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Requires admin approval',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
