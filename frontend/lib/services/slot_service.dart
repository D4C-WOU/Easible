import '../services/api_service.dart';

class SlotService {
  static Future<List<dynamic>> getSlots() async {
    return await ApiService.get("/slots/");
  }

  static Future<void> createSlot(Map<String, dynamic> data) async {
    await ApiService.postWithAuth("/slots/create", data);
  }

  static Future<void> deleteSlot(int slotId) async {
    await ApiService.deleteWithAuth("/slots/$slotId");
  }
}
