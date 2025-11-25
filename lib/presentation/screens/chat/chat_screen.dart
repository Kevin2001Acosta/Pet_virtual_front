import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/widgets/chat/her_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/chat/my_message_bubble.dart';
import 'package:yes_no_app/presentation/widgets/shared/message_field_box.dart';
import 'package:yes_no_app/presentation/screens/chat/mascota_animation.dart';
import '../../../domain/entities/message.dart';
import 'package:yes_no_app/config/helpers/auth_service.dart';

class ChatScreen extends StatelessWidget {
  final String token;
  const ChatScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(  
      builder: (context, chatProvider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(context, chatProvider), 
          body: _ChatView(token: token),
        );
      },
    );
  }

  void _showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Opción Cerrar Sesión
            ListTile(
              leading: Icon(
                Icons.exit_to_app_rounded,
                color: Color(0xFFF35449),
              ),
              title: Text(
                'Cerrar sesión',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              onTap: () {
                Navigator.pop(context); 
                _showLogoutDialog(context);
              },
            ),
            
            Divider(height: 1, color: Colors.grey[300]),
            
            // Opción Eliminar Cuenta
            ListTile(
              leading: Icon(
                Icons.delete_forever_rounded,
                color: Colors.red,
              ),
              title: Text(
                'Eliminar cuenta',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                Navigator.pop(context); 
                _showDeleteAccountDialog(context);
              },
            ),
            
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }


  /// AppBar 
  PreferredSizeWidget _buildAppBar(BuildContext context, ChatProvider chatProvider) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final toolbarHeight = isLandscape ? 90.0 : (isTablet ? 110.0 : 100.0);
    final avatarSize = isLandscape ? 50.0 : (isTablet ? 80.0 : 70.0);
    final titleFontSize = isTablet ? 24.0 : (isLandscape ? 16.0 : 20.0);
    final subtitleFontSize = isTablet ? 16.0 : (isLandscape ? 12.0 : 14.0);
    final iconSize = isTablet ? 22.0 : (isLandscape ? 18.0 : 20.0);
    final spacing = isTablet ? 16.0 : (isLandscape ? 10.0 : 12.0);

    return AppBar(
      backgroundColor: const Color(0xFFF35449),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: Container(
          padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Icon(
            Icons.menu_rounded,
            color: Colors.white,
            size: iconSize,
          ),
        ),
        tooltip: 'Menú de opciones',
        onPressed: () => _showMenuOptions(context),
      ),
      title: _buildAppBarContent(
        context,
        chatProvider,
        avatarSize,
        titleFontSize,
        subtitleFontSize,
        spacing,
        isTablet,
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.only(right: isTablet ? 12.0 : 8.0),
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(isTablet ? 12.0 : 10.0),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.favorite_rounded,
                color: Colors.white,
                size: iconSize * 1.3,
              ),
            ),
            tooltip: 'Bienestar emocional',
            onPressed: () {
              Navigator.pushNamed(context, '/emotional_wellness');
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppBarContent(
    BuildContext context,
    ChatProvider chatProvider,
    double avatarSize,
    double titleFontSize,
    double subtitleFontSize,
    double spacing,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pets_rounded,
              color: Colors.white,
              size: titleFontSize * 1.2,
            ),
            SizedBox(width: 8),
            Text(
              chatProvider.petName,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withValues(alpha: 0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            SizedBox(width: 6),
            Text(
              'En línea',
              style: TextStyle(
                fontSize: subtitleFontSize,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.95),
              ),
            ),
          ],
        ),
      ],
    );
  }

void _showDeleteAccountDialog(BuildContext context) {
  final rootNavigator = Navigator.of(context, rootNavigator: true);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.delete_forever, color: Colors.red),
          SizedBox(width: 8),
          Text('Eliminar cuenta'),
        ],
      ),
      content: Text('¿Estás seguro de que quieres eliminar tu cuenta permanentemente? Esta acción no se puede deshacer y se perderán todos tus datos.'),
      actions: [
        TextButton(
          onPressed: () => rootNavigator.pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () async {
            rootNavigator.pop(); 
            try {
              // Mostrar loading
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => Center(
                  child: CircularProgressIndicator(color: Color(0xFFF35449)),
                ),
              );
              final authService = AuthService();
              final result = await authService.deleteAccount();
              rootNavigator.pop();
              
              if (result['success'] == true) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result['message'] ?? 'Cuenta eliminada exitosamente'),
                    backgroundColor: Colors.green,
                  ),
                );
                rootNavigator.pushNamedAndRemoveUntil('/login', (route) => false);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(result['error'] ?? 'Error al eliminar la cuenta'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } catch (e) {
              if (rootNavigator.canPop()) rootNavigator.pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
              );
            }
          },
          child: Text('Eliminar cuenta'),
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
  );
}


  void _showLogoutDialog(BuildContext context) {
  final rootNavigator = Navigator.of(context, rootNavigator: true);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          Icon(Icons.exit_to_app, color: Color(0xFFF35449)),
          SizedBox(width: 8),
          Text('Cerrar sesión'),
        ],
      ),
      content: Text('¿Estás seguro de que quieres cerrar sesión?'),
      actions: [
        TextButton(
          onPressed: () {
            rootNavigator.pop();
          },
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFF35449),
          ),
          onPressed: () {
            rootNavigator.pop();
          
            Future.delayed(Duration.zero, () async {
              try {
                final authService = AuthService();
                await authService.logout();
                
                // Navegar al login
                rootNavigator.pushNamedAndRemoveUntil(
                  '/login', 
                  (route) => false
                );
                
              } catch (e) {
                
                rootNavigator.pushNamedAndRemoveUntil(
                  '/login', 
                  (route) => false
                );
              }
            });
          },
          child: Text('Cerrar sesión'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
}

class _ChatView extends StatefulWidget {
  final String token;
  const _ChatView({required this.token});

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  bool _loading = true;
  bool _sessionExpiredDialogShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMessages();
    });
  }

  Future<void> _loadMessages() async {
    final chatProvider = context.read<ChatProvider>();
    await chatProvider.loadMessages(widget.token);

    if (mounted && chatProvider.sessionExpired && !_sessionExpiredDialogShown) {
      _showSessionExpiredDialog();
    } else if (mounted) {
      setState(() => _loading = false);
    }
  }
  
  void _showSessionExpiredDialog() {
    _sessionExpiredDialogShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.access_time, color: Colors.orange, size: 28),
            SizedBox(width: 12),
            Text(
              'Sesión expirada',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Tu sesión ha expirado por seguridad. Por favor, inicia sesión nuevamente para continuar.',
            style: TextStyle(fontSize: 16, height: 1.4),
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF87070),
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); 
                Navigator.pushReplacementNamed(context, '/login'); 
              },
              child: Text(
                'Iniciar sesión',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        actionsPadding: EdgeInsets.fromLTRB(24, 0, 24, 20),
      ),
    );
  }

  /// Calcula tamaños responsive para la mascota
  double _getMascotaSize(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;

    if (isLandscape) {
      return (screenHeight * 0.25).clamp(80.0, 120.0);
    } else if (isTablet) {
      return 180;
    } else {
      return (screenWidth * 0.4).clamp(120.0, 160.0);
    }
  }

  /// Calcula padding responsive
  EdgeInsets _getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    if (isTablet) {
      return const EdgeInsets.all(20);
    } else if (isLandscape) {
      return const EdgeInsets.all(8);
    } else {
      return const EdgeInsets.all(16);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();

    if (chatProvider.sessionExpired) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }
    
    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final isTablet = screenWidth > 600;

    final maxWidth = isTablet ? 800.0 : screenWidth;

    return Container(
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              // Mascota animada
              Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  final mascotaSize = _getMascotaSize(context);
                  final padding = _getResponsivePadding(context);
                  return Container(
                    padding: padding,
                    child: Column(
                      children: [
                        Container(
                          height: mascotaSize + 40,
                          width: mascotaSize + 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.red,
                              width: isTablet ? 4 : 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: isTablet ? 12 : 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: MascotaAnimation(
                              isSpeaking: chatProvider.isLoading,
                              currentEmotion: chatProvider.currentEmotion,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Chat
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 10),
                  child: Column(
                    children: [
                      Expanded(
                        child: _loading
                            ? Center(
                                child: CircularProgressIndicator(
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Color(0xFFF87070),
                                  ),
                                  strokeWidth: isTablet ? 3 : 2,
                                ),
                              )
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

                      // Campo de texto
                      Container(
                        margin: EdgeInsets.only(
                          bottom: isTablet ? 20 : 16,
                          top: isLandscape ? 8 : 16,
                        ),
                        child: MessageFieldBox(
                          onValue: (value) =>
                              chatProvider.sendMessage(value, widget.token),
                          enabled: !chatProvider.isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}