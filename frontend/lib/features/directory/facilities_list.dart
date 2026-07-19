import 'package:flutter/material.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../services/map_service.dart';
import '../../services/facility_service.dart';
import '../../services/requirement_service.dart';

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

  List<dynamic> facilities = [];
  List<dynamic> filteredFacilities = [];

  String searchQuery = "";
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

      final uniqueStates = res
          .map((e) => e['state']?.toString() ?? '')
          .toSet()
          .toList();

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
      }
    }
  }

  void applyFilters() {
    List<dynamic> temp = facilities;

    // 🔍 Search
    if (searchQuery.isNotEmpty) {
      temp = temp.where((f) {
        final name = (f['name'] ?? '').toString().toLowerCase();
        final city = (f['city'] ?? '').toString().toLowerCase();

        return name.contains(searchQuery.toLowerCase()) ||
            city.contains(searchQuery.toLowerCase());
      }).toList();
    }

    // 🗂 State filter
    if (selectedState != null &&
        selectedState!.isNotEmpty &&
        selectedState != "ALL") {
      temp = temp.where((f) {
        return f['state'] == selectedState;
      }).toList();
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
                decoration: const InputDecoration(labelText: 'Mobile'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: timeCtl,
                decoration: const InputDecoration(labelText: 'Preferred time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                RequirementService.requestBooking(
                  widget.categoryId,
                  nameCtl.text,
                  phoneCtl.text,
                  timeCtl.text,
                );
                Navigator.pop(dctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Booking request sent.')),
                );
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
                // 🔍 SEARCH BAR
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search by name or city",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (val) {
                      searchQuery = val;
                      applyFilters();
                    },
                  ),
                ),

                // 🗂 STATE FILTER
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      canvasColor: Colors.white, // dropdown bg
                      highlightColor: Colors.grey.shade200, // tap/hover color
                      splashColor: Colors.transparent,
                      hoverColor: Colors.grey.shade100,
                      focusColor: Colors.grey.shade200, // ✅ FIXES selected blue
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedState,
                      hint: const Text("Filter by State"),
                      style: const TextStyle(color: Colors.black),

                      items: [
                        const DropdownMenuItem(
                          value: 'ALL',
                          child: Text('All'),
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

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // 📋 LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredFacilities.length,
                    itemBuilder: (_, i) {
                      final f = filteredFacilities[i];

                      final name = f['name'] ?? 'Unknown';
                      final desc = f['description'] ?? '';
                      final address =
                          "${f['address'] ?? ''}, ${f['city'] ?? ''}, ${f['state'] ?? ''}";

                      final lat = f['lat'];
                      final lng = f['lng'];
                      final phone = f['phone'];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 6),
                              if (desc.isNotEmpty) Text(desc),
                              if (address.trim().isNotEmpty) ...[
                                const SizedBox(height: 6),
                                Text(
                                  address,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      'Crowd: ${f['crowd_level'] ?? 'Moderate'}',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      'Wait: ${f['waiting_time'] ?? '25 min'}',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.map_outlined),
                                    label: const Text('Navigate'),
                                    onPressed: lat != null && lng != null
                                        ? () => MapService.openDirections(
                                            currentLat: 0,
                                            currentLng: 0,
                                            destLat: lat,
                                            destLng: lng,
                                            label: name,
                                          )
                                        : null,
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.call),
                                    label: const Text('Call'),
                                    onPressed: phone != null
                                        ? () => MapService.callNumber(
                                            phone.toString(),
                                          )
                                        : null,
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.calendar_today),
                                    label: const Text('Book'),
                                    onPressed: _openBookingDialog,
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
              ],
            ),
    );
  }
}
