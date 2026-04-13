import 'package:flutter/material.dart';
import '../../services/location_service.dart';
import '../../services/panic_service.dart';
import '../../core/widgets/app_scaffold.dart';

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
    return AppScaffold(
      title: "🚨 Panic Mode",
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: facilities.length,
              itemBuilder: (_, i) {
                final f = facilities[i];

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
                    title: Text(f["name"]),
                    subtitle: Text("${f["type"]} • ${f["distance"]} km"),
                  ),
                );
              },
            ),
    );
  }
}
