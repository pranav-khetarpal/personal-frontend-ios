import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_textfield.dart';
import 'package:personal_frontend/pages/models/user_model.dart';
import 'package:personal_frontend/pages/profiles/other_user_profile.dart';
import 'package:personal_frontend/services/user_services.dart';

class SearchUsers extends StatefulWidget {
  const SearchUsers({super.key});

  @override
  State<SearchUsers> createState() => _SearchUsersState();
}

class _SearchUsersState extends State<SearchUsers> {
  // List to hold the search results
  List<UserModel> searchResults = [];

  // Controller for the search text field
  final TextEditingController searchController = TextEditingController();

  // object to use UserService methods
  final UserServices userService = UserServices();

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching users: $e')),
      );
    }
  }

  // Method to navigate to the user profile page
  void navigateToUserProfile(BuildContext context, String userID) {
    Navigator.push(
      context,
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
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Row to hold the search text field and search button
            Row(
              children: [
                // Use the MyTextField component
                Expanded(
                  child: MyTextField(
                    hintText: 'Search by username',
                    obscureText: false,
                    controller: searchController,
                  ),
                ),
                const SizedBox(width: 8), // Add some space between the text field and button
                // Search button
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    searchUsers(searchController.text); // Call the search method when the button is pressed
                  },
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
                  return ListTile(
                    title: Text(user.username),
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
