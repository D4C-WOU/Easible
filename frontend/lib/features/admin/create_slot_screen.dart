import 'package:flutter/material.dart';
import '../../services/slot_service.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/app_scaffold.dart';

class CreateSlotScreen extends StatefulWidget {
  const CreateSlotScreen({super.key});

  @override
  State<CreateSlotScreen> createState() => _CreateSlotScreenState();
}

class _CreateSlotScreenState extends State<CreateSlotScreen> {
  final _formKey = GlobalKey<FormState>();

  final facilityCtrl = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  void createSlot() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select date & time")));
      return;
    }

    final start = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final end = start.add(const Duration(minutes: 30));

    await SlotService.createSlot({
      "facility_id": int.parse(facilityCtrl.text),
      "start_time": start.toIso8601String(),
      "end_time": end.toIso8601String(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Slot Created")));
  }

  @override
  void dispose() {
    facilityCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Create Slot",
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: facilityCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Facility ID"),
              validator: (v) {
                if (v == null || v.isEmpty) return "Required";
                if (int.tryParse(v) == null) return "Enter valid number";
                return null;
              },
            ),

            const SizedBox(height: 12),

            ListTile(
              title: Text(
                selectedDate == null
                    ? "Select Date"
                    : selectedDate!.toString().split(" ")[0],
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: pickDate,
            ),

            ListTile(
              title: Text(
                selectedTime == null
                    ? "Select Time"
                    : selectedTime!.format(context),
              ),
              trailing: const Icon(Icons.access_time),
              onTap: pickTime,
            ),

            const SizedBox(height: 20),

            PrimaryButton(
              text: "Create Slot",
              icon: Icons.add,
              onPressed: createSlot,
            ),
          ],
        ),
      ),
    );
  }
}
