import 'package:flutter/material.dart';
import '../../services/slot_service.dart';

class CreateSlotScreen extends StatefulWidget {
  @override
  State<CreateSlotScreen> createState() => _CreateSlotScreenState();
}

class _CreateSlotScreenState extends State<CreateSlotScreen> {
  final facilityCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  void createSlot() async {
    await SlotService.createSlot({
      "facility_id": int.parse(facilityCtrl.text),
      "date": dateCtrl.text,
      "time": timeCtrl.text,
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Slot Created")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Slot")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: facilityCtrl,
              decoration: const InputDecoration(labelText: "Facility ID"),
            ),
            TextField(
              controller: dateCtrl,
              decoration: const InputDecoration(labelText: "Date"),
            ),
            TextField(
              controller: timeCtrl,
              decoration: const InputDecoration(labelText: "Time"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: createSlot, child: const Text("Create")),
          ],
        ),
      ),
    );
  }
}
