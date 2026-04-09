import 'package:flutter/material.dart';
import '../../services/location_service.dart';
import '../../services/panic_service.dart';

class PanicScreen extends StatefulWidget {
  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen> {
  List<dynamic> facilities = [];
  bool loading = true;
  String error = "";

  @override
  void initState() {
    super.initState();
    fetchNearby();
  }

  Future<void> fetchNearby() async {
    try {
      final position = await LocationService.getLocation();

      final res = await PanicService.getNearby(
        position.latitude,
        position.longitude,
      );

      setState(() {
        facilities = res;
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🚨 Panic Mode")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : ListView.builder(
              itemCount: facilities.length,
              itemBuilder: (_, i) {
                final f = facilities[i];
                return ListTile(
                  leading: const Icon(Icons.local_hospital),
                  title: Text(f["name"]),
                  subtitle: Text("${f["type"]} • ${f["distance"]} km"),
                );
              },
            ),
    );
  }
}
