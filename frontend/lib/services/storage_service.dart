import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: "jwt", value: token);
    } catch (_) {
      // Ignore storage failures in test or unsupported environments.
    }
  }

  static Future<String?> getToken() async {
    try {
      return await _storage.read(key: "jwt");
    } catch (_) {
      return null;
    }
  }

  // ✅ Better version (clear only token)
  static Future<void> clearToken() async {
    try {
      await _storage.delete(key: "jwt");
    } catch (_) {
      // Ignore storage failures in test or unsupported environments.
    }
  }

  // (optional) clear everything
  static Future<void> clear() async {
    try {
      await _storage.deleteAll();
    } catch (_) {
      // Ignore storage failures in test or unsupported environments.
    }
  }
}
