import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/widgets/chat/her_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/shared/message_field_box.dart';

import '../../../domain/entities/message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://th.bing.com/th/id/R.6a2193a79bba1c2214b2d1ecdeca856b?rik=74%2fTKyxctg%2fCmA&riu=http%3a%2f%2fwww.blogerin.com%2fwp-content%2fuploads%2f2012%2f10%2fFotos-tiernas-de-perritos-wallpapers-2.jpg&ehk=2n7WA5Xz5SPLpcGw25Fh5QAQXVj7ywGhVORksb1OPE4%3d&risl=&pid=ImgRaw&r=0'),
          ),
        ),
        title: const Text('perrito :) '),
        centerTitle: true,
      ),
      body: _ChatView(),
    );
  }
}

class _ChatView extends StatelessWidget {
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
                onValue: (value) => chatProvider.sendMessage(value)),
          ],
        ),
      ),
    );
  }
}
