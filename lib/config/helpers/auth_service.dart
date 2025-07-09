import 'package:dio/dio.dart';
import 'package:yes_no_app/config/constants.dart';
import 'package:yes_no_app/infrastructure/models/auth_model.dart';

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

  // Manejo de errores
  String _handleError(DioException e) {
    if (e.response != null) {
      final errorData = e.response?.data;
      
      if (errorData is Map && errorData.containsKey('detail')) {
        return errorData['detail'];
      } else if (errorData is String) {
        return errorData;
      }
      
      return 'Error en la petición: ${e.response?.statusCode}';
    }
    
    return 'Error de conexión: ${e.message}';
  }

}