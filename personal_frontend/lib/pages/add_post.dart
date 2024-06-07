import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_expandable_textfield.dart';
import 'package:personal_frontend/services/post_services.dart';

// class needed to ensure bottom navigation bar is present in sub pages
class AddPost extends StatelessWidget {
  const AddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => const AddPostHome());
      },
    );
  }
}

class AddPostHome extends StatefulWidget {
  const AddPostHome({super.key});

  @override
  State<AddPostHome> createState() => _AddPostState();
}

class _AddPostState extends State<AddPostHome> {
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
            MyExpandableTextfield(
              controller: postController,
              hintText: 'What\'s on your mind?',
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

