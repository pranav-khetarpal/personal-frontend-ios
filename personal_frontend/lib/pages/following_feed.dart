// import 'package:flutter/material.dart';
// import 'package:personal_frontend/components/my_post_tile.dart';
// import 'package:personal_frontend/models/post_model.dart';
// import 'package:personal_frontend/models/user_model.dart';
// import 'package:personal_frontend/pages/post_pages/add_post.dart';
// import 'package:personal_frontend/pages/search_users.dart';
// import 'package:personal_frontend/services/authorization_services.dart';
// import 'package:personal_frontend/services/post_services.dart';
// import 'package:personal_frontend/services/user_interation_services.dart';

// // Class needed to ensure bottom navigation bar is present in subpages
// class FollowingFeed extends StatelessWidget {
//   const FollowingFeed({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const FollowingFeedHome();
//   }
// }

// class FollowingFeedHome extends StatefulWidget {
//   const FollowingFeedHome({super.key});

//   @override
//   State<FollowingFeedHome> createState() => _FollowingFeedHomeState();
// }

// class _FollowingFeedHomeState extends State<FollowingFeedHome> {
//   // Variables for pagination and display of posts
//   final List<PostModel> posts = [];
//   final Map<String, UserModel> users = {};
//   bool isLoading = false;
//   bool hasMore = true;
//   String? lastPostId;
//   final int limit = 10;

//   late DateTime feedLoadTime; // Variable to track the time that the feed was loaded

//   // Object to use PostServices / AuthServices / UserInteractionServices methods
//   final PostServices postServices = PostServices();
//   final AuthServices authServices = AuthServices();
//   final UserInteractionServices userInteractionServices = UserInteractionServices();

//   // varible to get the UserModel of the current logged in user
//   UserModel? currentUser;

//   @override
//   void initState() {
//     super.initState();
//     feedLoadTime = DateTime.now(); // Capture the current time
//     fetchCurrentUser(); // Fetch the UserModel of the current user
//     fetchInitialPosts(); // Fetch initial posts when the screen is loaded
//   }

//   // Fetch the current user's profile
//   Future<void> fetchCurrentUser() async {
//     try {
//       UserModel user = await userInteractionServices.fetchCurrentUser();
//       setState(() {
//         currentUser = user;
//       });
//     } catch (error) {
//       // Handle error fetching current user
//       print('Error fetching current user: $error');
//     }
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
//       // Call the fetchPosts method to get a list of posts
//       List<PostModel> fetchedPosts = await postServices.fetchPosts(
//         limit: limit,
//         startAfterId: lastPostId,
//       );

//       // Fetch user information for each post
//       for (var post in fetchedPosts) {
//         if (!users.containsKey(post.userId)) {
//           UserModel user = await userInteractionServices.fetchUserProfile(post.userId);
//           users[post.userId] = user;
//         }
//       }

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
//       users.clear();
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
//         title: const Text("Stock Social Media"),
//         actions: [

//           IconButton(
//             icon: const Icon(Icons.search),
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) => const SearchUsersHome()),
//               );
//             }
//           )

//           // IconButton(
//           //   icon: const Icon(Icons.message),
//           //   onPressed: () {
//           //     Navigator.of(context).push(
//           //       MaterialPageRoute(builder: (context) => const UserMessage()),
//           //     );

//           //     // Navigator.push(
//           //     //   context,
//           //     //   MaterialPageRoute(builder: (context) => const UserMessage()),
//           //     // );
//           //   },
//           // ),
//         ],
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
//           child: Padding(
//             padding: const EdgeInsets.all(25.0),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: posts.length,
//                     itemBuilder: (context, index) {
//                       PostModel post = posts[index];
//                       UserModel? user = users[post.userId];
//                       return user != null
//                           ? PostTile(
//                             post: post, 
//                             postUser: user, 
//                             feedLoadTime: feedLoadTime,
//                             currentUser: currentUser!,
//                             postServices: postServices,
//                             allowCommentPageNavigation: true,
//                           )
//                           : const Center(child: CircularProgressIndicator());
//                     },
//                   ),
//                 ),
//                 if (isLoading)
//                   const Center(child: CircularProgressIndicator()),
//               ],
//             ),
//           ),
//         ),
//       ),

//       // Icon button to add a new post
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const AddPostHome()),
//           );
//         },
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:personal_frontend/components/my_post_tile.dart';
import 'package:personal_frontend/models/post_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/pages/post_pages/add_post.dart';
import 'package:personal_frontend/pages/search_users.dart';
import 'package:personal_frontend/services/authorization_services.dart';
import 'package:personal_frontend/services/post_services.dart';
import 'package:personal_frontend/services/user_interation_services.dart';

// Class needed to ensure bottom navigation bar is present in subpages
class FollowingFeed extends StatelessWidget {
  const FollowingFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return const FollowingFeedHome();
  }
}

class FollowingFeedHome extends StatefulWidget {
  const FollowingFeedHome({super.key});

  @override
  State<FollowingFeedHome> createState() => _FollowingFeedHomeState();
}

class _FollowingFeedHomeState extends State<FollowingFeedHome> {
  // Variables for pagination and display of posts
  final List<PostModel> posts = [];
  final Map<String, UserModel> users = {};
  bool isLoading = false;
  bool hasMore = true;
  String? lastPostId;
  final int limit = 10;

  late DateTime feedLoadTime; // Variable to track the time that the feed was loaded

  // Object to use PostServices / AuthServices / UserInteractionServices methods
  final PostServices postServices = PostServices();
  final AuthServices authServices = AuthServices();
  final UserInteractionServices userInteractionServices = UserInteractionServices();

  // Variable to get the UserModel of the current logged-in user
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    feedLoadTime = DateTime.now(); // Capture the current time
    fetchCurrentUser(); // Fetch the UserModel of the current user
    fetchInitialPosts(); // Fetch initial posts when the screen is loaded
    showIntroMessages(); // Show intro messages if it's the first time
  }

  // Fetch the current user's profile
  Future<void> fetchCurrentUser() async {
    try {
      UserModel user = await userInteractionServices.fetchCurrentUser();
      setState(() {
        currentUser = user;
      });
    } catch (error) {
      // Handle error fetching current user
      print('Error fetching current user: $error');
    }
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
          UserModel user = await userInteractionServices.fetchUserProfile(post.userId);
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

  // Show introductory messages if it's the first time the user is visiting
  Future<void> showIntroMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTimeFollowingFeed') ?? true;

    if (isFirstTime) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Welcome!"),
          content: const Text("This is your feed page. Here you will see posts from users you follow."),
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

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Search Users"),
          content: const Text("Use the search icon to find other users."),
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

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Create Post"),
          content: const Text("Use the + icon to create a new post."),
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

      // Set the flag to false so the intro messages won't be shown again
      await prefs.setBool('isFirstTimeFollowingFeed', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Social Media"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 40),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchUsersHome()),
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
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: posts.isNotEmpty ? buildPostList() : buildEmptyMessage(), // Conditionally render content
          ),
        ),
      ),
      // Icon button to add a new post
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostHome()),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build post list widget
  Widget buildPostList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              PostModel post = posts[index];
              UserModel? user = users[post.userId];
              return user != null
                  ? PostTile(
                      post: post,
                      postUser: user,
                      feedLoadTime: feedLoadTime,
                      currentUser: currentUser!,
                      postServices: postServices,
                      allowCommentPageNavigation: true,
                    )
                  : const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        if (isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  // Build empty message widget
  Widget buildEmptyMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "You are not following anyone yet.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          const Text(
            "Follow users to see their posts here.",
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 16),

          MySmallButton(
            text: "Search Users", 
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SearchUsersHome()),
              );
            },
          ),

          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(builder: (context) => const SearchUsersHome()),
          //     );
          //   },
          //   child: const Text("Search Users"),
          // ),
        ],
      ),
    );
  }
}
