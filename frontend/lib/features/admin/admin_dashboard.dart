import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../services/storage_service.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = <_AdminAction>[
      const _AdminAction(
        'Appointments Today',
        '14',
        Icons.calendar_today,
        '/admin/bookings',
        Color(0xFF0F4C81),
      ),
      const _AdminAction(
        'Open Complaints',
        '8',
        Icons.report_problem,
        '/admin/complaints',
        Color(0xFFF9A825),
      ),
      const _AdminAction(
        'Emergency Alerts',
        '3',
        Icons.warning_amber_rounded,
        '/admin/panic-alerts',
        Color(0xFFD32F2F),
      ),
      const _AdminAction(
        'Pending Requests',
        '6',
        Icons.pending_actions,
        '/admin/booking-requests',
        Color(0xFF2E7D32),
      ),
    ];

    return AppScaffold(
      title: 'Admin Command Center',
      actions: [
        IconButton(
          icon: const Icon(Icons.logout_outlined),
          onPressed: () async {
            await StorageService.clearToken();
            if (!context.mounted) return;
            context.go('/login');
          },
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Operations overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Monitor service demand, appointment flow, and response readiness from one trusted control center.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.08,
              ),
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  child: InkWell(
                    onTap: () => context.go(card.route),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: card.color.withValues(alpha: 0.14),
                            child: Icon(card.icon, color: card.color),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            card.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            card.value,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text('Management', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _AdminTile(
              'Appointment Management',
              Icons.event_available,
              '/admin/bookings',
            ),
            _AdminTile(
              'Facility Management',
              Icons.location_city,
              '/admin/create-slot',
            ),
            _AdminTile(
              'Booking Requests',
              Icons.pending_actions,
              '/admin/booking-requests',
            ),
            _AdminTile('Complaints', Icons.report_problem, '/admin/complaints'),
            _AdminTile(
              'Emergency Alerts',
              Icons.warning_amber_rounded,
              '/admin/panic-alerts',
            ),
            _AdminTile(
              'Analytics',
              Icons.analytics_outlined,
              '/admin/bookings',
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminAction {
  final String title;
  final String value;
  final IconData icon;
  final String route;
  final Color color;
  const _AdminAction(this.title, this.value, this.icon, this.route, this.color);
}

class _AdminTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String route;
  const _AdminTile(this.title, this.icon, this.route, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF0F4C81).withValues(alpha: 0.12),
          child: Icon(icon, color: const Color(0xFF0F4C81)),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.go(route),
      ),
    );
  }
}
