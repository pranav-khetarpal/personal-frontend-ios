import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_user_tile.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/pages/profiles/other_user_profile.dart';
import 'package:personal_frontend/services/user_interation_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchUsersHome extends StatefulWidget {
  const SearchUsersHome({super.key});

  @override
  State<SearchUsersHome> createState() => _SearchUsersHomeState();
}

class _SearchUsersHomeState extends State<SearchUsersHome> {
  // List to hold the search results
  List<UserModel> searchResults = [];

  // Controller for the search text field
  final TextEditingController searchController = TextEditingController();

  // Timer for debouncing
  Timer? _debounce;

  // Object to use UserService methods
  final UserInteractionServices userService = UserInteractionServices();
  
  @override
  void initState() {
    super.initState();
    showIntroMessage(); // Show intro message if it's the first time
  }

  // Method to show initial introductory messages to the user
  Future<void> showIntroMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeSearchUsers') ?? true;

    if (isFirstTime) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Search Other Users"),
          content: const Text("This is where you search other users by username. You may view their posts, and follow them."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Got it!"),
            ),
          ],
        ),
      );

      // Set the flag to false so the intro message won't be shown again
      await prefs.setBool('isFirstTimeSearchUsers', false);
    }
  }

  // Method to search for users by username
  Future<void> searchUsers(String query) async {
    try {
      int searchLimit = 10;
      final results = await userService.searchUsers(query, searchLimit);
      setState(() {
        searchResults = results;
      });
    } catch (e) {
      // Log the error and provide user feedback
      print('Error searching users: $e');
      displayMessageToUser('Error searching users: $e', context);
    }
  }

  // Method to handle the search input changes with debounce
  void onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.isNotEmpty) {
        searchUsers(query);
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    });
  }

  // Method to navigate to the user profile page
  void navigateToUserProfile(BuildContext context, String userID) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OtherUserProfile(userID: userID), // Pass the userId to the profile page
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'), // Title of the search page
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            // Row to hold the search text field and search button
            Row(
              children: [
                // Use the MyTextField component
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Search for a username...',
                    ),
                    onChanged: onSearchChanged, // Call the onSearchChanged method when the text changes
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Add some space between the input row and the search results
            // Display search results
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  UserModel user = searchResults[index];
                  return UserTile(
                    user: user,
                    onTap: () => navigateToUserProfile(context, user.id), // Navigate to the user profile page on tap
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
