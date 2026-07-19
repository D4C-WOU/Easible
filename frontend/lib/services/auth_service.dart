import 'package:jwt_decoder/jwt_decoder.dart';
import 'storage_service.dart';

class AuthService {
  static Future<String?> getRole() async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) return null;

      final decodedToken = JwtDecoder.decode(token);
      return decodedToken["role"]?.toString();
    } catch (_) {
      return null;
    }
  }

  static Future<int?> getUserId() async {
    try {
      final token = await StorageService.getToken();

      if (token == null || token.isEmpty) return null;

      final decodedToken = JwtDecoder.decode(token);
      final userId = decodedToken["user_id"];
      return userId is int ? userId : int.tryParse(userId.toString());
    } catch (_) {
      return null;
    }
  }
}
