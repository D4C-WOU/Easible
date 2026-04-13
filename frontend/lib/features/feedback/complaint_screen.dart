import 'package:flutter/material.dart';
import '../../services/complaint_service.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/app_scaffold.dart';

class ComplaintScreen extends StatefulWidget {
  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final ctrl = TextEditingController();

  void submit() async {
    await ComplaintService.submit(ctrl.text);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Complaint Submitted")));

    ctrl.clear();
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
                decoration: const InputDecoration(labelText: "Enter complaint"),
              ),
              const SizedBox(height: 20),

              PrimaryButton(
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
