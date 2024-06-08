import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:personal_frontend/ip_address_and_routes.dart';
import 'package:personal_frontend/models/post_model.dart';
import 'package:personal_frontend/services/authorization_services.dart';

class PostServices {
  // object for calling AuthServices methods
  final AuthServices authServices = AuthServices();

  // Handle the creation of a new post
  Future<void> submitPost({
    required String content,
  }) async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('createPost');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'content': content}),
      );

      if (response.statusCode == 200) {
        print("User post submitted successfully");
      } else {
        // Handle unsuccessful post submission
        throw Exception('Failed to submit post: ${response.body}');
      }

    } catch (e) {
      // Handle any errors that occur during the submission process
      print('Error occurred while submitting post: $e');
    }
  }

  // Fetches a list of posts, supporting pagination
  Future<List<PostModel>> fetchPosts({
    int limit = 10,
    String? startAfterId,
  }) async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('fetchPosts');
      
      // Construct the URL with query parameters for pagination
      var uri = Uri.parse(url).replace(queryParameters: {
        // Specifies the maximum number of posts to fetch
        'limit': limit.toString(),

        // Specifies the ID of the last post fetched to enable fetching the next set of posts
        if (startAfterId != null) 'start_after': startAfterId,
      });

      // print("'n");
      // print("Token being sent:");
      // print(token);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // decode json response to list and return the list of PostModel objects
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((post) => PostModel.fromJson(post)).toList();
      } else {
        // Handle unsuccessful post submission
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      // handle any errors that occur during the fetch operation
      print(e);
      rethrow;
    }
  }

  // Fetches a list of posts that belong to a specific user
  Future<List<PostModel>> fetchUserPosts({
    required String userId,
    int limit = 10,
    String? startAfterId,
  }) async {
    try {
      // Retrieve the Firebase token of the current logged-in user
      String token = await authServices.getIdToken();

      String url = IPAddressAndRoutes.getRoute('fetchUserPosts');

      // Construct the URL with query parameters for pagination
      var uri = Uri.parse(url).replace(queryParameters: {
        'user_id': userId, // Add the user ID to the query parameters
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
        // Decode JSON response to list and return the list of PostModel objects
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((post) => PostModel.fromJson(post)).toList();
      } else {
        // Handle unsuccessful post submission
        throw Exception('Failed to load user posts');
      }
    } catch (e) {
      // Handle any errors that occur during the fetch operation
      print(e);
      rethrow;
    }
  }

}
