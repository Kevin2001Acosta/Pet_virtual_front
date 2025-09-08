import 'package:dio/dio.dart';
import 'package:yes_no_app/config/constants.dart';
import 'package:yes_no_app/infrastructure/models/auth_model.dart';
import 'package:yes_no_app/infrastructure/models/forgotPassword_model.dart';

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
      print('Enviando datos de registro: ${user.toJson()}');
      final response = await _dio.post(
        '/users/register', 
        data: user.toJson(), 
      );
      print('Respuesta de registro: ${response.data}');
      return {
        'success': true,
        'data': response.data,
      };
    } on DioException catch (e) {
      print('Error en registro: ${e.response?.data ?? e.message}');
      return {
        'success': false,
        'error': _handleError(e),
      };
    }
  }

  // Iniciar sesión
  Future<Map<String, dynamic>> login(UserLogin user) async {
    try {
      print('Enviando datos de login: ${user.toJson()}');
      final response = await _dio.post(
        '/users/login',
        data: user.toJson(),
      );

      print('Respuesta de login: ${response.data}');

      return {
        'success': true,
        'data': response.data,
        'token': response.data['token'],
      };
    } on DioException catch (e) {
      print('Error en login: ${e.response?.data ?? e.message}');
      return {
        'success': false,
        'error': _handleError(e),
      };
    }
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
    print('Mensaje: ${e.message}');
    print('Response: ${e.response}');
    String errorMessage = 'Error desconocido';
    if (e.response != null && e.response!.statusCode == 404) {
      errorMessage = 'Usuario no encontrado con ese email';
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
    print('Error inesperado: $e');
    return {
      'success': false,
      'error': 'Error inesperado: $e',
    };
  }
}

//Cambiar contraseña
Future<Map<String, dynamic>> resetPassword(String password, String token) async {
  try {
    final requestData = {
      'password': password,
      'token': token 
    };
    final response = await _dio.post(
      '/auth/reset-password', 
      data: requestData,
    );
    if (response.statusCode == 200) {
      return {
        'success': true,
        'data': response.data
      };
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
    return {
      'success': false,
      'error': 'Error inesperado: ${e.toString()}'
    };
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
}