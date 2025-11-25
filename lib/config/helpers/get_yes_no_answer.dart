import 'package:dio/dio.dart';
import 'package:yes_no_app/config/helpers/secure_storage_service.dart';
import 'package:yes_no_app/config/constants.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/infrastructure/models/ia_answer.dart';

class GetIAAnswer {
  late final Dio _dio;

  GetIAAnswer() {
    _dio = Dio(
      BaseOptions(
        baseUrl: backendUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            await SecureStorageService.deleteToken();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<Message> getAnswer(String text, String token) async {
    final response = await _dio.post(
      '/chatbot/chat',
      data: {'message': text},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final ResponseIAModel responseIAModel = ResponseIAModel.fromJsonMap(
      response.data,
    );
    return responseIAModel.toMessageEntity();
  }

  Future<Map<String, dynamic>> getMessages(String token) async { 
    final response = await _dio.get(
      '/chatbot/chat/history',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    Map<String, dynamic> data = response.data;
    List<dynamic> conversations = data['history'];
    String petName = data['pet_name'] ?? 'Mascota Virtual';

    List<Message> messages = [];

    for (var conv in conversations) {
      // Mensaje del usuario
      messages.add(
        Message(
          text: conv['question'] ?? '',
          emotion: 'respirar',
          fromWho: FromWho.me,
        ),
      );
      // Respuesta del bot
      messages.add(
        Message(
          text: conv['answer'] ?? '',
          imageUrl: conv['imageUrl'],
          emotion: conv['emotion'] ?? 'respirar',
          fromWho: FromWho.hers,
        ),
      );
    }
   return {
      'messages': messages,
      'petName': petName,
    };
  } 
}



