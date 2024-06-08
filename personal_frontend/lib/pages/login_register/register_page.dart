import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_button.dart';
import 'package:personal_frontend/components/my_square_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/pages/base_layout.dart';
import 'package:personal_frontend/pages/main_scaffold.dart';
import 'package:personal_frontend/services/user_account_services.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  // object for calling UserAccountServices methods
  final UserAccountServices userAccountServices = UserAccountServices();

  // register method
  Future<void> register() async {
    // make sure the passwords match
    if (passwordController.text != confirmPasswordController.text) {
      displayMessageToUser("Passwords don't match", context);
      return;
    }

    // show a loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Create the user
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      try {
        // Create a user document in Firestore
        await userAccountServices.createUserDocument(
          name: nameController.text,
          email: emailController.text,
          username: usernameController.text,
        );
      } catch (e) {
        // Delete user's authentication credentials if user document creation fails
        await userCredential.user?.delete();

        // pop the loading circle
        if (mounted) Navigator.pop(context);

        displayMessageToUser("User document creation failed. Please try again.", context);
        return;
      }

      // pop the loading circle
      if (mounted) Navigator.pop(context);

      // Navigate to the home page only if registration is successful
      Future.microtask(() {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScaffold()),
          );
        }
      });

    } on FirebaseAuthException catch (e) {

      // pop the loading circle
      if (mounted) Navigator.pop(context);

      displayMessageToUser("Firebase Error: ${e.message}", context);
    } catch (e) {
      if (mounted) Navigator.pop(context);

      displayMessageToUser("Error: $e", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),

                const SizedBox(height: 25),

                // app name
                const Text(
                  "A P P    N A M E",
                  style: TextStyle(fontSize: 20,),
                ),

                const SizedBox(height: 50),

                // name textfield
                MySquareTextField(
                  hintText: "Full Name",
                  obscureText: false,
                  controller: nameController,
                  maxLength: 50,
                  allowSpaces: true,
                ),

                const SizedBox(height: 10),

                // username textfield
                MySquareTextField(
                  hintText: "@username",
                  obscureText: false,
                  controller: usernameController,
                  maxLength: 15,
                  allowSpaces: false,
                ),

                const SizedBox(height: 10),

                // email textfield
                MySquareTextField(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController,
                  maxLength: 254,
                  allowSpaces: false,
                ),

                const SizedBox(height: 10),

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

                // register button
                MyButton(
                  text: "Register",
                  onTap: register,
                ),

                const SizedBox(height: 25),

                // don't have an account? Register here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Login Here",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

