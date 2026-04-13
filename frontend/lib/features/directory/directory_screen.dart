import 'package:flutter/material.dart';
import '../../services/category_service.dart';
import '../../models/category_model.dart';
import '../../services/map_service.dart';

class DirectoryScreen extends StatefulWidget {
  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  late Future<List<Category>> categories;

  @override
  void initState() {
    super.initState();
    categories = CategoryService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: categories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        }

        final data = snapshot.data!;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, index) {
            final item = data[index];
            return Card(
              child: ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                leading: const Icon(Icons.location_city),
                trailing: IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () {
                    MapService.openMap(19.0760, 72.8777);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
