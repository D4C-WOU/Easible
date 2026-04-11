import 'api_service.dart';

class CrowdService {
  static Future<Map<String, dynamic>> getStatus() async {
    return await ApiService.get("/crowd/");
  }
}
