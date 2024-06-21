import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/post_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/pages/post_pages/post_and_comments_page.dart';
import 'package:personal_frontend/pages/profiles/other_user_profile.dart';
import 'package:personal_frontend/services/post_services.dart';

class PostTile extends StatefulWidget {
  final PostModel post;
  final UserModel postUser;
  final DateTime feedLoadTime;
  final UserModel currentUser;
  final bool allowCommentPageNavigation;

  // object to use PostServices methods
  final PostServices postServices;

  const PostTile({
    super.key,
    required this.post,
    required this.postUser,
    required this.feedLoadTime,
    required this.currentUser,
    required this.postServices,
    required this.allowCommentPageNavigation,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  // Variable to keep track of whether the current user liked the post or not
  late bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLikedByUser ?? false;
  }

  // Helper method to format the elapsed time
  String getElapsedTime(DateTime postTime) {
    final duration = widget.feedLoadTime.difference(postTime);
    if (duration.inDays > 0) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Method to show the delete post dialog
  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // delete button
              MySmallButton(
                text: 'Delete',
                onTap: () {
                  Navigator.of(context).pop(); // Close the current dialog
                  showConfirmationDialog(context); // Show confirmation dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // pop up to confirm whether the user would like to delete their post
  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the confirmation dialog
                await handleDeletePost(context); // Handle the post deletion
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }

  // Method to handle the deletion of a post
  Future<void> handleDeletePost(BuildContext context) async {
    try {
      await widget.postServices.deletePost(widget.post.id);
      if (context.mounted) {
        displayMessageToUser('Post deleted successfully', context);
      }
    } catch (e) {
      if (context.mounted) {
        displayMessageToUser('Failed to delete post: $e', context);
      }
    }
  }

  // Method to handle when the user would like to like or unlike the current post
  void handleLikePost() async {
    try {
      if (isLiked) {
        // if the user does like the current post, call the unlike post method
        await widget.postServices.unlikePost(widget.post.id);
        setState(() {
          widget.post.likes_count--;
          isLiked = false;
        });
      } else {
        // if the user does not like the current post, call the like post method
        await widget.postServices.likePost(widget.post.id);
        setState(() {
          widget.post.likes_count++;
          isLiked = true;
        });
      }
    } catch (e) {
      displayMessageToUser('Failed to like/unlike post: $e', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wrap the CircleAvatar with GestureDetector
                    GestureDetector(
                      onTap: () {
                        // Navigate to the user's profile page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherUserProfile(userID: widget.postUser.id),
                          ),
                        );
                      },
                      // Profile Image
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: widget.postUser.profile_image_url.isNotEmpty
                            ? NetworkImage(widget.postUser.profile_image_url)
                            : null,
                        onBackgroundImageError: (exception, stackTrace) {
                          print('Error loading profile image: $exception');
                        },
                        child: widget.postUser.profile_image_url.isEmpty
                            ? const Icon(Icons.account_circle, size: 50)
                            : null,
                      ),
                    ),

                    const SizedBox(width: 8),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Wrap the user's name and username with GestureDetector
                          GestureDetector(
                            onTap: () {
                              // Navigate to the user's profile page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtherUserProfile(userID: widget.postUser.id),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                // User's name and username
                                Expanded(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '${widget.postUser.name} ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '@${widget.postUser.username}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Elapsed time
                                Text(
                                  getElapsedTime(widget.post.timestamp),
                                  style: const TextStyle(color: Colors.grey),
                                ),

                                // Conditional rendering of IconButton for editing/deleting
                                if (widget.post.userId == widget.currentUser.id)
                                  IconButton(
                                    icon: const Icon(Icons.more_vert),
                                    onPressed: () {
                                      showDeleteDialog(context);
                                    },
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Post content
                          Text(
                            widget.post.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                          
                          const SizedBox(height: 8,),

                          // like button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // display the like Icon if it is not the current user's post
                                  if (widget.post.userId != widget.currentUser.id)
                                    IconButton(
                                      icon: isLiked ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                                      onPressed: handleLikePost,
                                    ),

                                  // number of likes
                                  Text('${widget.post.likes_count} likes'),
                                ],
                              ),

                              Row(
                                children: [
                                  
                                  if (widget.allowCommentPageNavigation)
                                    // display the comments button
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => PostAndCommentsPage(
                                              post: widget.post,
                                              postUser: widget.postUser,
                                              currentUser: widget.currentUser,
                                              postServices: widget.postServices,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.comment)
                                    ),

                                  // number of comments
                                  Text('${widget.post.comments_count} comments'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.allowCommentPageNavigation)
            Divider(
              color: Colors.grey.shade200,
              thickness: 1,
          ),
        ],
      ),
    );
  }
}
