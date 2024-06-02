import 'package:flutter/material.dart';

class UserMessage extends StatelessWidget {
  const UserMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hello',
        style: TextStyle(fontSize: 50),
      ),
    );
  }
}
