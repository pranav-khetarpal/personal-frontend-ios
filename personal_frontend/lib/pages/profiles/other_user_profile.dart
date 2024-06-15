import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_post_tile.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
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
  // variables for fetching the profile information for the user in question
  late Future<UserModel> futureUser;
  UserModel? userProfile;
  UserModel? currentUser;
  bool isLoadingUserProfile = true;
  bool isLoadingCurrentUser = true;

  // variables for loading the user's posts
  final List<PostModel> posts = [];
  bool isLoadingPosts = false;
  bool hasMorePosts = true;
  String? lastPostId;
  final int postLimit = 10;

  // objects to access method in PostServices and UserInteractionServices classes
  final PostServices postServices = PostServices();
  final UserInteractionServices userInteractionServices = UserInteractionServices();

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
      UserModel user = await userInteractionServices.fetchUserProfile(widget.userID);
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
      UserModel user = await userInteractionServices.fetchCurrentUser();
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
      await userInteractionServices.followUser(userIdToFollow, currentUser!);
      setState(() {
        currentUser!.following.add(userIdToFollow);
      });
    } catch (e) {
      // Log the error
      print('Error following user: $e');

      // Show an error message to the user
      displayMessageToUser('Error following user: $e', context);
    }
  }

  // Handle the follow button press
  Future<void> toggleFollowUser(String userIdToFollow) async {
    if (currentUser == null) {
      return;
    }

    try {
      if (currentUser!.following.contains(userIdToFollow)) {
        // If the user is already following, unfollow them
        await userInteractionServices.unfollowUser(userIdToFollow, currentUser!);
        setState(() {
          currentUser!.following.remove(userIdToFollow);
        });
      } else {
        // If the user is not following, follow them
        await userInteractionServices.followUser(userIdToFollow, currentUser!);
        setState(() {
          currentUser!.following.add(userIdToFollow);
        });
      }
    } catch (e) {
      // Log the error
      print('Error toggling follow status: $e');

      // Show an error message to the user
      displayMessageToUser('Error toggling follow status: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {

    // Check if the current user is viewing their own profile
    bool isCurrentUserProfile = userProfile?.id == currentUser?.id;

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
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Column(
                            children: [
                              // Profile Image
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: userProfile!.profile_image_url.isNotEmpty
                                    ? NetworkImage(userProfile!.profile_image_url)
                                    : null,
                                onBackgroundImageError: (exception, stackTrace) {
                                  print('Error loading profile image: $exception');
                                  setState(() {
                                    // Fallback to default icon or image in case of an error
                                    userProfile!.profile_image_url = '';
                                  });
                                },
                                child: userProfile!.profile_image_url.isEmpty
                                    ? const Icon(Icons.account_circle, size: 50)
                                    : null,
                              ),

                              const SizedBox(height: 16),

                              Text(userProfile!.name, style: const TextStyle(fontSize: 24)),
                              Text('@${userProfile!.username}', style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  
                              // The user's bio
                              Text(userProfile!.bio, style: const TextStyle(fontSize: 20)),
                  
                              const SizedBox(height: 16),

                              // Show or hide the follow button based on whether it's the current user's profile
                              if (!isCurrentUserProfile)
                                // button to allow users to follow and unfollow the user in question
                                MySmallButton(
                                  text: currentUser!.following.contains(userProfile!.id) ? 'Following' : 'Follow',
                                  onTap: () => toggleFollowUser(userProfile!.id),
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
                            return PostTile(
                              post: post, 
                              postUser: userProfile!, 
                              feedLoadTime: DateTime.now(),
                              currentUser: currentUser!,
                              postServices: postServices,
                            );
                          },
                        ),
                      ),
                      if (isLoadingPosts)
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
