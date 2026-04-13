import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip(this.status, {super.key}); // ✅ add key

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status.toLowerCase()) {
      // ✅ safer comparison
      case "accepted":
      case "resolved":
        color = Colors.green;
        break;
      case "rejected":
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}
