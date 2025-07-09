import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:yes_no_app/domain/entities/message.dart';

class HerMessageBubble extends StatelessWidget {
  final Message message;
  const HerMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final backgroundColor = colors.secondary;

    // Determinar si el fondo es oscuro o claro

    bool isDark(Color color) => color.computeLuminance() < 0.5;

    final textColor = isDark(backgroundColor)
        ? Colors.white
        : Colors.black; // Color del texto según el fondo

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: MarkdownWidget(
              data: message.text,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              config: MarkdownConfig(
                configs: [
                  PConfig(textStyle: TextStyle(color: textColor)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
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
