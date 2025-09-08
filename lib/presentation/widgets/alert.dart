import 'package:flutter/material.dart';

// Diálogo de Error
void showErrorDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Color.fromARGB(255, 229, 47, 47)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(buttonText,
              style: const TextStyle(
                  color: Color.fromARGB(255, 229, 47, 47),
                  fontFamily: 'Poppins')),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}

// Diálogo de Éxito
void showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
  VoidCallback? onPressed,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Color.fromARGB(255, 46, 229, 47)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onPressed?.call();
          },
          child: Text(buttonText,
              style: const TextStyle(
                  color: Color.fromARGB(255, 46, 229, 47),
                  fontFamily: 'Poppins')),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}

// Diálogo de Información
void showInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'Entendido',
  VoidCallback? onPressed,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_rounded,
                color: Color.fromARGB(255, 47, 140, 229)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onPressed?.call();
          },
          child: Text(buttonText,
              style: const TextStyle(
                  color: Color.fromARGB(255, 47, 140, 229),
                  fontFamily: 'Poppins')),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}

// SnackBar de Éxito
void showSuccessSnackBar({
  required BuildContext context,
  required String message,
  Duration duration = const Duration(seconds: 4),
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
          ),
        ],
      ),
      duration: duration,
      backgroundColor: const Color.fromARGB(255, 46, 229, 47),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

