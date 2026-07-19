import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../services/facility_service.dart';
import '../../services/slot_service.dart';

class CreateSlotScreen extends StatefulWidget {
  const CreateSlotScreen({super.key});

  @override
  State<CreateSlotScreen> createState() => _CreateSlotScreenState();
}

class _CreateSlotScreenState extends State<CreateSlotScreen> {
  final _formKey = GlobalKey<FormState>();
  int? selectedFacilityId;
  List<dynamic> facilities = [];
  bool loadingFacilities = true;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _capacityCtrl = TextEditingController(text: '20');
  final TextEditingController _notesCtrl = TextEditingController();
  String selectedStatus = 'Open';

  @override
  void initState() {
    super.initState();
    _loadFacilities();
  }

  @override
  void dispose() {
    _capacityCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadFacilities() async {
    try {
      final result = await FacilityService.getFacilities(0);
      if (!mounted) return;
      setState(() {
        facilities = (result as List).cast<Map<String, dynamic>>();
        loadingFacilities = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loadingFacilities = false);
    }
  }

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

  Future<void> createSlot() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a date and time first.')),
      );
      return;
    }
    if (selectedFacilityId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select a facility.')));
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

    try {
      await SlotService.createSlot({
        'facility_id': selectedFacilityId,
        'start_time': start.toIso8601String(),
        'end_time': end.toIso8601String(),
      });
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Slot published'),
          content: const Text(
            'The service window is now available for citizen appointments.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to create slot: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Create Service Slot',
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Plan a public-service slot',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Create service windows for appointments, document support, or citizen assistance.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      if (loadingFacilities)
                        const Center(child: CircularProgressIndicator())
                      else
                        DropdownButtonFormField<int>(
                          value: selectedFacilityId,
                          decoration: const InputDecoration(
                            labelText: 'Facility',
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          items: facilities.map((facility) {
                            final id = facility['id'] as int?;
                            final name =
                                facility['name']?.toString() ?? 'Facility';
                            return DropdownMenuItem<int>(
                              value: id,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => selectedFacilityId = value),
                          validator: (value) =>
                              value == null ? 'Choose a facility' : null,
                        ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedStatus,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          prefixIcon: Icon(Icons.flag_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Open', child: Text('Open')),
                          DropdownMenuItem(
                            value: 'Priority',
                            child: Text('Priority'),
                          ),
                          DropdownMenuItem(
                            value: 'Paused',
                            child: Text('Paused'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedStatus = value ?? 'Open'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _capacityCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Available seats',
                          prefixIcon: Icon(Icons.people_alt_outlined),
                        ),
                        validator: (value) => (value == null || value.isEmpty)
                            ? 'Enter seat capacity'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          selectedDate == null
                              ? 'Select Date'
                              : selectedDate!.toString().split(' ')[0],
                        ),
                        leading: const Icon(Icons.calendar_today),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: pickDate,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          selectedTime == null
                              ? 'Select Time'
                              : selectedTime!.format(context),
                        ),
                        leading: const Icon(Icons.access_time),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: pickTime,
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _notesCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          prefixIcon: Icon(Icons.notes_outlined),
                        ),
                      ),
                      const SizedBox(height: 16),
                      PrimaryButton(
                        text: 'Create slot',
                        icon: Icons.add_circle_outline,
                        onPressed: createSlot,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
