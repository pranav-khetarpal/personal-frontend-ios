// import 'package:flutter/material.dart';

// class MyTextField extends StatelessWidget {
//   final String hintText;
//   final bool obscureText;
//   final TextEditingController controller;

//   const MyTextField({
//     super.key,
//     required this.hintText,
//     required this.obscureText,
//     required this.controller,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         hintText: hintText,
//       ),
//       obscureText: obscureText,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MySquareTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final int maxLength;
  final bool allowSpaces; // New parameter to control space allowance

  const MySquareTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
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
        border: const OutlineInputBorder(
          // borderRadius: BorderRadius.circular(20),
        ),
        hintText: hintText,
        counterText: '', // Hide the default counter text
        fillColor: Theme.of(context).colorScheme.tertiary,
        filled: true,
      ),
      obscureText: obscureText,
      inputFormatters: inputFormatters,
    );
  }
}
