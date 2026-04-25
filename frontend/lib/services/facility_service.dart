import 'api_service.dart';

class FacilityService {
  static Future<List<dynamic>> getFacilities(int categoryId) async {
    return await ApiService.get("/facilities?category_id=$categoryId");
  }
}
