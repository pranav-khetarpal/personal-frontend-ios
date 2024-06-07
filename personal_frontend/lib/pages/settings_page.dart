import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/authorization/login_or_register.dart';
import 'package:personal_frontend/services/authorization_services.dart';
import 'package:personal_frontend/services/user_services.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  // object to use UserService methods
  final UserServices userServices = UserServices();

  // object to use AuthService methods
  final AuthServices authServices = AuthServices();

  // logout user
  void logout(BuildContext context) {
    authServices.clearCachedToken();
    FirebaseAuth.instance.signOut();

    // Navigate to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginOrRegister()), // Replace LoginPage with your actual login screen
    );
  }

  // Show confirmation dialog for account deletion
  void showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account"),
          content: const Text("Are you sure you want to delete your account?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                // Perform account deletion logic here
                try {
                  // Call your backend API to delete the user document and posts
                  await userServices.deleteUser();
                  
                  // Delete the user's Firebase authentication record
                  User? currentUser = FirebaseAuth.instance.currentUser;
                  if (currentUser != null) {
                    await currentUser.delete();
                  }

                  // If successful, navigate to the login screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginOrRegister()), // Replace LoginPage with your actual login screen
                  );
                } on FirebaseAuthException catch (e) {
                  // Handle errors specifically related to Firebase authentication
                  if (e.code == 'requires-recent-login') {
                    // If the error is about requiring recent login, reauthenticate the user
                    // and try deleting again. Here, you could show a dialog prompting the user
                    // to re-authenticate.
                    print("Error: ${e.message}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please re-authenticate and try again.")),
                    );
                  } else {
                    print("Error deleting authentication record: ${e.message}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Failed to delete account")),
                    );
                  }
                } catch (e) {
                  // Handle other errors, such as those from userServices.deleteUser()
                  print("Error deleting account: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Failed to delete account")),
                  );
                }
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => logout(context),
              icon: const Icon(Icons.logout),
            ),
            GestureDetector(
              onTap: () => showDeleteAccountDialog(context),
              child: const Text(
                "Delete Account",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
