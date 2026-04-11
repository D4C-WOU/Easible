import 'api_service.dart';

class BookingService {
  static Future<void> createBooking(int slotId) async {
    await ApiService.postWithAuth("/bookings/create", {"slot_id": slotId});
  }

  static Future<List<dynamic>> getBookings() async {
    return await ApiService.getWithAuth("/bookings/");
  }

  static Future<void> updateBooking(int id, String status) async {
    await ApiService.postWithAuth("/bookings/$id?status=$status", {});
  }
}
