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
}
