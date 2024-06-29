import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_large_button.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:personal_frontend/components/my_square_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/services/image_services.dart';
import 'package:personal_frontend/services/user_account_services.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/pages/main_scaffold.dart';
import 'package:personal_frontend/services/user_interation_services.dart';

class InitializeProfilePage extends StatefulWidget {
  const InitializeProfilePage({super.key});

  @override
  State<InitializeProfilePage> createState() => _InitializeProfilePageState();
}

class _InitializeProfilePageState extends State<InitializeProfilePage> {
  // get the UserModel of the current user
  UserModel? currentUser;
  bool isLoadingCurrentUser = true;
  late Future<UserModel> futureUser;

  // object to user service class methods
  final UserInteractionServices userInteractionServices = UserInteractionServices();
  final UserAccountServices userAccountServices = UserAccountServices();
  final ImageServices imageServices = ImageServices();

  // text controller
  final TextEditingController bioController = TextEditingController();


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
        bioController.text = currentUser?.bio ?? '';
      });
    } catch (error) {
      setState(() {
        isLoadingCurrentUser = false;
      });
      // Handle error fetching current user
      print('Error fetching current user: $error');
      displayMessageToUser("Failed to upload profile image", context);
    }
  }

  // Method to handle photo upload
  void handlePhotoUpload() async {
    if (currentUser == null) return;
    try {
      await imageServices.updateUserProfileImage(currentUser!.id);
      // Fetch the updated user profile to refresh the displayed image
      await fetchCurrentUser();
    } catch (e) {
      print('Error uploading profile image: $e');
      displayMessageToUser("Failed to upload profile image", context);
    }
  }

  Future<void> updateProfile() async {
    if (currentUser == null) return;
    try {
      UserModel updatedUser = UserModel(
        id: currentUser!.id,
        name: currentUser!.name,
        username: currentUser!.username,
        bio: bioController.text,
        profileImageUrl: currentUser!.profileImageUrl,
        stockLists: currentUser!.stockLists,
        followersCount: currentUser!.followersCount,
        followingCount: currentUser!.followingCount,
      );

      bool success = await userAccountServices.updateUserProfile(updatedUser);
      if (success) {
        displayMessageToUser("Profile updated successfully", context);
        navigateToMainScaffold();
      } else {
        displayMessageToUser("Failed to update profile", context);
      }
    } catch (e) {
      print('Error updating profile: $e');
      displayMessageToUser("Error updating profile: $e", context);
    }
  }

  void navigateToMainScaffold() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScaffold()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Your Profile')),
      body: Center(
        child: isLoadingCurrentUser
          ? const CircularProgressIndicator()
          : Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: currentUser?.profileImageUrl.isNotEmpty == true
                          ? NetworkImage(currentUser!.profileImageUrl)
                          : null,
                      onBackgroundImageError: (exception, stackTrace) {
                        print('Error loading profile image: $exception');
                        setState(() {
                          currentUser?.profileImageUrl = '';
                        });
                      },
                      child: currentUser?.profileImageUrl.isEmpty == true
                          ? const Icon(Icons.account_circle, size: 50)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    MySmallButton(
                      text: "Upload photo",
                      onTap: handlePhotoUpload,
                    ),
                  ]
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     CircleAvatar(
                //       radius: 50,
                //       backgroundImage: currentUser!.profileImageUrl.isNotEmpty
                //           ? NetworkImage(currentUser!.profileImageUrl)
                //           : null,
                //       onBackgroundImageError: (exception, stackTrace) {
                //         print('Error loading profile image: $exception');
                //         setState(() {
                //           // Fallback to default icon or image in case of an error
                //           currentUser!.profileImageUrl = '';
                //         });
                //       },
                //       child: currentUser!.profileImageUrl.isEmpty
                //           ? const Icon(Icons.account_circle, size: 50)
                //           : null,
                //     ),

                //     const SizedBox(width: 16),

                //     MySmallButton(
                //       text: "Upload photo", 
                //       onTap: handlePhotoUpload,
                //     ),
                //   ],
                // ),

                // CircleAvatar(
                //   radius: 50,
                //   backgroundImage: currentUser!.profileImageUrl.isNotEmpty
                //       ? NetworkImage(currentUser!.profileImageUrl)
                //       : null,
                //   onBackgroundImageError: (exception, stackTrace) {
                //     print('Error loading profile image: $exception');
                //   },
                //   child: currentUser!.profileImageUrl.isEmpty
                //       ? const Icon(Icons.account_circle, size: 50)
                //       : null,
                // ),

                const SizedBox(height: 16),

                MySquareTextField(
                  hintText: "Bio",
                  obscureText: false,
                  controller: bioController,
                  maxLength: 160,  // Twitter-like bio length
                  allowSpaces: true,
                ),

                const SizedBox(height: 35),

                MyLargeButton(
                  text: "Update Profile",
                  onTap: updateProfile,
                ),

                const SizedBox(height: 10),

                MyLargeButton(
                  text: "Skip",
                  onTap: navigateToMainScaffold,
                ),
              ],
            ),
          ),
      ),
    );
  }
}
