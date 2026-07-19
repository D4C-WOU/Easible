import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/category_model.dart';
import '../../services/category_service.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});

  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  late Future<List<Category>> categories;
  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    categories = CategoryService.fetchCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _filter() {
    final q = _searchController.text.trim().toLowerCase();
    setState(() {
      _filteredCategories = _allCategories.where((c) {
        final matchesQuery =
            c.name.toLowerCase().contains(q) ||
            c.description.toLowerCase().contains(q);
        final matchesFilter =
            _selectedFilter == 'All' ||
            _serviceGroup(c.name) == _selectedFilter;
        return matchesQuery && matchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || snapshot.data == null) {
          return const Center(
            child: Text('Unable to load services right now.'),
          );
        }

        final data = snapshot.data!;
        if (_allCategories.isEmpty) {
          _allCategories = List.from(data);
          _filteredCategories = List.from(data);
        }

        return Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search services or departments',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onChanged: (_) {
                if (_debounce?.isActive ?? false) {
                  _debounce!.cancel();
                }
                _debounce = Timer(const Duration(milliseconds: 300), _filter);
              },
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    [
                          'All',
                          'Health',
                          'Security',
                          'Transport',
                          'Finance',
                          'Utilities',
                        ]
                        .map(
                          (filter) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ChoiceChip(
                              label: Text(filter),
                              selected: _selectedFilter == filter,
                              onSelected: (_) {
                                setState(() => _selectedFilter = filter);
                                _filter();
                              },
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _filteredCategories.isEmpty
                  ? const Center(child: Text('No services match your search.'))
                  : ListView.separated(
                      itemCount: _filteredCategories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final item = _filteredCategories[index];
                        final icon = _serviceIcon(item.name);
                        final group = _serviceGroup(item.name);
                        return Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(14),
                            leading: CircleAvatar(
                              backgroundColor: const Color(
                                0xFF0F4C81,
                              ).withValues(alpha: 0.12),
                              child: Icon(icon, color: const Color(0xFF0F4C81)),
                            ),
                            title: Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  item.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(group),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.access_time, size: 16),
                                    const SizedBox(width: 4),
                                    const Text('15 mins'),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              context.go(
                                '/facilities/${item.id}?title=${Uri.encodeComponent(item.name)}',
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  String _serviceGroup(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('hospital') ||
        lower.contains('clinic') ||
        lower.contains('medical'))
      return 'Health';
    if (lower.contains('police') ||
        lower.contains('fire') ||
        lower.contains('security'))
      return 'Security';
    if (lower.contains('transport') ||
        lower.contains('driving') ||
        lower.contains('road'))
      return 'Transport';
    if (lower.contains('tax') ||
        lower.contains('revenue') ||
        lower.contains('income'))
      return 'Finance';
    if (lower.contains('water') ||
        lower.contains('electric') ||
        lower.contains('municipal'))
      return 'Utilities';
    return 'All';
  }

  IconData _serviceIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('passport')) return Icons.badge;
    if (lower.contains('aadhaar')) return Icons.fingerprint;
    if (lower.contains('transport')) return Icons.directions_car;
    if (lower.contains('hospital')) return Icons.local_hospital;
    if (lower.contains('police')) return Icons.local_police;
    if (lower.contains('fire')) return Icons.fire_truck;
    if (lower.contains('library')) return Icons.menu_book;
    if (lower.contains('employment')) return Icons.work;
    if (lower.contains('tax')) return Icons.account_balance_wallet;
    return Icons.business_center;
  }
}
