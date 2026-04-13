import 'package:flutter/material.dart';
import '../../services/complaint_service.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/app_scaffold.dart';

class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final ctrl = TextEditingController();
  bool isSubmitting = false;

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (ctrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a complaint")));
      return;
    }

    setState(() => isSubmitting = true);

    try {
      await ComplaintService.submit(ctrl.text);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Complaint Submitted")));
        ctrl.clear();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Complaint Box",
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: ctrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Enter complaint",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              isSubmitting
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      text: "Submit",
                      icon: Icons.send,
                      onPressed: submit,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
