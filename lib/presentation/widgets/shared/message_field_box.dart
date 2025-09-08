import 'package:flutter/material.dart';

class MessageFieldBox extends StatefulWidget {
  final ValueChanged<String> onValue;

  const MessageFieldBox({super.key, required this.onValue});

  @override
  State<MessageFieldBox> createState() => _MessageFieldBoxState();
}

class _MessageFieldBoxState extends State<MessageFieldBox> {
  final textController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final outlineInputBorder = OutlineInputBorder(
      borderSide: const BorderSide(
        color: Color.fromARGB(255, 217, 3, 3),
      ),
      borderRadius: BorderRadius.circular(30),
      gapPadding: 0,
    );

    final inputDecoration = InputDecoration(
      hintText: 'Pregúntale a tu mascota...',
      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 16),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder.copyWith(
        borderSide:
            const BorderSide(color: Color.fromARGB(255, 217, 3, 3), width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      suffixIcon: Container(
        margin: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: const Icon(Icons.send,
              color: Color.fromARGB(255, 217, 3, 3), size: 22),
          onPressed: () {
            final textValue = textController.text.trim();
            if (textValue.isNotEmpty) {
              textController.clear();
              widget.onValue(textValue);
            }
          },
        ),
      ),
      prefixIcon: const Icon(Icons.pets,
          color: Color.fromARGB(255, 217, 3, 3), size: 24),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        onTapOutside: (event) => focusNode.unfocus(),
        focusNode: focusNode,
        controller: textController,
        decoration: inputDecoration,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        textCapitalization: TextCapitalization.sentences,
        maxLines: 3,
        minLines: 1,
        onFieldSubmitted: (value) {
          final trimmedValue = value.trim();
          if (trimmedValue.isNotEmpty) {
            textController.clear();
            widget.onValue(trimmedValue);
          }
          focusNode.requestFocus();
        },
      ),
    );
  }
}
