// import 'package:flutter/material.dart';
// import 'package:personal_frontend/models/post_model.dart';
// import 'package:personal_frontend/services/authorization_services.dart';
// import 'package:personal_frontend/services/post_services.dart';

// class FollowingPage extends StatefulWidget {
//   const FollowingPage({super.key});

//   @override
//   State<FollowingPage> createState() => _FollowingPageState();
// }

// class _FollowingPageState extends State<FollowingPage> {
//   // Variables for pagination
//   final List<PostModel> posts = [];
//   bool isLoading = false;
//   bool hasMore = true;
//   String? lastPostId;
//   final int limit = 10;

//   // object to use PostServices methods
//   final PostServices postServices = PostServices();

//   // object to user AuthServices methods
//   final AuthServices authServices = AuthServices();

//   @override
//   void initState() {
//     super.initState();
//     fetchInitialPosts(); // Fetch initial posts when the screen is loaded
//   }

//   // Fetch the initial posts
//   Future<void> fetchInitialPosts() async {
//     setState(() {
//       isLoading = true;
//     });
//     await fetchPosts(); // Fetch posts from the server
//     setState(() {
//       isLoading = false;
//     });
//   }

//   // Fetch posts with pagination
//   Future<void> fetchPosts() async {
//     try {
//       // call the fetchPosts method to get a list of posts
//       List<PostModel> fetchedPosts = await postServices.fetchPosts(
//         limit: limit,
//         startAfterId: lastPostId,
//       );

//       setState(() {
//         posts.addAll(fetchedPosts);
//         hasMore = fetchedPosts.length == limit;
//         if (fetchedPosts.isNotEmpty) {
//           lastPostId = fetchedPosts.last.id;
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   // Handle when the user refreshes the page
//   Future<void> refreshPosts() async {
//     // When the user refreshes the page and new posts were created, update the state to reflect the change
//     setState(() {
//       posts.clear();
//       lastPostId = null;
//       hasMore = true;
//     });
//     await fetchInitialPosts();
//   }

//   // Load more posts when the user scrolls to the bottom
//   Future<void> loadMorePosts() async {
//     if (hasMore && !isLoading) {
//       setState(() {
//         isLoading = true;
//       });
//       await fetchPosts();
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stock Social Media'),
//       ),
//       body: RefreshIndicator(
//         onRefresh: refreshPosts,
//         child: NotificationListener<ScrollNotification>(
//           onNotification: (scrollNotification) {
//             if (scrollNotification is ScrollEndNotification &&
//                 scrollNotification.metrics.extentAfter == 0) {
//               // Load more posts when the user scrolls to the bottom
//               loadMorePosts();
//               return true;
//             }
//             return false;
//           },
//           child: Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: posts.length,
//                   itemBuilder: (context, index) {
//                     PostModel post = posts[index];
//                     return ListTile(
//                       title: Text(post.content), // Display post content
//                       subtitle: Text(post.timestamp.toLocal().toString()), // Display post timestamp
//                     );
//                   },
//                 ),
//               ),
//               if (isLoading)
//                 const Center(child: CircularProgressIndicator()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_post_tile.dart';
import 'package:personal_frontend/models/post_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/pages/message.dart';
import 'package:personal_frontend/services/authorization_services.dart';
import 'package:personal_frontend/services/post_services.dart';
import 'package:personal_frontend/services/user_services.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  // Variables for pagination and display of posts
  final List<PostModel> posts = [];
  final Map<String, UserModel> users = {};
  bool isLoading = false;
  bool hasMore = true;
  String? lastPostId;
  final int limit = 10;

  late DateTime feedLoadTime;     // variable to track the time that the feed was loaded

  // Object to use PostServices methods
  final PostServices postServices = PostServices();

  // Object to use AuthServices methods
  final AuthServices authServices = AuthServices();

  // Object to use UserServices methods
  final UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    feedLoadTime = DateTime.now(); // Capture the current time
    fetchInitialPosts(); // Fetch initial posts when the screen is loaded
  }

  // Fetch the initial posts
  Future<void> fetchInitialPosts() async {
    setState(() {
      isLoading = true;
    });
    await fetchPosts(); // Fetch posts from the server
    setState(() {
      isLoading = false;
    });
  }

  // Fetch posts with pagination
  Future<void> fetchPosts() async {
    try {

      // Call the fetchPosts method to get a list of posts
      List<PostModel> fetchedPosts = await postServices.fetchPosts(
        limit: limit,
        startAfterId: lastPostId,
      );

      // Fetch user information for each post
      for (var post in fetchedPosts) {
        if (!users.containsKey(post.userId)) {
          UserModel user = await userServices.fetchUserProfile(post.userId);
          users[post.userId] = user;
        }
      }

      setState(() {
        posts.addAll(fetchedPosts);
        hasMore = fetchedPosts.length == limit;
        if (fetchedPosts.isNotEmpty) {
          lastPostId = fetchedPosts.last.id;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Handle when the user refreshes the page
  Future<void> refreshPosts() async {
    // When the user refreshes the page and new posts were created, update the state to reflect the change
    setState(() {
      posts.clear();
      users.clear();
      lastPostId = null;
      hasMore = true;
    });
    await fetchInitialPosts();
  }

  // Load more posts when the user scrolls to the bottom
  Future<void> loadMorePosts() async {
    if (hasMore && !isLoading) {
      setState(() {
        isLoading = true;
      });
      await fetchPosts();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Social Media"),
        actions: [
          IconButton(
            icon: const Icon(Icons.message), 
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UserMessage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshPosts,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.extentAfter == 0) {
              // Load more posts when the user scrolls to the bottom
              loadMorePosts();
              return true;
            }
            return false;
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    PostModel post = posts[index];
                    UserModel? user = users[post.userId];
                    return user != null
                        ? PostTile(post: post, user: user, feedLoadTime: feedLoadTime)
                        : const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              if (isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
