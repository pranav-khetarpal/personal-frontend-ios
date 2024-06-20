import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:personal_frontend/ip_address_and_routes.dart';
import 'package:personal_frontend/services/authorization_services.dart';

class CommentServices {
  final AuthServices authServices = AuthServices();

  // Handle the creation of a new comment
  Future<void> submitComment({
    required String postId,
    required String content,
  }) async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('createComment');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'postId': postId, 'content': content}),
      );

      if (response.statusCode == 200) {
        print("Comment submitted successfully");
      } else {
        // Handle unsuccessful comment submission
        throw Exception('Failed to submit comment: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occur during the submission process
      print('Error occurred while submitting comment: $e');
    }
  }

  // Method to delete a comment
  Future<void> deleteComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String baseUrl = IPAddressAndRoutes.getRoute('deleteComment');
      String url = '$baseUrl/$postId/$commentId';

      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print("Comment deleted successfully");
      } else {
        // Handle unsuccessful comment deletion
        throw Exception('Failed to delete comment: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occur during the deletion process
      print('Error occurred while deleting comment: $e');
    }
  }
}
