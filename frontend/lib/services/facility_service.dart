import 'api_service.dart';
import '../models/facility_model.dart';

class FacilityService {
  /// Pass [categoryId] to filter by category.
  /// Omit or pass null to fetch ALL facilities (used by admin Create Slot dropdown).
  static Future<List<Facility>> getFacilities([int? categoryId]) async {
    final endpoint = (categoryId != null && categoryId > 0)
        ? "/facilities/?category_id=$categoryId"
        : "/facilities/";
    final response = await ApiService.get(endpoint);
    return (response as List).map((e) => Facility.fromJson(e)).toList();
  }
}
