import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyRoundedTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int maxLength;
  final bool allowSpaces; // New parameter to control space allowance

  const MyRoundedTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.maxLength,
    required this.allowSpaces, // Include the allowSpaces parameter
  });

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> inputFormatters = [
      LengthLimitingTextInputFormatter(maxLength), // Add length limit
    ];

    // Conditionally add formatter to allow or disallow spaces
    if (!allowSpaces) {
      inputFormatters.add(
        FilteringTextInputFormatter.deny(RegExp(r'\s')), // Deny spaces
      );
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        hintText: hintText,
        counterText: '', // Hide the default counter text
      ),
      inputFormatters: inputFormatters,
    );
  }
}
