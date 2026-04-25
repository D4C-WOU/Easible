import 'api_service.dart';

class RequirementService {
  static Future<List<dynamic>> getRequirements() async {
    return await ApiService.get("/requirements/");
  }

  static Future<void> requestBooking(
    int categoryId,
    String name,
    String phone,
    String time,
  ) async {
    final payload = {
      'category_id': categoryId,
      'name': name,
      'phone': phone,
      'preferred_time': time,
    };

    await ApiService.post('/booking-requests/', payload).catchError((_) {});
  }
}
