import 'package:flutter/material.dart';
import '../../services/complaint_service.dart';

class AdminComplaints extends StatefulWidget {
  @override
  State<AdminComplaints> createState() => _AdminComplaintsState();
}

class _AdminComplaintsState extends State<AdminComplaints> {
  List<dynamic> complaints = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final res = await ComplaintService.getAll();
    setState(() => complaints = res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaints")),
      body: ListView.builder(
        itemCount: complaints.length,
        itemBuilder: (_, i) {
          final c = complaints[i];
          return ListTile(
            title: Text(c["message"]),
            subtitle: Text("Status: ${c["status"]}"),
          );
        },
      ),
    );
  }
}
