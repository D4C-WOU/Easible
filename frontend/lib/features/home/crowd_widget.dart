import 'package:flutter/material.dart';
import '../../services/crowd_service.dart';

class CrowdWidget extends StatefulWidget {
  @override
  State<CrowdWidget> createState() => _CrowdWidgetState();
}

class _CrowdWidgetState extends State<CrowdWidget> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final res = await CrowdService.getStatus();
    setState(() => data = res);
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) return const CircularProgressIndicator();

    return Card(
      child: ListTile(
        title: Text("Crowd Level: ${data!["crowd_level"]}"),
        subtitle: Text(
          "${data!["booked_slots"]}/${data!["total_slots"]} slots booked",
        ),
      ),
    );
  }
}
