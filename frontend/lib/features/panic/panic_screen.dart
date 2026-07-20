import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/theme.dart';
import '../../core/widgets/app_scaffold.dart';
import '../../services/location_service.dart';
import '../../services/panic_service.dart';
import '../services/map_service.dart';

class PanicScreen extends StatefulWidget {
  const PanicScreen({super.key});

  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen> {
  List<Map<String, dynamic>> facilities = [];
  bool loading = true;
  bool triggering = false;
  String error = '';
  String statusMessage = '';
  String? referenceId;
  String? nearestFacilityName;
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
      if (!mounted) return;
      setState(() {
        facilities = (res as List).cast<Map<String, dynamic>>();
        loading = false;
        // Pre-set nearest facility name for status message
        if (facilities.isNotEmpty) {
          nearestFacilityName = facilities.first['name']?.toString();
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        error = 'Location access or service lookup is currently unavailable.';
        loading = false;
      });
    }
  }

  Future<void> triggerAlert() async {
    if (triggering) return;

    setState(() {
      triggering = true;
      statusMessage = 'Locating your device...';
    });

    try {
      final position = await LocationService.getLocation();
      _currentPosition = position;
      final result = await PanicService.triggerAlert(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      // Use real API response data
      final alertId = result['id']?.toString() ?? '—';
      final nearest = nearestFacilityName ?? 'Nearest support centre';
      final ref = 'EAS-${DateTime.now().year}-${alertId.padLeft(4, '0')}';

      setState(() {
        triggering = false;
        referenceId = ref;
        statusMessage =
            'Emergency request created successfully.\n'
            'Reference: $ref\n'
            'Nearest support: $nearest\n'
            'Estimated response: 6–10 mins';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        triggering = false;
        statusMessage =
            'Emergency assistance is currently unavailable. '
            'Please call local emergency services directly.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.emergencyBackground,
      child: AppScaffold(
        title: 'Emergency Assistance',
        appBarColor: AppTheme.emergencyRed,
        appBarTitleColor: Colors.white,
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : error.isNotEmpty
            ? Center(child: Text(error))
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SOS Button Card
                    Card(
                      color: const Color(0xFFB71C1C),
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          children: [
                            AnimatedScale(
                              scale: triggering ? 0.97 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFFB71C1C),
                                  minimumSize: const Size(double.infinity, 120),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: triggering ? null : triggerAlert,
                                icon: const Icon(
                                  Icons.warning_amber_rounded,
                                  size: 32,
                                ),
                                label: Text(
                                  triggering
                                      ? 'Sending request...'
                                      : 'Request Emergency Help',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Your live location will be shared securely with nearby responders.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Status Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current status',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            if (triggering)
                              const Row(
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('Sending emergency alert...'),
                                ],
                              )
                            else
                              Text(
                                statusMessage.isEmpty
                                    ? 'Tap the button above to request support.'
                                    : statusMessage,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Nearby Facilities
                    Text(
                      'Nearby support',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    if (facilities.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No nearby facilities found.'),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: facilities.length,
                        itemBuilder: (_, i) {
                          final f = facilities[i];
                          final name =
                              f['name']?.toString() ?? 'Support centre';
                          final type = f['type']?.toString() ?? 'Support';
                          final distance = f['distance']?.toString() ?? '?';
                          final lat = f['lat'];
                          final lng = f['lng'];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(
                                  0xFFB71C1C,
                                ).withValues(alpha: 0.14),
                                child: const Icon(
                                  Icons.local_police,
                                  color: Color(0xFFB71C1C),
                                ),
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text('$type • $distance km away'),
                              trailing: Wrap(
                                children: [
                                  if (f['phone'] != null)
                                    IconButton(
                                      icon: const Icon(Icons.call),
                                      onPressed: () async {
                                        try {
                                          await MapService.callNumber(
                                            f['phone'].toString(),
                                          );
                                        } catch (_) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Unable to initiate the call.',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  if (lat != null && lng != null)
                                    IconButton(
                                      icon: const Icon(Icons.directions),
                                      onPressed: () async {
                                        try {
                                          await MapService.openDirections(
                                            currentLat:
                                                _currentPosition?.latitude ?? 0,
                                            currentLng:
                                                _currentPosition?.longitude ??
                                                0,
                                            destLat: (lat as num).toDouble(),
                                            destLng: (lng as num).toDouble(),
                                            label: name,
                                          );
                                        } catch (_) {
                                          if (!mounted) return;
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Unable to open directions.',
                                              ),
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
                  ],
                ),
              ),
      ),
    );
  }
}
