import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../services/map_service.dart';
import '../../services/facility_service.dart';
import '../../services/requirement_service.dart';
import '../../models/facility_model.dart';

class FacilitiesListScreen extends StatefulWidget {
  final int categoryId;
  final String title;

  const FacilitiesListScreen({
    super.key,
    required this.categoryId,
    required this.title,
  });

  @override
  State<FacilitiesListScreen> createState() => _FacilitiesListScreenState();
}

class _FacilitiesListScreenState extends State<FacilitiesListScreen> {
  bool loading = true;

  List<Facility> facilities = [];
  List<Facility> filteredFacilities = [];

  String searchQuery = '';
  String? selectedState = 'ALL';
  List<String> states = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    try {
      final res = await FacilityService.getFacilities(widget.categoryId);

      final uniqueStates =
          res.map((e) => e.state).where((e) => e.isNotEmpty).toSet().toList()
            ..sort();

      if (mounted) {
        setState(() {
          facilities = res;
          filteredFacilities = res;
          states = uniqueStates;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          facilities = [];
          filteredFacilities = [];
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load facilities: $e')),
        );
      }
    }
  }

  void applyFilters() {
    List<Facility> temp = facilities;

    if (searchQuery.isNotEmpty) {
      temp = temp.where((f) {
        final name = f.name.toLowerCase();
        final city = f.city.toLowerCase();
        return name.contains(searchQuery.toLowerCase()) ||
            city.contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (selectedState != null &&
        selectedState!.isNotEmpty &&
        selectedState != 'ALL') {
      temp = temp.where((f) => f.state == selectedState).toList();
    }

    setState(() {
      filteredFacilities = temp;
    });
  }

  void _openBookingDialog() {
    final nameCtl = TextEditingController();
    final phoneCtl = TextEditingController();
    final timeCtl = TextEditingController();

    showDialog(
      context: context,
      builder: (dctx) {
        return AlertDialog(
          title: const Text('Request Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: phoneCtl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Mobile'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: timeCtl,
                decoration: const InputDecoration(
                  labelText: 'Preferred time (e.g. 10:00 AM)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Validate basic fields
                if (nameCtl.text.trim().isEmpty ||
                    phoneCtl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in your name and mobile.'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dctx);

                try {
                  await RequirementService.requestBooking(
                    widget.categoryId,
                    nameCtl.text.trim(),
                    phoneCtl.text.trim(),
                    timeCtl.text.trim(),
                  );
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking request sent successfully.'),
                      backgroundColor: Color(0xFF2E7D32),
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to send request: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: widget.title,
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : facilities.isEmpty
          ? const Center(child: Text('No facilities found'))
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search by name or city',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      searchQuery = val;
                      applyFilters();
                    },
                  ),
                ),

                // State filter
                DropdownButtonFormField<String>(
                  value: selectedState,
                  hint: const Text('Filter by State'),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: 'ALL',
                      child: Text('All States'),
                    ),
                    ...states.map(
                      (s) => DropdownMenuItem(value: s, child: Text(s)),
                    ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      selectedState = val;
                      applyFilters();
                    });
                  },
                ),

                const SizedBox(height: 10),

                // List
                Expanded(
                  child: filteredFacilities.isEmpty
                      ? const Center(
                          child: Text('No facilities match your search.'),
                        )
                      : RefreshIndicator(
                          onRefresh: () async => _load(),
                          child: ListView.builder(
                            itemCount: filteredFacilities.length,
                            itemBuilder: (_, i) {
                              final f = filteredFacilities[i];

                              final address = [
                                f.address,
                                f.city,
                                f.state,
                              ].where((e) => e.trim().isNotEmpty).join(', ');

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        f.name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 6),
                                      if (f.description.isNotEmpty)
                                        Text(
                                          f.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                      if (address.trim().isNotEmpty) ...[
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 14,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                address,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.map_outlined,
                                              size: 16,
                                            ),
                                            label: const Text('Navigate'),
                                            onPressed: () {
                                              MapService.openDirections(
                                                currentLat: 0,
                                                currentLng: 0,
                                                destLat: f.lat,
                                                destLng: f.lng,
                                                label: f.name,
                                              );
                                            },
                                          ),
                                          ElevatedButton.icon(
                                            icon: const Icon(
                                              Icons.call,
                                              size: 16,
                                            ),
                                            label: const Text('Call'),
                                            onPressed: f.phone.isEmpty
                                                ? null
                                                : () => MapService.callNumber(
                                                    f.phone,
                                                  ),
                                          ),
                                        ],
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
