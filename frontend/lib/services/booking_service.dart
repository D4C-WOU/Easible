import 'api_service.dart';

class BookingService {
  static Future<void> createBooking(int slotId) async {
    await ApiService.postWithAuth("/bookings/create", {"slot_id": slotId});
  }

  static Future<List<dynamic>> getBookings() async {
    return await ApiService.getWithAuth("/bookings/");
  }

  static Future<List<dynamic>> getMyBookings() async {
    return await ApiService.getWithAuth("/bookings/my");
  }

  static Future<void> updateBooking(int id, String status) async {
    await ApiService.putWithAuth("/bookings/$id?status=$status");
  }
}
