import 'package:flutter/material.dart';

Future<bool> okDialog(BuildContext context, String title, String message) {
  return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text("OK"),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
