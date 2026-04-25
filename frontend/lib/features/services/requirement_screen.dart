import 'package:flutter/material.dart';
import '../../services/requirement_service.dart';
import '../../core/widgets/app_scaffold.dart';

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

  void load() async {
    final res = await RequirementService.getRequirements();

    setState(() {
      requirements = res;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "Requirements",
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : requirements.isEmpty
          ? const Center(child: Text("No requirements found"))
          : ListView.builder(
              itemCount: requirements.length,
              itemBuilder: (_, i) {
                final r = requirements[i];

                return Card(
                  child: ListTile(
                    title: Text(r["name"] ?? "Requirement"),
                    subtitle: Text(r["description"] ?? ""),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(r["name"] ?? ""),
                          content: Text(
                            "Documents Required:\n${r["documents"] ?? "N/A"}",
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
