import 'dart:convert';
import 'package:http/http.dart' as http;

class PanicService {
  static const baseUrl = "http://127.0.0.1:8000";

  static Future<List<dynamic>> getNearby(double lat, double lon) async {
    final res = await http.get(
      Uri.parse("$baseUrl/panic/nearby?lat=$lat&lon=$lon"),
    );

    return jsonDecode(res.body);
  }
}
