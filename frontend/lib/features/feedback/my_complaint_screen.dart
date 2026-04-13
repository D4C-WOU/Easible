import 'package:flutter/material.dart';
import '../../services/complaint_service.dart';
import '../../core/widgets/status_chip.dart';
import '../../core/widgets/app_scaffold.dart';

class MyComplaintsScreen extends StatefulWidget {
  @override
  State<MyComplaintsScreen> createState() => _MyComplaintsScreenState();
}

class _MyComplaintsScreenState extends State<MyComplaintsScreen> {
  List<dynamic> complaints = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final res = await ComplaintService.getMyComplaints();
    setState(() {
      complaints = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "My Complaints",
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : complaints.isEmpty
          ? const Center(child: Text("No complaints yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: complaints.length,
              itemBuilder: (_, i) {
                final c = complaints[i];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(blurRadius: 5, color: Colors.black12),
                    ],
                  ),
                  child: ListTile(
                    title: Text(c["message"]),
                    trailing: StatusChip(c["status"]),
                  ),
                );
              },
            ),
    );
  }
}
