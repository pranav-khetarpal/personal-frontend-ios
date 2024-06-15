import 'dart:convert';
import 'package:personal_frontend/ip_address_and_routes.dart';
import 'package:http/http.dart' as http;
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/services/authorization_services.dart';

class UserAccountServices {
  // object to use AuthServices methods
  final AuthServices authServices = AuthServices();

  // Create a new user document
  Future<void> createUserDocument({
    required String name,
    required String email,
    required String username,
    required String bio,
  }) async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('createUser');

      // Create the user data to be sent in the request body
      var userData = {
        'name': name,
        'email': email,
        'username': username,

        // set the default profile image of the user
        'profile_image_url': "https://firebasestorage.googleapis.com/v0/b/personal-app-fe948.appspot.com/o/profile_images%2Fdefault_profile_image.jpg?alt=media&token=f33a9720-2010-41b4-a6d0-4ba450db2f99",
        'bio': bio,
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(userData),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
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


  // Check if the username is available
  Future<bool> isUsernameAvailable(String username) async {
    String url = IPAddressAndRoutes.getRoute('checkUsernameAvailability');

    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'username': username}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['available'];
    } else {
      throw Exception('Failed to check username availability');
    }
  }

  // Method to update the profile information of a user
  Future<bool> updateUserProfile(UserModel updatedUser) async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('updateUser');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the token in the headers
        },
        body: jsonEncode(updatedUser.toJson()),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        // Handle different status codes if necessary
        print('Failed to update profile: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error updating profile: $e');
      return false;
    }
  }


  // Method to delete all of a user's content, including their posts
  Future<void> deleteUser() async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('deleteUser');

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        }
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        print('User deleted successfully');
      } else {
        // Handle unsuccessful request
        print('Failed to delete user: ${response.statusCode} ${response.reasonPhrase}');
        print('Response body: ${response.body}');
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      // Log the error
      print('Error deleting user: $e');
      // Handle the error gracefully, e.g., show an error message to the user
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to delete user')),
      // );
      // You can also throw the error if it needs to be handled at a higher level
      // throw Exception('Failed to delete user: $e');
    }
  }
}
