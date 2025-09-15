import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class HerMessageBubble extends StatelessWidget {
  final Message message;
  const HerMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
   
    final backgroundColor = const Color.fromARGB(255, 218, 213, 204); 
    
    // Determinar si el fondo es oscuro o claro
    bool isDark(Color color) => color.computeLuminance() < 0.5;
    final textColor = isDark(backgroundColor) ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, 
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color.fromARGB(255, 218, 213, 204), 
            child: Text(
              '🐿️', // Emoji de ardilla
              style: TextStyle(fontSize: 14),
            ),
          ),
          
          const SizedBox(width: 8), 
          
          // Burbuja de mensaje
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7, 
              ),
              decoration: BoxDecoration(
                color: backgroundColor, 
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5), 
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20), 
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: message.fromWho == FromWho.typing
                    ? _buildTypingIndicator() // Mostrar puntos animados
                    : MarkdownWidget( // Mostrar mensaje normal
                        data: message.text,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        config: MarkdownConfig(
                          configs: [
                            PConfig(textStyle: TextStyle(
                              color: textColor,
                              fontSize: 16,
                            )),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para los puntos animados de "escribiendo"
  Widget _buildTypingIndicator() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TypingDot(delay: 0),
        SizedBox(width: 4),
        TypingDot(delay: 200),
        SizedBox(width: 4),
        TypingDot(delay: 400),
      ],
    );
  }
}

// Widget para los puntos animados (debes agregar esta clase)
class TypingDot extends StatefulWidget {
  final int delay;

  const TypingDot({super.key, required this.delay});

  @override
  State<TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<TypingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Iniciar animación con delay
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.grey, // Color de los puntos
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

/* 
class _ImageBubble extends StatelessWidget {
  final String imageUrl;

  const _ImageBubble({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        imageUrl,
        width: size.width * 0.5,
        fit: BoxFit.cover,
        height: 150,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
} */

// TODO: algo por hacer
//! cosas importantes
//? algo debe ser revisado o tengo una pregunta
//* algo es importante pero no necesita atencion inmediata
