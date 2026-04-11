import 'api_service.dart';

class ComplaintService {
  static Future<void> submit(String message) async {
    await ApiService.postWithAuth("/complaints/", {"message": message});
  }

  static Future<List<dynamic>> getAll() async {
    return await ApiService.getWithAuth("/complaints/");
  }
}
