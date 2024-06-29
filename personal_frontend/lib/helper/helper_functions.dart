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

// Method to ensure a user created password meets strength requirements
bool isPasswordStrong(String password) {
  // Define the regex patterns
  final lengthPattern = RegExp(r'^.{8,}$'); // At least 8 characters
  final upperCasePattern = RegExp(r'^(?=.*[A-Z])'); // At least one uppercase letter
  final lowerCasePattern = RegExp(r'^(?=.*[a-z])'); // At least one lowercase letter
  final digitPattern = RegExp(r'^(?=.*\d)'); // At least one digit
  // final specialCharacterPattern = RegExp(r'^(?=.*[@$!%*?&])'); // At least one special character

  // Check if password matches all patterns
  return lengthPattern.hasMatch(password) &&
         upperCasePattern.hasMatch(password) &&
         lowerCasePattern.hasMatch(password) &&
         digitPattern.hasMatch(password);
        //  specialCharacterPattern.hasMatch(password);
}
