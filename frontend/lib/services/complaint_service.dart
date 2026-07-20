import 'api_service.dart';

class ComplaintService {
  static Future<void> submit(String message, {int? facilityId}) async {
    final payload = <String, dynamic>{'message': message};
    if (facilityId != null) payload['facility_id'] = facilityId;
    await ApiService.postWithAuth('/complaints/', payload);
  }

  // Alias used by the new complaint screen
  static Future<void> submitWithFacility(String message, {int? facilityId}) =>
      submit(message, facilityId: facilityId);

  static Future<List<dynamic>> getAll() async {
    return await ApiService.getWithAuth('/complaints/');
  }

  static Future<List<dynamic>> getMyComplaints() async {
    return await ApiService.getWithAuth('/complaints/my');
  }

  static Future<void> update(int id, String status) async {
    await ApiService.putWithAuth('/complaints/$id?status=$status');
  }
}
