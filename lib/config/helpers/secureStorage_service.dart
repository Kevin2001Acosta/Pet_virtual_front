import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final _storage = FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userIdKey = 'user_id';

  // Guardar token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Obtener token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
 
  // Borrar token
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }


  // Guardar información del usuario
  static Future<void> saveUserInfo({
    required String email,
    required String name,
    required String userId,
  }) async {
    await Future.wait([
      _storage.write(key: _userEmailKey, value: email),
      _storage.write(key: _userNameKey, value: name),
      _storage.write(key: _userIdKey, value: userId),
    ]);
  }

  // Obtener información del usuario
  static Future<Map<String, String?>> getUserInfo() async {
    final results = await Future.wait([
      _storage.read(key: _userEmailKey),
      _storage.read(key: _userNameKey),
      _storage.read(key: _userIdKey),
    ]);

    return {
      'email': results[0],
      'name': results[1],
      'userId': results[2],
    };
  }

  // Eliminar todos los datos (logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Verificar si hay sesión activa
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}