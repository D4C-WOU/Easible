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
    try {
      final res = await CrowdService.getStatus();
      if (mounted) {
        setState(() => data = res);
      }
    } catch (e) {
      if (mounted) {
        setState(
          () => data = {
            "crowd_level": "N/A",
            "booked_slots": 0,
            "total_slots": 0,
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (data!.isEmpty) {
      return const Card(
        child: ListTile(title: Text("No crowd data available")),
      );
    }

    return Card(
      child: ListTile(
        title: Text("Crowd Level: ${data!["crowd_level"] ?? "N/A"}"),
        subtitle: Text(
          "${data!["booked_slots"] ?? 0}/${data!["total_slots"] ?? 0} slots booked",
        ),
      ),
    );
  }
}
