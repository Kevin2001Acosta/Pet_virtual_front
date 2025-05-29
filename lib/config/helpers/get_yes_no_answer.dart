import 'package:dio/dio.dart';
import 'package:yes_no_app/config/constants.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:yes_no_app/infrastructure/models/ia_answer.dart';

class GetIAAnswer {
  final _dio = Dio();

  Future<Message> getAnswer(String text) async {
    final response =
        await _dio.post('$backendUrl/chatbot/chat', data: {'message': text});

    final ResponseIAModel responseIAModel =
        ResponseIAModel.fromJsonMap(response.data);

    return responseIAModel.toMessageEntity();
  }
}
