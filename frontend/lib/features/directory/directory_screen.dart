import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../services/category_service.dart';
import '../../models/category_model.dart';

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
      _filteredCategories = _allCategories
          .where((c) => c.name.toLowerCase().contains(q))
          .toList();
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
          return const Center(child: Text("Error loading data"));
        }

        final data = snapshot.data!;

        // initialize once
        if (_allCategories.isEmpty) {
          _allCategories = List.from(data);
          _filteredCategories = List.from(data);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 SEARCH BAR
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search services...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (_) {
                if (_debounce?.isActive ?? false) {
                  _debounce!.cancel();
                }

                _debounce = Timer(const Duration(milliseconds: 300), _filter);
              },
            ),

            const SizedBox(height: 12),

            // 📋 CATEGORY LIST
            SizedBox(
              height: 220,
              child: _filteredCategories.isEmpty
                  ? const Center(child: Text("No services found"))
                  : ListView.builder(
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        final item = _filteredCategories[index];

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: const Icon(Icons.location_city),
                            title: Text(item.name),
                            subtitle: Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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
}
