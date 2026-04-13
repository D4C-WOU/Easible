import 'package:flutter/material.dart';
import '../../services/location_service.dart';
import '../../services/panic_service.dart';
import '../../core/widgets/app_scaffold.dart';

class PanicScreen extends StatefulWidget {
  const PanicScreen({super.key});

  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen> {
  List<Map<String, dynamic>> facilities = [];
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

      if (mounted) {
        setState(() {
          facilities = (res as List).cast<Map<String, dynamic>>();
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = "Location or API failed. Check permissions.";
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: "🚨 Panic Mode",
      scrollable: false,
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : facilities.isEmpty
          ? const Center(child: Text("No nearby facilities found"))
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: facilities.length,
              itemBuilder: (_, i) {
                final f = facilities[i];
                final name = f["name"]?.toString() ?? "Unknown";
                final type = f["type"]?.toString() ?? "Unknown";
                final distance = f["distance"]?.toString() ?? "?";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(blurRadius: 5, color: Colors.black12),
                    ],
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.local_hospital,
                      color: Colors.red,
                    ),
                    title: Text(name),
                    subtitle: Text("$type • $distance km"),
                  ),
                );
              },
            ),
    );
  }
}
