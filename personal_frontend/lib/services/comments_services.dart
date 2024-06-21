import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:personal_frontend/ip_address_and_routes.dart';
import 'package:personal_frontend/models/comment_model.dart';
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
      String url = '$baseUrl$postId/$commentId';

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

  // Method to retrieve comments for a post, with pagination
  Future<List<CommentModel>> fetchComments({
    required String postId,
    int limit = 10,
    String? startAfterId,
  }) async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('fetchComments');

      // Construct the URL with query parameters for pagination
      var uri = Uri.parse(url).replace(queryParameters: {
        'post_id': postId,
        'limit': limit.toString(),
        if (startAfterId != null) 'start_after': startAfterId,
      });

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Decode JSON response to list and return the list of CommentModel objects
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((comment) => CommentModel.fromJson(comment)).toList();
      } else {
        // Handle unsuccessful comment fetching
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      print(e);
      rethrow;
    }
  }

  // Method to allow the user to like a comment
  Future<void> likeComment(String postId, String commentId) async {
    String token = await authServices.getIdToken();
    String baseUrl = IPAddressAndRoutes.getRoute('likeComment');
    String url = '$baseUrl$postId/$commentId';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Comment liked successfully');
    } else {
      throw Exception('Failed to like comment: ${response.statusCode}');
    }
  }

  // Method to allow the user to unlike a comment
  Future<void> unlikeComment(String postId, String commentId) async {
    String token = await authServices.getIdToken();
    String baseUrl = IPAddressAndRoutes.getRoute('unlikeComment');
    String url = '$baseUrl$postId/$commentId';

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print('Comment unliked successfully');
    } else {
      throw Exception('Failed to unlike comment: ${response.statusCode}');
    }
  }
}
