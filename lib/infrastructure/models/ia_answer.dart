import 'package:yes_no_app/domain/entities/message.dart';

class ResponseIAModel {
  final String answer;

  ResponseIAModel({
    required this.answer,
  });

  factory ResponseIAModel.fromJsonMap(Map<String, dynamic> json) =>
      ResponseIAModel(answer: json["response"]);

  Map<String, dynamic> toJson() => {"answer": answer};

  Message toMessageEntity() => Message(text: answer, fromWho: FromWho.hers);
}
