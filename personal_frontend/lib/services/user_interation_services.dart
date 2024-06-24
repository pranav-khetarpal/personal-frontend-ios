import 'dart:convert';
import 'package:personal_frontend/ip_address_and_routes.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:personal_frontend/services/authorization_services.dart';

class UserInteractionServices {
  // object for calling AuthServices methods
  final AuthServices authServices = AuthServices();

  // Fetch the current logged-in user's profile
  Future<UserModel> fetchCurrentUser() async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      final String url = IPAddressAndRoutes.getRoute('getCurrentUser');

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

  // // Handle the follow button press
  // Future<void> followUser(String userIDToFollow, UserModel currentUser) async {
  //   // Retrieve the Firebase token of the current logged-in user
  //   String token = await authServices.getIdToken();

  //   final String url = IPAddressAndRoutes.getRoute('followOtherUser');

  //   try {
  //     // Send HTTP POST request to constructed URL with the token for authorization
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({'userIdToFollow': userIDToFollow}),
  //     );

  //     // Handling whether the response is valid from the status code
  //     if (response.statusCode == 200) {
  //       // Update the current logged-in user's following list
  //       currentUser.following.add(userIDToFollow);
  //     } else {
  //       throw Exception('Failed to follow user: ${response.statusCode} ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     // Catch any errors resulting from the HTTP request
  //     throw Exception('An error occurred: $e');
  //   }
  // }

  // // Handle the unfollow button press
  // Future<void> unfollowUser(String userIDToUnfollow, UserModel currentUser) async {
  //   // Retrieve the Firebase token of the current logged-in user
  //   String token = await authServices.getIdToken();

  //   final String url = IPAddressAndRoutes.getRoute('unfollowOtherUser');

  //   try {
  //     // Send HTTP POST request to constructed URL with the token for authorization
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token',
  //       },
  //       body: jsonEncode({'userIdToUnfollow': userIDToUnfollow}),
  //     );

  //     // Handling whether the response is valid from the status code
  //     if (response.statusCode == 200) {
  //       // Update the current logged-in user's following list
  //       currentUser.following.remove(userIDToUnfollow);
  //     } else {
  //       throw Exception('Failed to unfollow user: ${response.statusCode} ${response.reasonPhrase}');
  //     }
  //   } catch (e) {
  //     // Catch any errors resulting from the HTTP request
  //     throw Exception('An error occurred: $e');
  //   }
  // }

  // Handle the follow button press
  Future<void> followUser(String userIDToFollow, UserModel currentUser) async {
    // Retrieve the Firebase token of the current logged-in user
    String token = await authServices.getIdToken();

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
      if (response.statusCode != 200) {
        throw Exception('Failed to follow user: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      // Catch any errors resulting from the HTTP request
      throw Exception('An error occurred: $e');
    }
  }

  // Handle the unfollow button press
  Future<void> unfollowUser(String userIDToUnfollow, UserModel currentUser) async {
    // Retrieve the Firebase token of the current logged-in user
    String token = await authServices.getIdToken();

    final String url = IPAddressAndRoutes.getRoute('unfollowOtherUser');

    try {
      // Send HTTP POST request to constructed URL with the token for authorization
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'userIdToUnfollow': userIDToUnfollow}),
      );

      // Handling whether the response is valid from the status code
      if (response.statusCode != 200) {
        throw Exception('Failed to unfollow user: ${response.statusCode} ${response.reasonPhrase}');
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

  // Method to see if a the current user is following another user in question
  Future<bool> isFollowingUser(String targetUserId) async {
    String token = await authServices.getIdToken();

    final String baseUrl = IPAddressAndRoutes.getRoute('isFollowingUser');
    final String url = '$baseUrl$targetUserId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return response.body == 'true';
    } else {
      throw Exception('Failed to check following status: ${response.statusCode} ${response.reasonPhrase}');
    }
  }
}
