// utils/alert_utils.dart
import 'package:flutter/material.dart';

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
