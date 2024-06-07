import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_button.dart';
import 'package:personal_frontend/components/my_square_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/pages/base_layout.dart';
import 'package:personal_frontend/pages/home_page.dart';
import 'package:personal_frontend/services/user_services.dart';

class LoginPage extends StatefulWidget {
  
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // object to use UserServices methods
  final UserServices userServices = UserServices();

  // // login method
  // void login() async {
  //   // show loading circle
  //   showDialog(
  //     context: context, 
  //     builder: (context) => const Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );

  //   // try sign in
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: emailController.text, 
  //       password: passwordController.text,
  //     );

  //     // pop loading circle
  //     Navigator.pop(context);

  //     // // Navigate to the desired page
  //     // Navigator.pushReplacement(
  //     //   context,
  //     //   MaterialPageRoute(
  //     //     builder: (context) => HomePage(), // Replace DesiredPage with your desired destination page
  //     //   )
  //     // );
  //   }

  //   // display any errors
  //   on FirebaseAuthException catch (e) {
  //     // pop loading circle
  //     Navigator.pop(context);

  //     // display error message
  //     displayMessageToUser(e.code, context);
  //   }

  // }

void login() async {
  // Show loading circle
  showDialog(
    context: context, 
    builder: (context) => const Center(
      child: CircularProgressIndicator(),
    ),
  );

  // Try sign in
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text, 
      password: passwordController.text,
    );

    // Check if the user document exists in Firestore
    final userDoc = await userServices.fetchUserProfile(userCredential.user!.uid);

    if (userDoc != null) {
      // Pop loading circle
      if (mounted) Navigator.pop(context);

      // Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      // User document doesn't exist, log out and show error
      await FirebaseAuth.instance.signOut();
      
      // Pop loading circle
      if (mounted) Navigator.pop(context);

      // Display error message
      displayMessageToUser("User profile not found. Please register.", context);
    }
  } on FirebaseAuthException catch (e) {
    // Pop loading circle
    if (mounted) Navigator.pop(context);

    // Display error message
    displayMessageToUser(e.message ?? "Authentication failed", context);
  } catch (e) {
    // Pop loading circle
    if (mounted) Navigator.pop(context);

    // Display general error message
    displayMessageToUser("An error occurred. Please try again.", context);
  }
}


  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Icon(
                  Icons.abc,
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
            
                // forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary)
                    ),
                  ],
                ),
      
                const SizedBox(height: 25),
            
                // sign in button
                MyButton(
                  text: "Login", 
                  onTap: login,
                ),
      
                const SizedBox(height: 25),
            
                // don't have an account? Register here
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Register Here",
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
