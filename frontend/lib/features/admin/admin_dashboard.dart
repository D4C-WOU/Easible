import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic> stats = {
    'confirmed_bookings': '—',
    'open_complaints': '—',
    'panic_alerts': '—',
    'pending_requests': '—',
  };
  bool loadingStats = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final res = await ApiService.getWithAuth('/admin/stats');
      if (!mounted) return;
      setState(() {
        stats = {
          'confirmed_bookings': res['confirmed_bookings']?.toString() ?? '0',
          'open_complaints': res['open_complaints']?.toString() ?? '0',
          'panic_alerts': res['panic_alerts']?.toString() ?? '0',
          'pending_requests': res['pending_requests']?.toString() ?? '0',
        };
        loadingStats = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loadingStats = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = <_AdminCard>[
      _AdminCard(
        'Confirmed Bookings',
        stats['confirmed_bookings'].toString(),
        Icons.calendar_today,
        '/admin/bookings/confirmed',
        const Color(0xFF0F4C81),
      ),
      _AdminCard(
        'Open Complaints',
        stats['open_complaints'].toString(),
        Icons.report_problem,
        '/admin/complaints',
        const Color(0xFFF9A825),
      ),
      _AdminCard(
        'Emergency Alerts',
        stats['panic_alerts'].toString(),
        Icons.warning_amber_rounded,
        '/admin/panic-alerts',
        const Color(0xFFD32F2F),
      ),
      _AdminCard(
        'Pending Requests',
        stats['pending_requests'].toString(),
        Icons.pending_actions,
        '/admin/booking-requests',
        const Color(0xFF2E7D32),
      ),
    ];

    return AppScaffold(
      title: 'Admin Command Center',
      actions: [
        if (loadingStats)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh stats',
          onPressed: () {
            setState(() => loadingStats = true);
            _loadStats();
          },
        ),
        IconButton(
          icon: const Icon(Icons.logout_outlined),
          tooltip: 'Logout',
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
                      'Operations Overview',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Monitor service demand, complaints, and emergency alerts '
                      'from one trusted control centre.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Live Stat Cards ──────────────────────────────────────────
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
              itemBuilder: (context, i) {
                final c = cards[i];
                return Card(
                  child: InkWell(
                    onTap: () => context.go(c.route),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: c.color.withValues(alpha: 0.14),
                            child: Icon(c.icon, color: c.color),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            c.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 6),
                          loadingStats
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  c.value,
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: c.color,
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
            _Tile(
              'Appointment Management',
              Icons.event_available,
              '/admin/bookings',
            ),
            _Tile(
              'Create Service Slot',
              Icons.add_box_outlined,
              '/admin/create-slot',
            ),
            _Tile(
              'Booking Requests',
              Icons.pending_actions,
              '/admin/booking-requests',
            ),
            _Tile('Complaints', Icons.report_problem, '/admin/complaints'),
            _Tile(
              'Emergency Alerts',
              Icons.warning_amber_rounded,
              '/admin/panic-alerts',
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCard {
  final String title, value, route;
  final IconData icon;
  final Color color;
  const _AdminCard(this.title, this.value, this.icon, this.route, this.color);
}

class _Tile extends StatelessWidget {
  final String title, route;
  final IconData icon;
  const _Tile(this.title, this.icon, this.route, {super.key});

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
