// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:personal_frontend/authorization/login_or_register.dart';
// import 'package:personal_frontend/helper/helper_functions.dart';
// import 'package:personal_frontend/services/authorization_services.dart';
// import 'package:personal_frontend/services/user_account_services.dart';

// class SettingsPage extends StatelessWidget {
//   SettingsPage({super.key});

//   // object to user UserAccountServices methods
//   final UserAccountServices userAccountServices = UserAccountServices();

//   // object to use AuthService methods
//   final AuthServices authServices = AuthServices();

//   // logout user
//   void logout(BuildContext context) {
//     authServices.clearCachedToken();
//     FirebaseAuth.instance.signOut();

//     // Navigate to the login screen
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginOrRegister()), // Replace LoginPage with your actual login screen
//     );
//   }

//   // Show confirmation dialog for account deletion
//   void showDeleteAccountDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Delete Account"),
//           content: const Text("Are you sure you want to delete your account?"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 // Perform account deletion logic here
//                 try {
//                   // Call your backend API to delete the user document and posts
//                   await userAccountServices.deleteUser();
                  
//                   // Delete the user's Firebase authentication record
//                   User? currentUser = FirebaseAuth.instance.currentUser;
//                   if (currentUser != null) {
//                     await currentUser.delete();
//                   }

//                   // If successful, navigate to the login screen
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => const LoginOrRegister()), // Replace LoginPage with your actual login screen
//                   );
//                 } on FirebaseAuthException catch (e) {
//                   // Handle errors specifically related to Firebase authentication
//                   if (e.code == 'requires-recent-login') {
//                     // If the error is about requiring recent login, reauthenticate the user
//                     // and try deleting again. Here, you could show a dialog prompting the user
//                     // to re-authenticate.
//                     print("Error: ${e.message}");
//                     displayMessageToUser("Please re-authenticate and try again.", context);

//                   } else {

//                     print("Error deleting authentication record: ${e.message}");
//                     displayMessageToUser("Failed to delete account", context);

//                   }
//                 } catch (e) {
//                   // Handle other errors, such as those from userServices.deleteUser()
//                   print("Error deleting account: $e");
//                   displayMessageToUser("Failed to delete account", context);
                  
//                 }
//               },
//               child: const Text(
//                 "Delete",
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(

//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             IconButton(
//               onPressed: () => logout(context),
//               icon: const Icon(Icons.logout),
//             ),
//             GestureDetector(
//               onTap: () => showDeleteAccountDialog(context),
//               child: const Text(
//                 "Delete Account",
//                 style: TextStyle(
//                   color: Colors.red,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/authorization/login_or_register.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/services/authorization_services.dart';
import 'package:personal_frontend/services/user_account_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SettingsPage extends StatelessWidget {
  final UserModel? user;
  
  SettingsPage({
    super.key,
    required this.user,
  });

  // object to user UserAccountServices methods
  final UserAccountServices userAccountServices = UserAccountServices();

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
                // // Perform account deletion logic here
                // try {

              //     // Check if the profile image is not the default one
              //     if (user!.profile_image_url != 'https://firebasestorage.googleapis.com/v0/b/personal-app-fe948.appspot.com/o/profile_images%2Fdefault_profile_image.jpg?alt=media&token=f33a9720-2010-41b4-a6d0-4ba450db2f99') {
              //       // Delete the profile image from Firebase Storage
              //       await firebase_storage.FirebaseStorage.instance.refFromURL(user!.profile_image_url).delete();
              //     }

              //     // Call your backend API to delete the user document and posts
              //     await userAccountServices.deleteUser();
                  
              //     // Delete the user's Firebase authentication record
              //     User? currentUser = FirebaseAuth.instance.currentUser;
              //     if (currentUser != null) {
              //       await currentUser.delete();
              //     }

              //     // If successful, navigate to the login screen
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(builder: (context) => const LoginOrRegister()), // Replace LoginPage with your actual login screen
              //     );
              //   } on FirebaseAuthException catch (e) {
              //     // Handle errors specifically related to Firebase authentication
              //     if (e.code == 'requires-recent-login') {
              //       // If the error is about requiring recent login, reauthenticate the user
              //       // and try deleting again. Here, you could show a dialog prompting the user
              //       // to re-authenticate.
              //       print("Error: ${e.message}");
              //       displayMessageToUser("Please re-authenticate and try again.", context);

              //     } else {

              //       print("Error deleting authentication record: ${e.message}");
              //       displayMessageToUser("Failed to delete account", context);

              //     }
              //   } catch (e) {
              //     // Handle other errors, such as those from userServices.deleteUser()
              //     print("Error deleting account: $e");
              //     displayMessageToUser("Failed to delete account", context);
                  
              //   }
              // },
              // Perform account deletion logic here
                try {
                  if (user != null) {
                    // Check if the profile image is not the default one
                    if (user!.profile_image_url !=
                        'https://firebasestorage.googleapis.com/v0/b/personal-app-fe948.appspot.com/o/profile_images%2Fdefault_profile_image.jpg?alt=media&token=f33a9720-2010-41b4-a6d0-4ba450db2f99') {
                      try {
                        // Delete the profile image from Firebase Storage
                        await firebase_storage.FirebaseStorage.instance
                            .refFromURL(user!.profile_image_url)
                            .delete();
                        print('Profile image deleted successfully');
                      } catch (e) {
                        print('Error deleting profile image: $e');
                      }
                    }

                    // Call your backend API to delete the user document and posts
                    await userAccountServices.deleteUser();

                    // Delete the user's Firebase authentication record
                    User? currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      await currentUser.delete();
                    }

                    // If successful, navigate to the login screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginOrRegister()), // Replace LoginPage with your actual login screen
                    );
                  } else {
                    print('Error: user is null');
                  }
                } on FirebaseAuthException catch (e) {
                  // Handle errors specifically related to Firebase authentication
                  if (e.code == 'requires-recent-login') {
                    // If the error is about requiring recent login, reauthenticate the user
                    // and try deleting again. Here, you could show a dialog prompting the user
                    // to re-authenticate.
                    print("Error: ${e.message}");
                    displayMessageToUser(
                        "Please re-authenticate and try again.", context);
                  } else {
                    print("Error deleting authentication record: ${e.message}");
                    displayMessageToUser("Failed to delete account", context);
                  }
                } catch (e) {
                  // Handle other errors, such as those from userServices.deleteUser()
                  print("Error deleting account: $e");
                  displayMessageToUser("Failed to delete account", context);
                };
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
