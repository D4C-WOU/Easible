import 'package:url_launcher/url_launcher.dart';

/// Unified map & phone utility.
/// Use this file at lib/services/map_service.dart.
/// Delete lib/features/services/map_service.dart (the duplicate).
class MapService {
  static Future<void> openDirections({
    required double currentLat,
    required double currentLng,
    required double destLat,
    required double destLng,
    String? label,
  }) async {
    final dest = label != null
        ? Uri.encodeComponent(label)
        : "$destLat,$destLng";
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=$currentLat,$currentLng'
      '&destination=$destLat,$destLng'
      '&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open Google Maps');
    }
  }

  static Future<void> callNumber(String phoneNumber) async {
    final url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch phone dialer');
    }
  }

  static Future<void> openMap(double lat, double lng) async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Could not open map");
    }
  }
}
