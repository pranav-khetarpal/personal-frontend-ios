import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:personal_frontend/ip_address_and_routes.dart';
import 'package:personal_frontend/pages/models/post_model.dart';

class PostServices {
  // Handle the creation of a new post
  Future<void> submitPost({
    required String content,
    required String token,
    required BuildContext context,
  }) async {
    try {
      String url = IPAddressAndRoutes.getRoute('createPost');

      // Send the post data to the backend
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'content': content}),
      );

      if (response.statusCode == 200) {
        // If the post was successful, show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully')),
        );
      } else {
        // Handle unsuccessful post submission
        throw Exception('Failed to submit post: ${response.body}');
      }

    } catch (e) {
      // Handle any errors that occur during the submission process
      print('Error occurred while submitting post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit post: $e'))
      );
    }
  }

  // Fetches a list of posts from a backend server, supporting pagination
  Future<List<PostModel>> fetchPosts({
    required String token,
    int limit = 10,
    String? startAfterId,
  }) async {
    try {

      String url = IPAddressAndRoutes.getRoute('fetchPosts');
      
      // Construct the URL with query parameters for pagination
      var uri = Uri.parse(url).replace(queryParameters: {
        // Specifies the maximum number of posts to fetch
        'limit': limit.toString(),

        // Specifies the ID of the last post fetched to enable fetching the next set of posts
        if (startAfterId != null) 'start_after': startAfterId,
      });

      // get rid of all special characters
      token = token.replaceAll(RegExp(r'\s'), '').trim();
      print("Token being sent: $token");

      // Make an HTTP GET request to the server to fetch posts
      final response = await http.get(
        uri,
        headers: {
          // Include the authorization token in the request headers
          'Authorization': 'Bearer $token',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Check if the request was successful and process the response
      if (response.statusCode == 200) {
        // decode json response to list and return the list of PostModel objects
        List jsonResponse = jsonDecode(response.body);
        return jsonResponse.map((post) => PostModel.fromJson(post)).toList();
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      // handle any errors that occur during the fetch operation
      print(e);
      rethrow;
    }
  }

}
