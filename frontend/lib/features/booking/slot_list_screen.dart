import 'package:flutter/material.dart';
import '../../services/slot_service.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text("Available Slots")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: slots.length,
              itemBuilder: (_, i) {
                final s = slots[i];
                return ListTile(
                  title: Text("${s["date"]} - ${s["time"]}"),
                  subtitle: Text("Facility ID: ${s["facility_id"]}"),
                  trailing: Text(s["status"]),
                );
              },
            ),
    );
  }
}
