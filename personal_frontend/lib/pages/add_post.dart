import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_textfield.dart';
import 'package:personal_frontend/services/post_services.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController postController = TextEditingController();
  bool isLoading = false;

  // object to use PostServices methods
  final PostServices postServices = PostServices();

  Future<void> submitPost() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Retrieve the text that the user inputted
      String content = postController.text;

      if (content.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // Call the submitPost method to handle the submission of posts
      await postServices.submitPost(
        content: content,
      );

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post created successfully')),
        );

      setState(() {
        isLoading = false;
      });

      postController.clear();

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error occurred while submitting post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit post: $e'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyTextField(
              controller: postController,
              hintText: 'What\'s on your mind?',
              obscureText: false,
              maxLength: 280,
              allowSpaces: true,
            ),
            const SizedBox(height: 16.0),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: submitPost,
                    child: const Text('Post'),
                  ),
          ],
        ),
      ),
    );
  }
}

