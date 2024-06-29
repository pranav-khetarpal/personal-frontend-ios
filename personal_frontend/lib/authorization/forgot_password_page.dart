import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_large_button.dart';
import 'package:personal_frontend/components/my_square_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendPasswordResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      displayMessageToUser("Please enter your email address", context);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _auth.sendPasswordResetEmail(email: email);
      Navigator.pop(context); // Dismiss loading dialog
      displayMessageToUser("Password reset email sent. Please check your email.", context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Dismiss loading dialog
      displayMessageToUser("Error: ${e.message}", context);
    } catch (e) {
      Navigator.pop(context); // Dismiss loading dialog
      displayMessageToUser("An error occurred. Please try again.", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Instruction text
              const Text('Enter your email address to receive a password reset email.'),
              const SizedBox(height: 25),

              // Email textfield
              MySquareTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
                maxLength: 254,
                allowSpaces: false,
              ),
              const SizedBox(height: 25),

              // Reset password button
              MyLargeButton(
                text: "Send Reset Email",
                onTap: sendPasswordResetEmail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
