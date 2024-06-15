import 'package:flutter/material.dart';

// display error message to user
void displayMessageToUser(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: MessageDialogContent(message: message),
    ),
  );
}

class MessageDialogContent extends StatelessWidget {
  final String message;

  const MessageDialogContent({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8.0),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
        const SizedBox(height: 20.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Column(
            children: [
              Divider(
                color: Colors.grey.shade400,
                height: 1.0,
                thickness: 1.0,
                indent: 20.0,
                endIndent: 20.0,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
