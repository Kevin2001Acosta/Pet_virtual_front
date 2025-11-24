import 'package:flutter/material.dart';

class MessageFieldBox extends StatefulWidget {
  final ValueChanged<String> onValue;
  final bool enabled; 

  const MessageFieldBox({
    super.key,
    required this.onValue,
    this.enabled = true, 
  });

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

  void _sendMessage() {
    final textValue = textController.text.trim();
    if (textValue.isNotEmpty && widget.enabled) {
      textController.clear();
      widget.onValue(textValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: widget.enabled 
            ? const Color.fromARGB(255, 217, 3, 3)
            : Colors.grey[400]!, 
      ),
      borderRadius: BorderRadius.circular(30),
      gapPadding: 0,
    );

    final inputDecoration = InputDecoration(
      hintText: widget.enabled 
          ? 'Habla con tu mascota...' 
          : 'Esperando respuesta...', 
      hintStyle: TextStyle(
        color: widget.enabled ? Colors.grey[600] : Colors.grey[400],
        fontSize: 16,
      ),
      enabledBorder: outlineInputBorder,
      disabledBorder: outlineInputBorder, 
      focusedBorder: outlineInputBorder.copyWith(
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 217, 3, 3),
          width: 2,
        ),
      ),
      filled: true,
      fillColor: widget.enabled ? Colors.grey[50] : Colors.grey[100],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      suffixIcon: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: widget.enabled ? Colors.red : Colors.grey[400], 
          shape: BoxShape.circle,
        ),
        child: widget.enabled
            ? IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Color.fromARGB(255, 247, 245, 245),
                  size: 22,
                ),
                onPressed: _sendMessage,
              )
            : const Padding(
                padding: EdgeInsets.all(12),
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
      prefixIcon: Icon(
        Icons.pets,
        color: widget.enabled 
            ? const Color.fromARGB(255, 217, 3, 3)
            : Colors.grey[400],
        size: 24,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        onTapOutside: (event) => focusNode.unfocus(),
        focusNode: focusNode,
        controller: textController,
        enabled: widget.enabled, 
        decoration: inputDecoration,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        textCapitalization: TextCapitalization.sentences,
        maxLines: 3,
        minLines: 1,
        onFieldSubmitted: (value) {
          if (!widget.enabled) return; 
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