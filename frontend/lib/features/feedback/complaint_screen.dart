import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../services/complaint_service.dart';
import '../../services/facility_service.dart';
import '../../models/facility_model.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _ctrl = TextEditingController();
  bool _isSubmitting = false;
  bool _loadingFacilities = true;

  List<Facility> _facilities = [];
  int? _selectedFacilityId;

  @override
  void initState() {
    super.initState();
    _loadFacilities();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadFacilities() async {
    try {
      final res = await FacilityService.getFacilities();
      if (!mounted) return;
      setState(() {
        _facilities = res;
        _loadingFacilities = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingFacilities = false);
    }
  }

  Future<void> _submit() async {
    if (_ctrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe the issue.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await ComplaintService.submitWithFacility(
        _ctrl.text.trim(),
        facilityId: _selectedFacilityId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully.')),
      );
      setState(() {
        _ctrl.clear();
        _selectedFacilityId = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to submit: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Submit Complaint',
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Report a service issue',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Share concerns related to queues, service quality, facility access, or documentation support.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complaint details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),

                    // Facility dropdown
                    _loadingFacilities
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : DropdownButtonFormField<int>(
                            value: _selectedFacilityId,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              labelText: 'Facility (optional)',
                              prefixIcon: Icon(Icons.location_city_outlined),
                              border: OutlineInputBorder(),
                            ),
                            hint: const Text('Select facility'),
                            items: [
                              const DropdownMenuItem<int>(
                                value: null,
                                child: Text('— General complaint —'),
                              ),
                              ..._facilities.map<DropdownMenuItem<int>>((f) {
                                return DropdownMenuItem<int>(
                                  value: f.id,
                                  child: Text(
                                    f.city.isNotEmpty
                                        ? '${f.name}, ${f.city}'
                                        : f.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }),
                            ],
                            onChanged: (v) =>
                                setState(() => _selectedFacilityId = v),
                          ),

                    const SizedBox(height: 14),

                    // Message field
                    TextField(
                      controller: _ctrl,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Describe the issue',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            text: 'Submit complaint',
                            icon: Icons.send,
                            onPressed: _submit,
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
