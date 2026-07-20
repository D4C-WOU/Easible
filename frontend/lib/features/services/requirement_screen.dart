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
  String error = '';
  String _search = '';

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
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _search.isEmpty
        ? requirements
        : requirements.where((r) {
            final name = r['name']?.toString().toLowerCase() ?? '';
            final desc = r['description']?.toString().toLowerCase() ?? '';
            final q = _search.toLowerCase();
            return name.contains(q) || desc.contains(q);
          }).toList();

    return AppScaffold(
      title: 'Service Requirements',
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(error, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        loading = true;
                        error = '';
                      });
                      load();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search services…',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onChanged: (v) => setState(() => _search = v),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No results for "$_search".',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: () async {
                            setState(() {
                              loading = true;
                              error = '';
                            });
                            await load();
                          },
                          child: ListView.builder(
                            itemCount: filtered.length,
                            itemBuilder: (_, i) {
                              final r = filtered[i];
                              final name = r['name']?.toString() ?? 'Service';
                              final description =
                                  r['description']?.toString() ?? '';
                              final documents =
                                  r['documents']?.toString() ??
                                  'Check with the nearest service centre.';

                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Service name
                                      Text(
                                        name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),

                                      // Description
                                      if (description.isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Text(
                                          description,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                      ],

                                      const SizedBox(height: 12),

                                      // Documents required
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEEF7FF),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Row(
                                              children: [
                                                Icon(
                                                  Icons.description_outlined,
                                                  size: 16,
                                                  color: Color(0xFF0F4C81),
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  'Documents Required',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Color(0xFF0F4C81),
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Wrap(
                                              spacing: 6,
                                              runSpacing: 4,
                                              children: documents
                                                  .split(',')
                                                  .map((d) => d.trim())
                                                  .where((d) => d.isNotEmpty)
                                                  .map(
                                                    (d) => Chip(
                                                      label: Text(
                                                        d,
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          Colors.white,
                                                      side: const BorderSide(
                                                        color: Color(
                                                          0xFFBDD5F0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
