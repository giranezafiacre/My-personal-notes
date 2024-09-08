import 'package:flutter/material.dart';

Future<void> showErroDialog(
  BuildContext context,
  String errorMessage,
) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Error occured'),
        content: Text(errorMessage),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'))
        ],
      );
    },
  );
}
