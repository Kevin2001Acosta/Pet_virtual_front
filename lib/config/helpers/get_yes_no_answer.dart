import 'package:dio/dio.dart';
import 'package:yes_no_app/config/constants.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/infrastructure/models/ia_answer.dart';

class GetIAAnswer {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: backendUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<Message> getAnswer(String text, String email) async {
    final response = await _dio.post('/chatbot/chat', data: {
      'message': text,
      'email': email,
    });

    final ResponseIAModel responseIAModel =
        ResponseIAModel.fromJsonMap(response.data);

    return responseIAModel.toMessageEntity();
  }

  Future<List<Message>> getMessages(String email) async {
    final response = await _dio.get('/chatbot/chat/history', queryParameters: {
      'email': email,
    });

    List<dynamic> conversations = response.data;

    List<Message> messages = [];

    for (var conv in conversations) {
      // Mensaje del usuario
      messages.add(Message(
        text: conv['question'] ?? '',
        fromWho: FromWho.me,
      ));
      // Respuesta del bot
      messages.add(Message(
        text: conv['answer'] ?? '',
        imageUrl: conv['imageUrl'],
        fromWho: FromWho.hers,
      ));
    }
    return messages;
  }
}
