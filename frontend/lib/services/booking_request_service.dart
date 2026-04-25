import 'api_service.dart';

class BookingRequestService {
  static Future<List<dynamic>> fetchRequests() async {
    return await ApiService.get('/booking-requests/');
  }
}
