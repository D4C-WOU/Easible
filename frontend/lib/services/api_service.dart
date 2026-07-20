import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

class ApiService {
  // FIX: removed /api suffix - FastAPI mounts routes at root, not under /api
  static String get baseUrl {
    if (kIsWeb) {
      return "http://127.0.0.1:8000";
    } else {
      return "http://10.0.2.2:8000";
    }
  }

  // PUBLIC GET
  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse("$baseUrl$endpoint");
    final response = await http.get(url);
    return _handleResponse(response);
  }

  // PUBLIC POST
  static Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final url = Uri.parse("$baseUrl$endpoint");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // AUTH GET
  static Future<dynamic> getWithAuth(String endpoint) async {
    final token = await StorageService.getToken();
    final url = Uri.parse("$baseUrl$endpoint");
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return _handleResponse(response);
  }

  // AUTH POST
  static Future<dynamic> postWithAuth(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    final token = await StorageService.getToken();
    final url = Uri.parse("$baseUrl$endpoint");
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(data),
    );
    return _handleResponse(response);
  }

  // AUTH PUT
  static Future<dynamic> putWithAuth(String endpoint) async {
    final token = await StorageService.getToken();
    final url = Uri.parse("$baseUrl$endpoint");
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return _handleResponse(response);
  }

  // AUTH DELETE
  static Future<dynamic> deleteWithAuth(String endpoint) async {
    final token = await StorageService.getToken();
    final url = Uri.parse("$baseUrl$endpoint");
    final response = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );
    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      final detail = decoded is Map ? decoded["detail"] : null;
      throw Exception(
        detail ?? "Something went wrong (${response.statusCode})",
      );
    }
  }
}
