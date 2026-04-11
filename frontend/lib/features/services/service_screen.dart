import 'package:flutter/material.dart';
import '../../services/service_service.dart';

class ServiceScreen extends StatefulWidget {
  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  List<dynamic> services = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final res = await ServiceService.getServices();
    setState(() => services = res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Service Requirements")),
      body: ListView.builder(
        itemCount: services.length,
        itemBuilder: (_, i) {
          final s = services[i];

          return Card(
            child: ListTile(
              title: Text(s["name"]),
              subtitle: Text("Docs: ${s["documents"]}"),
            ),
          );
        },
      ),
    );
  }
}
