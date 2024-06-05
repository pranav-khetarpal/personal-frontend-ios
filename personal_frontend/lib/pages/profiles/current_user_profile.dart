import 'package:flutter/material.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/pages/settings_page.dart';
import 'package:personal_frontend/services/user_services.dart';

class CurrentUserProfile extends StatefulWidget {
  const CurrentUserProfile({super.key});

  @override
  State<CurrentUserProfile> createState() => _CurrentUserProfileState();
}

class _CurrentUserProfileState extends State<CurrentUserProfile> {
  late Future<UserModel> futureUser;
  UserModel? currentUser;
  bool isLoadingCurrentUser = true;

  // object for calling UserService methods
  final UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    // Fetch the current user's profile
    userServices.fetchCurrentUser().then((user) {
      setState(() {
        currentUser = user;
        isLoadingCurrentUser = false;
      });
    }).catchError((error) {
      setState(() {
        isLoadingCurrentUser = false;
      });
      // Handle error fetching current user
      print('Error fetching current user: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Social Media"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings), 
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: isLoadingCurrentUser
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    const Icon(Icons.account_circle, size: 100), // Placeholder icon for user image
                    const SizedBox(height: 16),
                    Text(currentUser!.name, style: const TextStyle(fontSize: 24)),
                    Text('@${currentUser!.username}', style: const TextStyle(fontSize: 18, color: Colors.grey)),
                    // Add any other information you want to display about the current user here
                  ],
                ),
              ),
            ),
    );
  }
}
