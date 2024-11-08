import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_post_tile.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:personal_frontend/models/post_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/pages/account_management/edit_profile_page.dart';
import 'package:personal_frontend/pages/account_management/settings_page.dart';
import 'package:personal_frontend/services/post_services.dart';
import 'package:personal_frontend/services/user_interation_services.dart';

class CurrentUserProfile extends StatelessWidget {
  const CurrentUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const CurrentUserProfileHome();
  }
}

class CurrentUserProfileHome extends StatefulWidget {
  const CurrentUserProfileHome({super.key});

  @override
  State<CurrentUserProfileHome> createState() => _CurrentUserProfileState();
}

class _CurrentUserProfileState extends State<CurrentUserProfileHome> {
  // variables for displaying the user's information
  late Future<UserModel> futureUser;
  UserModel? currentUser;
  bool isLoadingCurrentUser = true;

  // variables for displaying the user's posts with pagination
  final List<PostModel> posts = [];
  bool isLoading = false;
  bool hasMore = true;
  String? lastPostId;
  final int limit = 10;

  // objects for PostServices and UserServices methods
  final PostServices postServices = PostServices();
  final UserInteractionServices userInteractionServices = UserInteractionServices();

  @override
  void initState() {
    super.initState();
    fetchCurrentUser(); // Fetch the current user's profile
  }

  // Fetch the current user's profile and posts
  Future<void> fetchCurrentUser() async {
    try {
      UserModel user = await userInteractionServices.fetchCurrentUser();
      setState(() {
        currentUser = user;
        isLoadingCurrentUser = false;
      });
      // Fetch the initial posts after fetching the current user
      await fetchInitialPosts();
    } catch (error) {
      setState(() {
        isLoadingCurrentUser = false;
      });
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
    if (currentUser == null) return; // Ensure currentUser is not null

    try {
      List<PostModel> fetchedPosts = await postServices.fetchUserPosts(
        userId: currentUser!.id,
        limit: limit,
        startAfterId: lastPostId,
      );

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
    setState(() {
      posts.clear();
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
        title: const Text("MarketGather"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsPage(user: currentUser,)),
              );
            },
          ),
        ],
      ),
      body: isLoadingCurrentUser
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            children: [
                              // Profile image
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: currentUser!.profileImageUrl.isNotEmpty
                                    ? NetworkImage(currentUser!.profileImageUrl)
                                    : null,
                                onBackgroundImageError: (exception, stackTrace) {
                                  print('Error loading profile image: $exception');
                                  setState(() {
                                    // Fallback to default icon or image in case of an error
                                    currentUser!.profileImageUrl = '';
                                  });
                                },
                                child: currentUser!.profileImageUrl.isEmpty
                                    ? const Icon(Icons.account_circle, size: 50)
                                    : null,
                              ),

                              const SizedBox(height: 16),

                              // Display username and bio
                              Text(currentUser!.name, style: const TextStyle(fontSize: 24)),
                              Text('@${currentUser!.username}', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary)),
                              const SizedBox(height: 8),
                              Text(currentUser!.bio, style: const TextStyle(fontSize: 20)),

                              const SizedBox(height: 16),

                              // Display followers and following count
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        '${currentUser!.followersCount}',
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        'Followers',
                                        style: TextStyle(fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 24),
                                  Column(
                                    children: [
                                      Text(
                                        '${currentUser!.followingCount}',
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      const Text(
                                        'Following',
                                        style: TextStyle(fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Button to allow the user to edit their profile information
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MySmallButton(
                                    text: "Edit Profile",
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => const EditProfilePage()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            PostModel post = posts[index];
                            return PostTile(
                              post: post,
                              postUser: currentUser!,
                              feedLoadTime: DateTime.now(),
                              currentUser: currentUser!,
                              postServices: postServices,
                              allowCommentPageNavigation: true,
                            );
                          },
                        ),
                      ),
                      if (isLoading)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:personal_frontend/components/my_post_tile.dart';
// import 'package:personal_frontend/components/my_small_button.dart';
// import 'package:personal_frontend/models/post_model.dart';
// import 'package:personal_frontend/models/user_model.dart';
// import 'package:personal_frontend/pages/account_management/edit_profile_page.dart';
// import 'package:personal_frontend/pages/account_management/settings_page.dart';
// import 'package:personal_frontend/services/post_services.dart';
// import 'package:personal_frontend/services/user_interation_services.dart';

// class CurrentUserProfile extends StatelessWidget {
//   const CurrentUserProfile({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const CurrentUserProfileHome();
//   }
// }

// class CurrentUserProfileHome extends StatefulWidget {
//   const CurrentUserProfileHome({super.key});

//   @override
//   State<CurrentUserProfileHome> createState() => _CurrentUserProfileState();
// }

// class _CurrentUserProfileState extends State<CurrentUserProfileHome> {
//   // variables for displaying the user's information
//   late Future<UserModel> futureUser;
//   UserModel? currentUser;
//   bool isLoadingCurrentUser = true;

//   // variables for displaying the user's posts with pagination
//   final List<PostModel> posts = [];
//   bool isLoading = false;
//   bool hasMore = true;
//   String? lastPostId;
//   final int limit = 10;

//   // objects for PostServices and UserServices methods
//   final PostServices postServices = PostServices();
//   final UserInteractionServices userInteractionServices = UserInteractionServices();

//   @override
//   void initState() {
//     super.initState();
//     fetchCurrentUser(); // Fetch the current user's profile
//   }

//   // Fetch the current user's profile and posts
//   Future<void> fetchCurrentUser() async {
//     try {
//       UserModel user = await userInteractionServices.fetchCurrentUser();
//       setState(() {
//         currentUser = user;
//         isLoadingCurrentUser = false;
//       });
//       // Fetch the initial posts after fetching the current user
//       await fetchInitialPosts();
//     } catch (error) {
//       setState(() {
//         isLoadingCurrentUser = false;
//       });
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
//     if (currentUser == null) return; // Ensure currentUser is not null

//     try {
//       List<PostModel> fetchedPosts = await postServices.fetchUserPosts(
//         userId: currentUser!.id,
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
//         title: const Text("MarketGather"),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.settings),
//             onPressed: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) => SettingsPage(user: currentUser,)),
//               );
//             },
//           ),
//         ],
//       ),
//       body: isLoadingCurrentUser
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: refreshPosts,
//               child: NotificationListener<ScrollNotification>(
//                 onNotification: (scrollNotification) {
//                   if (scrollNotification is ScrollEndNotification &&
//                       scrollNotification.metrics.extentAfter == 0) {
//                     // Load more posts when the user scrolls to the bottom
//                     loadMorePosts();
//                     return true;
//                   }
//                   return false;
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(25.0),
//                   child: ListView(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Center(
//                           child: Column(
//                             children: [
//                               // Profile image
//                               CircleAvatar(
//                                 radius: 50,
//                                 backgroundImage: currentUser!.profileImageUrl.isNotEmpty
//                                     ? NetworkImage(currentUser!.profileImageUrl)
//                                     : null,
//                                 onBackgroundImageError: (exception, stackTrace) {
//                                   print('Error loading profile image: $exception');
//                                   setState(() {
//                                     // Fallback to default icon or image in case of an error
//                                     currentUser!.profileImageUrl = '';
//                                   });
//                                 },
//                                 child: currentUser!.profileImageUrl.isEmpty
//                                     ? const Icon(Icons.account_circle, size: 50)
//                                     : null,
//                               ),

//                               const SizedBox(height: 16),

//                               // Display username and bio
//                               Text(currentUser!.name, style: const TextStyle(fontSize: 24)),
//                               Text('@${currentUser!.username}', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary)),
//                               const SizedBox(height: 8),
//                               Text(currentUser!.bio, style: const TextStyle(fontSize: 20)),

//                               const SizedBox(height: 16),

//                               // Display followers and following count
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       Text(
//                                         '${currentUser!.followersCount}',
//                                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                                       ),
//                                       const Text(
//                                         'Followers',
//                                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                                   const SizedBox(width: 24),
//                                   Column(
//                                     children: [
//                                       Text(
//                                         '${currentUser!.followingCount}',
//                                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                                       ),
//                                       const Text(
//                                         'Following',
//                                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),

//                               const SizedBox(height: 16),

//                               // Button to allow the user to edit their profile information
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   MySmallButton(
//                                     text: "Edit Profile",
//                                     onTap: () {
//                                       Navigator.of(context).push(
//                                         MaterialPageRoute(builder: (context) => const EditProfilePage()),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       // Post list or empty message
//                       posts.isNotEmpty ? buildPostList() : buildEmptyMessage(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }

//   // Build post list widget
//   Widget buildPostList() {
//     return Column(
//       children: [
//         ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: posts.length,
//           itemBuilder: (context, index) {
//             PostModel post = posts[index];
//             return PostTile(
//               post: post,
//               postUser: currentUser!,
//               feedLoadTime: DateTime.now(),
//               currentUser: currentUser!,
//               postServices: postServices,
//               allowCommentPageNavigation: true,
//             );
//           },
//         ),
//         if (isLoading)
//           const Center(child: CircularProgressIndicator()),
//       ],
//     );
//   }

//   // Build empty message widget
//   Widget buildEmptyMessage() {
//     return const Column(
//       children: [
//         Text(
//           "You have not created any posts yet.",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 16),
//         Text(
//           "Create a post to share your thoughts.",
//           style: TextStyle(fontSize: 16),
//         ),
//         SizedBox(height: 16),
//       ],
//     );
//   }
// }
