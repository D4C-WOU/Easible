import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Utility to open directions in Google Maps or Apple Maps
class MapService {
  /// Opens directions from [currentLat], [currentLng] to [destLat], [destLng].
  static Future<void> openDirections({
    required double currentLat,
    required double currentLng,
    required double destLat,
    required double destLng,
    String? label,
  }) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&origin=$currentLat,$currentLng&destination=$destLat,$destLng&travelmode=driving${label != null ? '&destination_place_id=$label' : ''}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Opens a tel: link to call the given [phoneNumber].
  static Future<void> callNumber(String phoneNumber) async {
    final url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
