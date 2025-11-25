import 'package:dio/dio.dart';
import 'package:yes_no_app/config/constants.dart';
import 'package:yes_no_app/infrastructure/models/auth_model.dart';
import 'package:yes_no_app/config/helpers/secure_storage_service.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: backendUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Registro de un usuario
  Future<Map<String, dynamic>> register(UserRegister user) async {
    try {
      final response = await _dio.post(
        '/users/register',
        data: user.toJson(),
      );
      return {
        'success': true,
        'data': response.data,
        'message': response.data['message'],
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'error': _handleError(e),
      };
    }
  }

  // Iniciar sesión
  Future<Map<String, dynamic>> login(UserLogin user) async {
    try {
      final response = await _dio.post(
        '/users/login',
        data: user.toJson(),
      );

      if (response.data['token'] != null) {
        await SecureStorageService.saveToken(response.data['token']);
        await SecureStorageService.saveUserInfo(
          email: response.data['user']['email'],
          name: response.data['user']['name'],
          userId: response.data['user']['id'].toString(),
          fechaInscripcion: response.data['user']['create_at'],
        );
      }

      return {
        'success': true,
        'data': response.data,
        'token': response.data['token'],
      };
    } on DioException catch (e) {
  
      return {
        'success': false,
        'error': _handleError(e),
      };
    }
  }

  // Método para logout
  Future<void> logout() async {
    await SecureStorageService.clearAll();
  }

  // Verificar autenticación
  Future<bool> isAuthenticated() async {
    return await SecureStorageService.isLoggedIn();
  }

  //  Obtener token actual
  Future<String?> getCurrentToken() async {
    return await SecureStorageService.getToken();
  }

  // Enviar correo de recuperacion de contraseña
  Future<Map<String, dynamic>> sendPasswordResetLink(String email) async {
    try {
      final response = await _dio.post(
        '/users/forgot-password',
        data: {'email': email},
      );

      return {
        'success': true,
        'message': response.data['message'] ?? 'Correo enviado exitosamente',
      };
    } on DioException catch (e) {
      String errorMessage = 'Error desconocido';
      if (e.response != null) {
        if (e.response?.statusCode == 404) {
        errorMessage = 'Usuario no encontrado con ese email';
      }
    } else if (e.response?.data != null && e.response?.data is Map) {
        errorMessage = e.response?.data['detail'] ??
            e.response?.data['message'] ??
            e.response?.data['error'] ??
            _handleError(e);
      } else {
        errorMessage = _handleError(e);
      }
      return {
        'success': false,
        'error': errorMessage,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Error inesperado: $e',
      };
    }
  }

  // Cambiar contraseña
  Future<Map<String, dynamic>> resetPassword(
      String password, String token) async {
    try {
      final requestData = {'new_password': password, 'token': token};
      final response = await _dio.put(
        '/users/reset-password',
        data: requestData,
      );
      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data};
      } else {
        return {
          'success': false,
          'error': response.data['message'] ?? 'Error desconocido'
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'error': e.response?.data['message'] ?? 'Error de conexión'
      };
    } catch (e) {
      return {'success': false, 'error': 'Error inesperado: ${e.toString()}'};
    }
  }

  // Manejo de errores
  String _handleError(DioException e) {
    if (e.response != null) {
      final errorData = e.response?.data;

      if (errorData is Map && errorData.containsKey('detail')) {
        return errorData['detail'];
      } else if (errorData is Map && errorData.containsKey('message')) {
        return errorData['message'];
      } else if (errorData is String) {
        return errorData;
      }
      return 'Error en la petición: ${e.response?.statusCode}';
    }

    return 'Error de conexión: ${e.message}';
  }


// Eliminar cuenta permanentemente
Future<Map<String, dynamic>> deleteAccount() async {
  try {
    final token = await SecureStorageService.getToken();
    
    if (token == null) {
      return {
        'success': false,
        'error': 'No hay sesión activa'
      };
    }

       final response = await _dio.delete( 
      '/users/delete-account',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.data['success'] == true) {
      // Limpiar datos locales
      await SecureStorageService.clearAll();
      return {
        'success': true,
        'message': 'Cuenta eliminada exitosamente'
      };
    } else {
      return {
        'success': false,
        'error': response.data['message'] ?? 'Error al eliminar la cuenta'
      };
    }
  } on DioException catch (e) {    
    String errorMessage = 'Error de conexión';
    if (e.response != null) {
      if (e.response!.statusCode == 401) {
        errorMessage = 'Sesión expirada. Por favor inicia sesión nuevamente.';
      } else if (e.response!.statusCode == 404) {
        errorMessage = 'Usuario no encontrado';
      } else if (e.response!.data != null && e.response!.data is Map) {
        errorMessage = e.response!.data['message'] ?? 
                      e.response!.data['detail'] ?? 
                      e.response!.data['error'] ?? 
                      'Error al eliminar la cuenta';
      }
    }
    
    return {
      'success': false,
      'error': errorMessage
    };
  } catch (e) {
    return {
      'success': false,
      'error': 'Error inesperado: $e'
    };
  }
 }
}