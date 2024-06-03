import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/ip_address_and_routes.dart';
import 'package:personal_frontend/pages/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserServices {

  // // Create a new user document
  // Future<void> createUserDocument({
  //   required String name,
  //   required String email,
  //   required String username,
  //   required String? authToken,
  // }) async {
  //   try {
  //     String url = IPAddressAndRoutes.getRoute('createUser');

  //     // Create the user data to be sent in the request body
  //     var userData = {
  //       'name': name,
  //       'email': email,
  //       'username': username,
  //     };

  //     // Make the HTTP POST request to create the user document
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $authToken', // Include the authorization token
  //       },
  //       body: jsonEncode(userData),
  //     );

  //     // Check if the request was successful
  //     if (response.statusCode == 200) {
  //       // User document created successfully
  //       print('User document created successfully');
  //     } else {
  //       // Handle unsuccessful request
  //       print('Failed to create user document: ${response.statusCode} ${response.reasonPhrase}');
  //       print('Response body: ${response.body}');
  //       throw Exception('Failed to create user document');
  //     }
  //   } catch (e) {
  //     // Handle any errors that occur during the request
  //     print('Error occurred while creating user document: $e');
  //     rethrow;
  //   }
  // }

  // Create a new user document
  Future<void> createUserDocument({
    required String name,
    required String email,
    required String username,
    required String authToken,
  }) async {
    try {
      String url = IPAddressAndRoutes.getRoute('createUser');

      // Create the user data to be sent in the request body
      var userData = {
        'name': name,
        'email': email,
        'username': username,
      };

      authToken = authToken.replaceAll(RegExp(r'\s'), '').trim();
      print("\n");
      print("Token sent for creating user document:");
      print(authToken);

      // Make the HTTP POST request to create the user document
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Include the authorization token
        },
        body: jsonEncode(userData),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        // User document created successfully
        print('User document created successfully');
      } else {
        // Handle unsuccessful request
        print('Failed to create user document: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        throw Exception('Failed to create user document');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error occurred while creating user document: $e');
      rethrow;
    }
  }

  // Fetch the current logged-in user's profile
  Future<UserModel> fetchCurrentUser() async {
    // Retrieve the Firebase token of the current logged-in user
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    if (token == null) {
      throw Exception('Failed to retrieve Firebase token');
    }

    final String url = IPAddressAndRoutes.getRoute('getCurrentUser');

    try {
      // Send HTTP GET request to constructed URL with the token for authorization
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token'
        },
      );

      // Handling whether the response is valid from the status code
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load current user: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      // Catch any errors resulting from the HTTP request
      throw Exception('An error occurred: $e');
    }
  }
  
  // Fetch the profile of the user whose ID is passed
  Future<UserModel> fetchUserProfile(String userId) async {
    // constructing the url for the http get request
    final String url = '${IPAddressAndRoutes.getRoute('getOtherUser')}$userId';
    
    try {
      // waiting for the get request to complete
      final response = await http.get(Uri.parse(url));
      
      // handling whether the response is valid from the status code
      if (response.statusCode == 200) {
        return UserModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load user profile: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      // catch any errors resulting from the HTTP request
      throw Exception('Failed to load user profile: $e');
    }
  }

  // Handle the follow button press
  Future<void> followUser(String userIDToFollow, UserModel currentUser) async {
    // Retrieve the Firebase token of current logged-in user
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    
    if (token == null) {
      throw Exception('Failed to retrieve Firebase token');
    }

    final String url = IPAddressAndRoutes.getRoute('followOtherUser');

    try {
      // Send HTTP POST request to constructed URL with the token for authorization
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'userIdToFollow': userIDToFollow}),
      );

      // Handling whether the response is valid from the status code
      if (response.statusCode == 200) {
        // Update the current logged-in user's following list
        currentUser.following.add(userIDToFollow);
      } else {
        throw Exception('Failed to follow user: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      // Catch any errors resulting from the HTTP request
      throw Exception('An error occurred: $e');
    }
  }

  // Method to search for users by username with limit
  Future<List<UserModel>> searchUsers(String query, int limit) async {
    // If the search query is empty, return an empty list
    if (query.isEmpty) {
      return [];
    }

    // Construct the URL with the query parameter
    final String baseUrl = IPAddressAndRoutes.getRoute('searchUsername');
    final String url = '$baseUrl$query&limit=$limit'; // Append limit parameter

    try {
      // Send HTTP GET request to the constructed URL
      final response = await http.get(Uri.parse(url));

      // Handling whether the response is valid from the status code
      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((user) => UserModel.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      // Catch any error occurring with the HTTP request
      throw Exception('Error searching users: $e');
    }
  }

// Logout user
Future<void> logout() async {
  try {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('Failed to retrieve Firebase token');
    }

    String url = IPAddressAndRoutes.getRoute('logout');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // If logout is successful, sign out from Firebase Auth
      await FirebaseAuth.instance.signOut();
      // Navigate to the login page or perform any other necessary actions
      // For example:
      // Navigator.of(context).pushReplacementNamed('/login');
    } else {
      // Handle logout failure
      print('Logout failed: ${response.statusCode}');
      // Show an error message or perform appropriate actions
    }
  } catch (e) {
    // Handle network errors or exceptions
    print('Logout failed: $e');
    // Show an error message or perform appropriate actions
  }
}
}
