// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:personal_frontend/components/my_large_button.dart';
// import 'package:personal_frontend/components/my_square_textfield.dart';
// import 'package:personal_frontend/helper/helper_functions.dart';

// class ChangePasswordPage extends StatelessWidget {
//   ChangePasswordPage({super.key});

//   // text controllers
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Change Password"),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(25.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
          
//               // password textfield
//               MySquareTextField(
//                 hintText: "Password",
//                 obscureText: true,
//                 controller: passwordController,
//                 maxLength: 100,
//                 allowSpaces: false,
//               ),

//               const SizedBox(height: 10),
          
//               // confirm password textfield
//               MySquareTextField(
//                 hintText: "Confirm Password",
//                 obscureText: true,
//                 controller: confirmPasswordController,
//                 maxLength: 100,
//                 allowSpaces: false,
//               ),

//               const SizedBox(height: 35),

//               // change password button
//               MyLargeButton(
//                 text: "Change Password",
//                 onTap: () async {
//                   String password = passwordController.text.trim();
//                   String confirmPassword = confirmPasswordController.text.trim();

//                   // confirm that the password fields are not empty
//                   if (password.isEmpty || confirmPassword.isEmpty) {
//                     displayMessageToUser("Password fields cannot be empty", context);
//                     return;
//                   }

//                   // check that the password and confirm passwords texts are identical
//                   if (password != confirmPassword) {
//                     displayMessageToUser("Passwords do not match", context);
//                     return;
//                   }

//                   try {
//                     // get the user and update their password
//                     User? user = FirebaseAuth.instance.currentUser;
//                     if (user != null) {
//                       await user.updatePassword(password);
//                       displayMessageToUser("Password updated successfully", context);
//                     }
//                   } catch (e) {
//                     // handle any errors
//                     displayMessageToUser("Failed to update password: $e", context);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_large_button.dart';
import 'package:personal_frontend/components/my_square_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({super.key});

  // text controllers
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // password textfield
              MySquareTextField(
                hintText: "Password",
                obscureText: true,
                controller: passwordController,
                maxLength: 100,
                allowSpaces: false,
              ),

              const SizedBox(height: 10),

              // confirm password textfield
              MySquareTextField(
                hintText: "Confirm Password",
                obscureText: true,
                controller: confirmPasswordController,
                maxLength: 100,
                allowSpaces: false,
              ),

              const SizedBox(height: 35),

              // change password button
              MyLargeButton(
                text: "Change Password",
                onTap: () async {
                  String password = passwordController.text.trim();
                  String confirmPassword = confirmPasswordController.text.trim();

                  // confirm that the password fields are not empty
                  if (password.isEmpty || confirmPassword.isEmpty) {
                    displayMessageToUser("Password fields cannot be empty", context);
                    return;
                  }

                  // check that the password and confirm passwords texts are identical
                  if (password != confirmPassword) {
                    displayMessageToUser("Passwords do not match", context);
                    return;
                  }

                  // password strength check
                  if (!isPasswordStrong(password)) {
                    displayMessageToUser("Password must be at least 8 characters long, include an uppercase letter, a lowercase letter, a digit, and a special character.", context);
                    return;
                  }

                  try {
                    // get the user and update their password
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await user.updatePassword(password);
                      displayMessageToUser("Password updated successfully", context);
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'requires-recent-login') {
                      displayMessageToUser("Please log in again and try updating the password", context);
                    } else {
                      displayMessageToUser("Failed to update password: ${e.message}", context);
                    }
                  } catch (e) {
                    // handle any errors
                    displayMessageToUser("Failed to update password: $e", context);
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
