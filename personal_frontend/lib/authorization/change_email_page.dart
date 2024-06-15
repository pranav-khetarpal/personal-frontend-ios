import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_large_button.dart';
import 'package:personal_frontend/components/my_square_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';

class ChangeEmailPage extends StatelessWidget {

  ChangeEmailPage({
    super.key,
  });

  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController confirmEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Email"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // email textfield
              MySquareTextField(
                hintText: "Email",
                obscureText: false,
                controller: emailController,
                maxLength: 254,
                allowSpaces: false,
              ),

              const SizedBox(height: 10),
              
              // confirm email textfield
              MySquareTextField(
                hintText: "Confirm Email",
                obscureText: false,
                controller: confirmEmailController,
                maxLength: 254,
                allowSpaces: false,
              ),

              const SizedBox(height: 35,),
              
              // change email button
              MyLargeButton(
                text: "Change Email",
                onTap: () async {
                  String email = emailController.text.trim();
                  String confirmEmail = confirmEmailController.text.trim();

                  // confirm that the textfields are not empty
                  if (email.isEmpty || confirmEmail.isEmpty) {
                    displayMessageToUser("Email fields cannot be empty", context);
                    return;
                  }

                  // make sure that the email and confirm email texts are the same
                  if (email != confirmEmail) {
                    displayMessageToUser("Emails do not match", context);
                    return;
                  }

                  try {
                    // get the current user and update their email
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.verifyBeforeUpdateEmail(email);
                      displayMessageToUser("Email updated successfully", context);
                    }
                  } catch (e) {
                    // handle any errors
                    displayMessageToUser("Failed to update email: $e", context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
