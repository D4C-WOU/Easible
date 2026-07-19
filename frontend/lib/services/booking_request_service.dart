import 'api_service.dart';

class BookingRequestService {
  static Future<List<dynamic>> fetchRequests() async {
    final res = await ApiService.getWithAuth('/booking-requests/');
    return res as List<dynamic>;
  }

  static Future<Map<String, dynamic>> updateStatus(int id, String status) async {
    final res = await ApiService.putWithAuth('/booking-requests/$id?status=$status');
    return res as Map<String, dynamic>;
  }
}
