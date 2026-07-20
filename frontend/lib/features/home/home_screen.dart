import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../core/widgets/components/info_card.dart';
import '../../core/widgets/components/section_header.dart';
import '../../services/storage_service.dart';
import '../directory/directory_screen.dart';
import 'crowd_widget.dart';

String greeting() {
  final h = DateTime.now().hour;

  if (h < 12) return "Good Morning";
  if (h < 17) return "Good Afternoon";
  return "Good Evening";
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = <_HomeAction>[
      const _HomeAction(
        'Book Appointment',
        Icons.calendar_today,
        '/slots',
        Color(0xFF0F4C81),
      ),
      const _HomeAction(
        'Requirements',
        Icons.description_outlined,
        '/requirements',
        Color(0xFF1E88E5),
      ),
      const _HomeAction(
        'Complaints',
        Icons.report_problem_outlined,
        '/complaint',
        Color(0xFFF9A825),
      ),
      const _HomeAction(
        'My Bookings',
        Icons.history_edu,
        '/my-bookings',
        Color(0xFF2E7D32),
      ),
      const _HomeAction(
        'Directory',
        Icons.explore_outlined,
        '/directory',
        Color(0xFF1565C0),
      ),
      const _HomeAction(
        'Emergency',
        Icons.warning_amber_rounded,
        '/panic',
        Color(0xFFD32F2F),
      ),
    ];

    return AppScaffold(
      title: 'Citizen Dashboard',
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
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(
                        0xFF0F4C81,
                      ).withValues(alpha: 0.12),
                      child: const Icon(
                        Icons.account_balance,
                        color: Color(0xFF0F4C81),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${greeting()}, Citizen"),
                          const SizedBox(height: 4),
                          Text(
                            'Plan visits, check queue status, and reach the right public office without extra trips.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFFEEF7FF),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.today, color: Color(0xFF1E88E5), size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today’s overview',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Browse services, book appointments and submit complaints from one place.",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => context.go('/panic'),
                icon: const Icon(Icons.warning_amber_rounded),
                label: const Text('Request Emergency Assistance'),
              ),
            ),
            const SizedBox(height: 14),
            const SectionHeader(
              title: 'Crowd and wait time',
              subtitle: 'See what service demand looks like before you travel.',
            ),
            const SizedBox(height: 8),
            CrowdWidget(),
            const SizedBox(height: 16),
            const SectionHeader(
              title: 'Quick access',
              subtitle: 'Jump to the service you need next.',
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: actions.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.08,
              ),
              itemBuilder: (context, index) {
                final action = actions[index];
                return Card(
                  child: InkWell(
                    onTap: () => context.go(action.route),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: action.color.withValues(
                              alpha: 0.12,
                            ),
                            child: Icon(action.icon, color: action.color),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            action.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 18),
            const SectionHeader(
              title: 'Explore services',
              subtitle: 'Browse nearby public offices and departments.',
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 360, child: DirectoryScreen()),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _HomeAction {
  final String title;
  final IconData icon;
  final String route;
  final Color color;

  const _HomeAction(this.title, this.icon, this.route, this.color);
}
