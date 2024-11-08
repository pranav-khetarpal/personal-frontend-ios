// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:personal_frontend/components/my_large_button.dart';
// import 'package:personal_frontend/components/my_expandable_textfield.dart';
// import 'package:personal_frontend/helper/helper_functions.dart';
// import 'package:personal_frontend/services/post_services.dart';

// class AddPostHome extends StatefulWidget {
//   const AddPostHome({super.key});

//   @override
//   State<AddPostHome> createState() => _AddPostState();
// }

// class _AddPostState extends State<AddPostHome> {
//   final TextEditingController postController = TextEditingController();
//   bool isLoading = false;

//   // Object to use PostServices methods
//   final PostServices postServices = PostServices();

//   @override
//   void initState() {
//     super.initState();
//     showIntroMessage(); // Show intro message if it's the first time
//   }

//   Future<void> showIntroMessage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     bool isFirstTime = prefs.getBool('isFirstTimeAddPost') ?? true;

//     if (isFirstTime) {
//       await showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Create a Post"),
//           content: const Text("This is where you can create a new post. Your post will be visible to other users in the app."),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text("Got it!"),
//             ),
//           ],
//         ),
//       );

//       // Set the flag to false so the intro message won't be shown again
//       await prefs.setBool('isFirstTimeAddPost', false);
//     }
//   }

//   // Method to handle the submission of a post
//   Future<void> submitPost() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       // Retrieve the text that the user inputted
//       String content = postController.text;

//       if (content.isEmpty) {
//         setState(() {
//           isLoading = false;
//         });
//         return;
//       }

//       // Call the submitPost method to handle the submission of posts
//       await postServices.submitPost(
//         content: content,
//       );

//       displayMessageToUser('Post created successfully', context);

//       setState(() {
//         isLoading = false;
//       });

//       postController.clear();

//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });

//       print('Error occurred while submitting post: $e');

//       displayMessageToUser('Failed to submit post: $e', context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Post'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(25.0),
//         child: Column(
//           children: [
//             MyExpandableTextfield(
//               controller: postController,
//               hintText: 'What\'s on your mind?',
//               maxLength: 280,
//               allowSpaces: true,
//             ),
//             const SizedBox(height: 16.0),
//             isLoading
//                 ? const CircularProgressIndicator()
//                 : MyLargeButton(
//                     onTap: submitPost,
//                     text: 'Post',
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:personal_frontend/pages/following_feed.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_frontend/components/my_large_button.dart';
import 'package:personal_frontend/components/my_expandable_textfield.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/services/post_services.dart';

class AddPostHome extends StatefulWidget {
  const AddPostHome({super.key});

  @override
  State<AddPostHome> createState() => _AddPostState();
}

class _AddPostState extends State<AddPostHome> {
  final TextEditingController postController = TextEditingController();
  bool isLoading = false;

  // Object to use PostServices methods
  final PostServices postServices = PostServices();

  @override
  void initState() {
    super.initState();
    showIntroMessage(); // Show intro message if it's the first time
  }

  Future<void> showIntroMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeAddPost') ?? true;

    if (isFirstTime) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Create a Post"),
          content: const Text("This is where you can create a new post. Your post will be visible to other users in the app."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Got it!"),
            ),
          ],
        ),
      );

      // Set the flag to false so the intro message won't be shown again
      await prefs.setBool('isFirstTimeAddPost', false);
    }
  }

  // Method to handle the submission of a post
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

      displayMessageToUser('Post created successfully, and you have automatically liked your post.', context);

      setState(() {
        isLoading = false;
      });

      postController.clear();

      // Navigate back to the FollowingFeed page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FollowingFeed()),
        (Route<dynamic> route) => false,
      );

    } catch (e) {
      setState(() {
        isLoading = false;
      });

      print('Error occurred while submitting post: $e');

      displayMessageToUser('Failed to submit post: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
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
                : MyLargeButton(
                    onTap: submitPost,
                    text: 'Post',
                  ),
          ],
        ),
      ),
    );
  }
}
