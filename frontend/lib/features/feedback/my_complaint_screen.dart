import 'package:flutter/material.dart';
import '../../services/complaint_service.dart';

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

  Color getColor(String status) {
    return status == "resolved" ? Colors.green : Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Complaints")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : complaints.isEmpty
          ? const Center(child: Text("No complaints yet"))
          : ListView.builder(
              itemCount: complaints.length,
              itemBuilder: (_, i) {
                final c = complaints[i];

                return Card(
                  child: ListTile(
                    title: Text(c["message"]),
                    trailing: Text(
                      c["status"].toUpperCase(),
                      style: TextStyle(
                        color: getColor(c["status"]),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
