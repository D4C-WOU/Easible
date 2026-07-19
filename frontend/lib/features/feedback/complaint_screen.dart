import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/primary_button.dart';
import '../../services/complaint_service.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final ctrl = TextEditingController();
  bool isSubmitting = false;
  final _category = 'Service quality';
  final _service = 'Public service desk';

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (ctrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please describe the issue before submitting.'),
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await ComplaintService.submit('${_category}: ${ctrl.text.trim()}');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully.')),
      );
      ctrl.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Submit Complaint',
      child: SingleChildScrollView(
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
                    const SizedBox(height: 10),
                    Text('Category: $_category'),
                    const SizedBox(height: 4),
                    Text('Service: $_service'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: ctrl,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Describe the issue',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : PrimaryButton(
                            text: 'Submit complaint',
                            icon: Icons.send,
                            onPressed: submit,
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
