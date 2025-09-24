import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/widgets/chat/her_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/shared/message_field_box.dart';
import 'package:yes_no_app/presentation/screens/chat/mascota_animation.dart';
import '../../../domain/entities/message.dart';
import 'package:yes_no_app/presentation/widgets/alert.dart';

class ChatScreen extends StatelessWidget {
  final String email;
  const ChatScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: _buildAppBar(context), 
      body: _ChatView(email: email),
    );
  }

  // AppBar 
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 243, 84, 73),
      elevation: 3,
      leading: IconButton(
        icon: const Icon(Icons.exit_to_app, color: Color.fromARGB(255, 255, 254, 254)),
        onPressed: () {
          _showLogoutDialog(context);
        },
      ),
      centerTitle: true,
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.pets, color: Color.fromARGB(255, 254, 254, 254), size: 28),
          SizedBox(width: 12),
          Text(
            'Mascota Virtual',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color.fromARGB(255, 255, 254, 254),
            ),
          ),
        ],
      ),
    );
  }

  // Diálogo para confirmar cierre de sesión
void _showLogoutDialog(BuildContext context) {
  showInfoDialog(
    context: context,
    title: 'Cerrar sesión',
    message: '¿Estás seguro de que quieres cerrar sesión?',
    buttonText: 'Cancelar',
    onPressed: () {
    },
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

    return Container(
      color: Colors.white, 
      child: Column(
        children: [
          //Mascota animada
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.red, 
                            width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: MascotaAnimation(
                          isSpeaking: chatProvider.isLoading,
                          size: 160,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
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
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF87070)),
                            ),
                          )
                        : ListView.builder(
                            controller: chatProvider.chatScrollController,
                            itemCount: chatProvider.messageList.length,
                            itemBuilder: (context, index) {
                              if (index >= chatProvider.messageList.length) {
                                return const SizedBox.shrink(); 
                              }

                              final message = chatProvider.messageList[index];
                              return message.fromWho == FromWho.me
                                  ? MyMessageBubble(message: message)
                                  : HerMessageBubble(message: message);
                            },
                          ),
                  ),

                  // CAMPO DE TEXTO
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: MessageFieldBox(
                      onValue: (value) =>
                          chatProvider.sendMessage(value, widget.email),
                    ),
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