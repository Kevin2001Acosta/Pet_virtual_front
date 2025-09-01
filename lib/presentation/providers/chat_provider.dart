import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/get_yes_no_answer.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final GetIAAnswer getIAAnswer = GetIAAnswer();

  List<Message> messageList = [];

  Future<void> sendMessage(String text, String email) async {
    if (text.isEmpty) return;
    final newMessage = Message(text: text, fromWho: FromWho.me);
    messageList.add(newMessage);

    herReply(text, email);

    notifyListeners();
    moveScrollToBottom();
  }

  // petición
  Future<void> herReply(String text, String email) async {
    final herMessage = await getIAAnswer.getAnswer(text, email);
    messageList.add(herMessage);
    print(herMessage.text); // ignore: avoid_print
    print(herMessage.imageUrl); // ignore: avoid_print
    notifyListeners();

    moveScrollToBottom();
  }

  Future<void> loadMessages(String email) async {
    // llama al backedn
    final messages = await getIAAnswer.getMessages(email);
    messageList = messages;
    notifyListeners();
    moveScrollToBottom();
  }

  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!chatScrollController.hasClients) return;
    chatScrollController.animateTo(
        chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }
}