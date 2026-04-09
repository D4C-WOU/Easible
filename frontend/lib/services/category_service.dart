import '../models/category_model.dart';
import 'api_service.dart';

class CategoryService {
  static Future<List<Category>> fetchCategories() async {
    final res = await ApiService.get("/categories/");

    return (res as List).map((e) => Category.fromJson(e)).toList();
  }
}
