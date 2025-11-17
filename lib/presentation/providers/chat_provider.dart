import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/get_yes_no_answer.dart';
import 'package:yes_no_app/domain/entities/message.dart';
import 'package:dio/dio.dart';

class ChatProvider extends ChangeNotifier {
  final ScrollController chatScrollController = ScrollController();
  final GetIAAnswer getIAAnswer = GetIAAnswer();
  String _currentEmotion = 'respirar';
  bool _isLoading = false;
  String _petName = 'Mascota Virtual';
  bool _sessionExpired = false; 

  List<Message> messageList = [];

  bool get isLoading => _isLoading;
  String get currentEmotion => _currentEmotion;
  String get petName => _petName;
  bool get sessionExpired => _sessionExpired; 

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setEmotion(String emotion) {
    _currentEmotion = emotion;
    notifyListeners();
  }

  //Mostrar el escribiendo
  void _startTyping() {
    final typingMessage = Message(
      text: 'Escribiendo...',
      fromWho: FromWho.typing,
    );
    messageList.add(typingMessage);
    notifyListeners();
    moveScrollToBottom();
  }

  void _stopTyping() {
    if (messageList.isNotEmpty && messageList.last.fromWho == FromWho.typing) {
      messageList.removeLast();
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text, String token) async {
    if (text.isEmpty) return;

    final newMessage = Message(text: text, fromWho: FromWho.me);
    messageList.add(newMessage);

    notifyListeners();

    _setLoading(true);

    _startTyping();

    moveScrollToBottom();

    herReply(text, token);
  }

  Future<void> herReply(String text, String token) async {
    _setLoading(true);

    try {
      final herMessage = await getIAAnswer.getAnswer(text, token);
      _stopTyping();
      messageList.add(herMessage);
      setEmotion(herMessage.emotion);
      print(herMessage.text);
      print(herMessage.imageUrl);
    } on DioException catch (e) { 
      _stopTyping();

      if (e.response?.statusCode == 401) {
        _sessionExpired = true;
        messageList.add(
          Message(
            text: 'Tu sesión ha expirado. Redirigiendo al login...',
            fromWho: FromWho.hers,
            emotion: 'respirar',
          ),
        );
      } else {
        messageList.add(
          Message(
            text: '¡Ups! No pude responder. Error: ${e.message}',
            fromWho: FromWho.hers,
            emotion: 'respirar',
          ),
        );
      }
      setEmotion('respirar');
    } catch (e) {
      _stopTyping();
      messageList.add(
        Message(
          text: '¡Ups! No pude responder. Error: ${e.toString()}',
          fromWho: FromWho.hers,
          emotion: 'respirar',
        ),
      );
      setEmotion('respirar');
    } finally {
      _setLoading(false);
      notifyListeners();
      moveScrollToBottom();
    }
  }

  Future<void> loadMessages(String token) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setLoading(true);
    });

    try {
      final Map<String, dynamic> result = await getIAAnswer.getMessages(token);
      messageList = result['messages'] as List<Message>;
      _petName = result['petName'] as String? ?? 'Mascota Virtual';
      print('Pet name cargado: $_petName');
    } on DioException catch (e) { 
      if (e.response?.statusCode == 401) {
        _sessionExpired = true;
      }
      messageList.add(
        Message(
          text: 'Error cargando mensajes: ${e.message}',
          fromWho: FromWho.me,
        ),
      );
    } catch (e) {
      print('Error en loadMessages: $e');
      messageList.add(
        Message(
          text: 'Error cargando mensajes: ${e.toString()}',
          fromWho: FromWho.me,
        ),
      );
    } finally {
      _setLoading(false);
      notifyListeners();
      moveScrollToBottom();
    }
  }
  Future<void> moveScrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (!chatScrollController.hasClients) return;
    chatScrollController.animateTo(
      chatScrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    chatScrollController.dispose();
    super.dispose();
  }
}