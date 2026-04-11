import 'package:flutter/material.dart';
import '../../services/complaint_service.dart';

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
    return Scaffold(
      appBar: AppBar(title: const Text("Complaint Box")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: ctrl,
              maxLines: 4,
              decoration: const InputDecoration(labelText: "Enter complaint"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: submit, child: const Text("Submit")),
          ],
        ),
      ),
    );
  }
}
