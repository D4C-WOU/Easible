import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../services/facility_service.dart';
import '../../services/slot_service.dart';
import '../../models/facility_model.dart';

class CreateSlotScreen extends StatefulWidget {
  const CreateSlotScreen({super.key});

  @override
  State<CreateSlotScreen> createState() => _CreateSlotScreenState();
}

class _CreateSlotScreenState extends State<CreateSlotScreen> {
  final _formKey = GlobalKey<FormState>();
  int? selectedFacilityId;
  List<Facility> facilities = [];
  bool loadingFacilities = true;
  bool isSubmitting = false;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFacilities();
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadFacilities() async {
    try {
      // FIX: pass null (no categoryId) so ALL facilities are returned
      final result = await FacilityService.getFacilities();
      if (!mounted) return;
      setState(() {
        facilities = result;
        loadingFacilities = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loadingFacilities = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to load facilities: $e')));
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  Future<void> _createSlot() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedFacilityId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a facility.')),
      );
      return;
    }

    if (selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a date and time.')),
      );
      return;
    }

    setState(() => isSubmitting = true);

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

      setState(() {
        isSubmitting = false;
        selectedDate = null;
        selectedTime = null;
        selectedFacilityId = null;
        _notesCtrl.clear();
      });

      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Slot Created'),
          content: const Text(
            'The service window is now available for citizen appointments.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create slot: $e')));
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
                        'Create appointment windows for citizens to visit '
                        'the selected facility.',
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
                      // ── Facility Dropdown ──────────────────────────────
                      loadingFacilities
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : DropdownButtonFormField<int>(
                              value: selectedFacilityId,
                              isExpanded: true,
                              decoration: const InputDecoration(
                                labelText: 'Facility',
                                prefixIcon: Icon(Icons.location_city),
                              ),
                              items: facilities.map<DropdownMenuItem<int>>((f) {
                                final facility = f as Facility;
                                return DropdownMenuItem<int>(
                                  value: facility.id,
                                  child: Text(
                                    facility.city.isNotEmpty
                                        ? '${facility.name} (${facility.city})'
                                        : facility.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (v) =>
                                  setState(() => selectedFacilityId = v),
                              validator: (v) =>
                                  v == null ? 'Please select a facility' : null,
                            ),

                      const SizedBox(height: 16),

                      // ── Date Picker ────────────────────────────────────
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today),
                        title: Text(
                          selectedDate == null
                              ? 'Select Date'
                              : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _pickDate,
                      ),
                      const Divider(height: 1),

                      // ── Time Picker ────────────────────────────────────
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.access_time),
                        title: Text(
                          selectedTime == null
                              ? 'Select Time (slot lasts 30 min)'
                              : selectedTime!.format(context),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _pickTime,
                      ),
                      const Divider(height: 1),

                      const SizedBox(height: 16),

                      // ── Notes ──────────────────────────────────────────
                      TextField(
                        controller: _notesCtrl,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Internal notes (optional)',
                          prefixIcon: Icon(Icons.notes_outlined),
                        ),
                      ),

                      const SizedBox(height: 20),

                      isSubmitting
                          ? const Center(child: CircularProgressIndicator())
                          : PrimaryButton(
                              text: 'Create Slot',
                              icon: Icons.add_circle_outline,
                              onPressed: _createSlot,
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
