import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000"; // Android emulator

  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(response.body);
  }
}
