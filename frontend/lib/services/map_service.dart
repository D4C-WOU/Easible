import 'package:url_launcher/url_launcher.dart';

class MapService {
  static Future<void> openMap(double lat, double lon) async {
    final url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$lat,$lon",
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception("Could not open map");
    }
  }

  static Future<void> openDirections({
    required double currentLat,
    required double currentLng,
    required double destLat,
    required double destLng,
    String? label,
  }) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$destLat,$destLng&travelmode=driving',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch directions');
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
}
