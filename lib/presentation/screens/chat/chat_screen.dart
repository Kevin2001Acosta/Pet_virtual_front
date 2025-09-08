import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/widgets/chat/her_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/shared/message_field_box.dart';
import 'package:yes_no_app/presentation/screens/chat/mascota_animation.dart';
import '../../../domain/entities/message.dart';

class ChatScreen extends StatelessWidget {
  final String email;
  const ChatScreen({super.key, required this.email});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /*
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(0, 250, 2, 2),
            child: Image.asset(
              'assets/images/mascota.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        */
        
        title: const Text(
          'Mascota',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        
        centerTitle: true,
        elevation: 1, 
        backgroundColor: Color.fromARGB(255, 247, 38, 38)   ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMessages();
    });
  }

  Future<void> _loadMessages() async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.loadMessages(widget.email);
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    return SafeArea(
      child: Column(
        children: [
          // ANIMACIÓN MASCOTA
          /*
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                color: Colors.transparent,
                height: 250,
                //constraints: const BoxConstraints(maxHeight: 450), //Cambian el tamaño recuadro
                child: Center(
                  child: MascotaAnimation(
                    isSpeaking: chatProvider.isLoading,
                    size: 200//Tamaño animacion
                  ),
                ),
              );
            },
          ),
*/

Consumer<ChatProvider>(
  builder: (context, chatProvider, child) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration( // ¡Borde temporal para debug!
        border: Border.all(color: Colors.red, width: 2),
      ),
      height: 250,
      child: Center(
        child: MascotaAnimation(
          isSpeaking: chatProvider.isLoading,
          size: 200,
        ),
      ),
    );
  },
),

          // DIVIDER
          const Divider(
            height: 1,
            thickness: 1,
            color: Color.fromARGB(255, 209, 208, 208),
          ),

          // ÁREA DE CHAT 
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  // MENSAJES
                  Expanded(
                    child: _loading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            controller: chatProvider.chatScrollController,
                            itemCount: chatProvider.messageList.length,
                            itemBuilder: (context, index) {
                              final message = chatProvider.messageList[index];
                              return message.fromWho == FromWho.me
                                  ? MyMessageBubble(message: message)
                                  : HerMessageBubble(message: message);
                            },
                          ),
                  ),

                  // CAMPO DE TEXTO
                  MessageFieldBox(
                    onValue: (value) => 
                        chatProvider.sendMessage(value, widget.email),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}