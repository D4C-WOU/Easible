import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage();

  static Future<void> saveToken(String token) async {
    await _storage.write(key: "jwt", value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: "jwt");
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
