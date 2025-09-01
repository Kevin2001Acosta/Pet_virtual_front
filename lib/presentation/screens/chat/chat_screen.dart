import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/widgets/chat/her_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/shared/message_field_box.dart';

import '../../../domain/entities/message.dart';

class ChatScreen extends StatelessWidget {
   final String email;
  const ChatScreen({super.key, required this.email});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Image.asset(
              'assets/images/mascota.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text('Mascota :)',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
         ),
        centerTitle: true,
        elevation: 2, 
        backgroundColor: Color.fromARGB(255, 247, 231, 231)
      ),
           body: _ChatView(email: email),
    );
  }
}

class _ChatView extends StatefulWidget {
  final String email;
  const _ChatView({required this.email});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.loadMessages(widget.email);
    if (mounted) setState(() => _loading = false);
  }

 
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              controller: chatProvider.chatScrollController,
              itemCount: chatProvider.messageList.length,
              itemBuilder: (context, index) {
                final message = chatProvider.messageList[index];

                return message.fromWho == FromWho.me
                    ? MyMessageBubble(
                        message: message,
                      )
                    : HerMessageBubble(
                        message: message,
                      );
              },
            )),
            MessageFieldBox(
                onValue: (value) =>
                    chatProvider.sendMessage(value, widget.email)),
          ],
        ),
      ),
    );
  }
}
