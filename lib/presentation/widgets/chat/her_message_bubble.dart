import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class HerMessageBubble extends StatelessWidget {
  final Message message;
  const HerMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
   
    final backgroundColor = Color.fromARGB(255, 218, 213, 204); 
    
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
                child: MarkdownWidget(
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
