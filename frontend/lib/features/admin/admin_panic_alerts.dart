import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../services/panic_service.dart';

class AdminPanicAlertsScreen extends StatefulWidget {
  const AdminPanicAlertsScreen({super.key});

  @override
  State<AdminPanicAlertsScreen> createState() => _AdminPanicAlertsScreenState();
}

class _AdminPanicAlertsScreenState extends State<AdminPanicAlertsScreen> {
  late Future<List<dynamic>> _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = PanicService.getAllAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Emergency Alerts',
      child: FutureBuilder<List<dynamic>>(
        future: _alerts,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }

          final list = snap.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('No panic alerts yet'));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final alert = Map<String, dynamic>.from(list[index] as Map);
              final createdAt = alert['created_at']?.toString() ?? 'Unknown';

              return Card(
                color: Colors.red.shade50,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(alert['user_name']?.toString() ?? 'Unknown user'),
                  subtitle: Text(
                    '${alert['user_email'] ?? ''}\n${createdAt}\nLat: ${alert['latitude']}, Lng: ${alert['longitude']}',
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
