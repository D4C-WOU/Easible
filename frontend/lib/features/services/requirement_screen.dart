import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../services/requirement_service.dart';

class RequirementScreen extends StatefulWidget {
  const RequirementScreen({super.key});

  @override
  State<RequirementScreen> createState() => _RequirementScreenState();
}

class _RequirementScreenState extends State<RequirementScreen> {
  List<dynamic> requirements = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await RequirementService.getRequirements();
      if (!mounted) return;
      setState(() {
        requirements = res;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        requirements = [];
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Requirements',
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : requirements.isEmpty
          ? const Center(child: Text('No requirements found'))
          : ListView.builder(
              itemCount: requirements.length,
              itemBuilder: (_, i) {
                final r = requirements[i];
                final docs =
                    r['documents']?.toString() ??
                    'Please check with the nearest service centre.';
                final processingTime =
                    r['processing_time']?.toString() ?? 'Same day';
                final fees =
                    r['fees']?.toString() ?? 'Government fees may apply';
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r['name'] ?? 'Requirement',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          r['description'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF7FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Documents required',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(docs),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Chip(label: Text('Processing: $processingTime')),
                            Chip(label: Text('Fees: $fees')),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
