import 'api_service.dart';

class ServiceService {
  static Future<List<dynamic>> getServices() async {
    return await ApiService.get("/services/");
  }
}
