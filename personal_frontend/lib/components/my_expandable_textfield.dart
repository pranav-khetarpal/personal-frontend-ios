import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyExpandableTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final int maxLength;
  final bool allowSpaces;

  const MyExpandableTextfield({
    super.key,
    required this.hintText,
    required this.controller,
    required this.maxLength,
    required this.allowSpaces,
  });

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> inputFormatters = [
      LengthLimitingTextInputFormatter(maxLength),
    ];

    if (!allowSpaces) {
      inputFormatters.add(
        FilteringTextInputFormatter.deny(RegExp(r'\s')),
      );
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        hintText: hintText,
        counterText: '', // Hide the default counter text
      ),
      inputFormatters: inputFormatters,
      minLines: 1, // Set the minimum number of lines
      maxLines: null, // Allow the TextField to grow in height
      expands: false, // Set to true if you want the TextField to fill the parent
    );
  }
}
