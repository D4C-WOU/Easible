import 'package:jwt_decoder/jwt_decoder.dart';
import 'storage_service.dart';

class AuthService {
  static Future<String?> getRole() async {
    final token = await StorageService.getToken();

    if (token == null) return null;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return decodedToken["role"];
  }

  static Future<int?> getUserId() async {
    final token = await StorageService.getToken();

    if (token == null) return null;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return decodedToken["user_id"];
  }
}
