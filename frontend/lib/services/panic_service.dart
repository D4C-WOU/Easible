import 'api_service.dart';

class PanicService {
  static Future<List<dynamic>> getNearby(double lat, double lon) async {
    final res = await ApiService.get("/panic/nearby?lat=$lat&lon=$lon");
    return res as List<dynamic>;
  }

  static Future<Map<String, dynamic>> triggerAlert(double lat, double lon) async {
    final res = await ApiService.postWithAuth("/panic/", {
      "latitude": lat,
      "longitude": lon,
    });
    return res as Map<String, dynamic>;
  }

  static Future<List<dynamic>> getAllAlerts() async {
    final res = await ApiService.getWithAuth("/panic/");
    return res as List<dynamic>;
  }
}
