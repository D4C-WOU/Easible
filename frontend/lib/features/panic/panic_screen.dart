import 'package:flutter/material.dart';
import '../../services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme.dart';
import '../../services/panic_service.dart';
import '../../core/widgets/app_scaffold.dart';
import '../services/map_service.dart';

class PanicScreen extends StatefulWidget {
  const PanicScreen({super.key});

  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen> {
  List<Map<String, dynamic>> facilities = [];
  bool loading = true;
  String error = "";
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    fetchNearby();
  }

  Future<void> fetchNearby() async {
    try {
      final position = await LocationService.getLocation();
      _currentPosition = position;

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
    return Container(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFFFEBEE) // emergencyBackground
          : Colors.black,
      child: AppScaffold(
        title: "🚨 Panic Mode",
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
                  final lat = f["lat"];
                  final lng = f["lng"];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFCDD2), // lighter red
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(blurRadius: 5, color: Colors.black12),
                      ],
                      border: Border.all(color: Color(0xFFB71C1C), width: 2),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.local_hospital,
                        color: Color(0xFFB71C1C),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          color: Color(0xFFB71C1C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text("$type • $distance km"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (f["phone"] != null)
                            IconButton(
                              icon: const Icon(
                                Icons.call,
                                color: Color(0xFFB71C1C),
                              ),
                              tooltip: 'Call',
                              onPressed: () async {
                                try {
                                  await MapService.callNumber(
                                    f["phone"].toString(),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Could not start phone call',
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          if (lat != null && lng != null)
                            IconButton(
                              icon: const Icon(
                                Icons.directions,
                                color: Color(0xFFB71C1C),
                              ),
                              tooltip: 'Directions',
                              onPressed: () async {
                                try {
                                  final curLat =
                                      _currentPosition?.latitude ?? 0;
                                  final curLng =
                                      _currentPosition?.longitude ?? 0;
                                  await MapService.openDirections(
                                    currentLat: curLat,
                                    currentLng: curLng,
                                    destLat: lat,
                                    destLng: lng,
                                    label: name,
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Could not open maps'),
                                    ),
                                  );
                                }
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        appBarColor: AppTheme.emergencyRed,
        appBarTitleColor: Colors.white,
      ),
    );
  }
}
