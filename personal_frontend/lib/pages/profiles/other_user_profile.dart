import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_post_tile.dart';
import 'package:personal_frontend/models/post_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/services/post_services.dart';
import 'package:personal_frontend/services/user_interation_services.dart';

class OtherUserProfile extends StatefulWidget {
  final String userID;

  const OtherUserProfile({
    super.key, 
    required this.userID,
  });

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  late Future<UserModel> futureUser;
  UserModel? userProfile;
  UserModel? currentUser;
  bool isLoadingUserProfile = true;
  bool isLoadingCurrentUser = true;

  final List<PostModel> posts = [];
  bool isLoadingPosts = false;
  bool hasMorePosts = true;
  String? lastPostId;
  final int postLimit = 10;

  final PostServices postServices = PostServices();
  final UserInteractionServices userServices = UserInteractionServices();

  @override
  void initState() {
    super.initState();
    fetchUserProfile(); // Fetch the profile of the other user
    fetchCurrentUser(); // Fetch the current user's profile
    fetchInitialPosts(); // Fetch initial posts when the screen is loaded
  }

  // Fetch the profile of the other user based on the provided userID
  Future<void> fetchUserProfile() async {
    try {
      UserModel user = await userServices.fetchUserProfile(widget.userID);
      setState(() {
        userProfile = user;
        isLoadingUserProfile = false;
      });
    } catch (error) {
      setState(() {
        isLoadingUserProfile = false;
      });
      // Handle error fetching user profile
      print('Error fetching user profile: $error');
    }
  }

  // Fetch the current user's profile
  Future<void> fetchCurrentUser() async {
    try {
      UserModel user = await userServices.fetchCurrentUser();
      setState(() {
        currentUser = user;
        isLoadingCurrentUser = false;
      });
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
      isLoadingPosts = true;
    });
    await fetchPosts(); // Fetch posts from the server
    setState(() {
      isLoadingPosts = false;
    });
  }

  // Fetch posts with pagination
  Future<void> fetchPosts() async {
    try {
      List<PostModel> fetchedPosts = await postServices.fetchUserPosts(
        userId: widget.userID, // Specify the user ID to fetch posts for the other user
        limit: postLimit,
        startAfterId: lastPostId,
      );

      setState(() {
        posts.addAll(fetchedPosts);
        hasMorePosts = fetchedPosts.length == postLimit;
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
      hasMorePosts = true;
    });
    await fetchInitialPosts();
  }

  // Load more posts when the user scrolls to the bottom
  Future<void> loadMorePosts() async {
    if (hasMorePosts && !isLoadingPosts) {
      setState(() {
        isLoadingPosts = true;
      });
      await fetchPosts();
      setState(() {
        isLoadingPosts = false;
      });
    }
  }

  // Handle the follow button press
  Future<void> followUser(String userIdToFollow) async {
    if (currentUser == null) {
      return;
    }
    
    try {
      // Calling the followUser method to add a new user to the following list and then update the state
      await userServices.followUser(userIdToFollow, currentUser!);
      setState(() {
        currentUser!.following.add(userIdToFollow);
      });
    } catch (e) {
      // Log the error
      print('Error following user: $e');

      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error following user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: isLoadingUserProfile || isLoadingCurrentUser
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            const Icon(Icons.account_circle, size: 100), // Placeholder icon for user image
                            const SizedBox(height: 16),
                            Text(userProfile!.name, style: const TextStyle(fontSize: 24)),
                            Text('@${userProfile!.username}', style: const TextStyle(fontSize: 18, color: Colors.grey)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: currentUser!.following.contains(userProfile!.id)
                                  ? null
                                  : () => followUser(userProfile!.id),
                              child: Text(currentUser!.following.contains(userProfile!.id) ? 'Following' : 'Follow'),
                            ),
                            // Add any other information you want to display about the user here
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index) {
                          PostModel post = posts[index];
                          return PostTile(post: post, user: userProfile!, feedLoadTime: DateTime.now());
                        },
                      ),
                    ),
                    if (isLoadingPosts)
                      const Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
            ),
    );
  }
}
