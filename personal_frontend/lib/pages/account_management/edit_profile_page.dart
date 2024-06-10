import 'dart:async';

import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_button.dart';
import 'package:personal_frontend/components/my_square_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/services/user_account_services.dart';
import 'package:personal_frontend/services/user_interation_services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
    // variables for displaying the user's information
  late Future<UserModel> futureUser;
  UserModel? currentUser;
  bool isLoadingCurrentUser = true;

  // object to user UserInteractionServices methods
  final UserInteractionServices userInteractionServices = UserInteractionServices();
  final UserAccountServices userAccountServices = UserAccountServices();

  // text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(); // Fetch the current user's profile
  }

  // fetch the current user's profile to display their information
  Future<void> fetchCurrentUser() async {
    try {
      UserModel user = await userInteractionServices.fetchCurrentUser();
      setState(() {
        currentUser = user;
        isLoadingCurrentUser = false;
        // Update text controllers with fetched user data
        nameController.text = currentUser?.name ?? '';
        usernameController.text = currentUser?.username ?? '';
      });
    } catch (error) {
      setState(() {
        isLoadingCurrentUser = false;
      });
      // Handle error fetching current user
      print('Error fetching current user: $error');
    }
  }

  // update the current user's information
  void updateProfile() async {
    try {
      // Check if the username is available
      bool isAvailable = await userAccountServices.isUsernameAvailable(usernameController.text);
      if (!isAvailable) {
        displayMessageToUser("Username is not available", context);
        return;
      }

      // Create a new user model with the updated data
      UserModel updatedUser = UserModel(
        id: currentUser!.id,
        name: nameController.text, // the user's inputted name
        username: usernameController.text, // the user's inputted username
        following: currentUser!.following,
      );

      // Send the updated data to the backend
      bool success = await userAccountServices.updateUserProfile(updatedUser);

      if (success) {
        // Show a success message or perform additional actions
        displayMessageToUser("Profile updated successfully", context);
      } else {
        // Handle failure
        displayMessageToUser("Failed to update profile", context);
      }
    } catch (error) {
      // Handle error
      print('Error updating profile: $error');
      displayMessageToUser("Error updating profile", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Center(
        child: isLoadingCurrentUser
          ? const CircularProgressIndicator()
          : Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            
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
                    maxLength: 50,
                    allowSpaces: false,
                  ),
            
                  const SizedBox(height: 35),
            
                  // update button
                  MyButton(
                    text: "Update",
                    onTap: updateProfile,
                  ),
                ],
              ),
          ),
      ),
    );
  }
}
