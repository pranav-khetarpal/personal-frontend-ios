import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/models/comment_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/pages/profiles/other_user_profile.dart';
import 'package:personal_frontend/services/comments_services.dart';

class CommentTile extends StatefulWidget {
  final CommentModel comment;
  final UserModel commentUser;
  final DateTime feedLoadTime;
  final UserModel currentUser;

  // The id of the post is required for many operations that may be performed on comments
  final String postId;

  // object to use CommentServices methods
  final CommentServices commentServices;

  const CommentTile({
    super.key,
    required this.comment,
    required this.commentUser,
    required this.feedLoadTime,
    required this.currentUser,
    required this.commentServices,
    required this.postId,
  });

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  // Variable to keep track of whether the current user liked the comment or not
  late bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.comment.isLikedByUser ?? false;
  }

  // Helper method to format the elapsed time
  String getElapsedTime(DateTime commentTime) {
    final duration = widget.feedLoadTime.difference(commentTime);
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

  // Method to show the delete comment dialog
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

  // pop up to confirm whether the user would like to delete their comment
  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this comment?'),
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
                await handleDeleteComment(context); // Handle the comment deletion
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }

  // Method to handle the deletion of a comment
  Future<void> handleDeleteComment(BuildContext context) async {
    try {
      await widget.commentServices.deleteComment(
        postId: widget.postId,
        commentId: widget.comment.id,
      );
      if (context.mounted) {
        displayMessageToUser('Comment deleted successfully', context);
      }
    } catch (e) {
      if (context.mounted) {
        displayMessageToUser('Failed to delete comment: $e', context);
      }
    }
  }

  // Method to handle when the user would like to like or unlike the current comment
  void handleLikeComment() async {
    try {
      if (isLiked) {
        // if the user does like the current comment, call the unlike comment method
        await widget.commentServices.unlikeComment(widget.postId, widget.comment.id);
        setState(() {
          widget.comment.likes_count--;
          isLiked = false;
        });
      } else {
        // if the user does not like the current comment, call the like comment method
        await widget.commentServices.likeComment(widget.postId, widget.comment.id);

        setState(() {
          widget.comment.likes_count++;
          isLiked = true;
        });
      }
    } catch (e) {
      displayMessageToUser('Failed to like/unlike comment: $e', context);
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
                            builder: (context) => OtherUserProfile(userID: widget.commentUser.id),
                          ),
                        );
                      },
                      // Profile Image
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: widget.commentUser.profileImageUrl.isNotEmpty
                            ? NetworkImage(widget.commentUser.profileImageUrl)
                            : null,
                        onBackgroundImageError: (exception, stackTrace) {
                          print('Error loading profile image: $exception');
                        },
                        child: widget.commentUser.profileImageUrl.isEmpty
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
                                  builder: (context) => OtherUserProfile(userID: widget.commentUser.id),
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
                                          text: '${widget.commentUser.name} ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '@${widget.commentUser.username}',
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
                                  getElapsedTime(widget.comment.timestamp),
                                  style: const TextStyle(color: Colors.grey),
                                ),

                                // Conditional rendering of IconButton for editing/deleting
                                if (widget.comment.userId == widget.currentUser.id)
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
                          // Comment content
                          Text(
                            widget.comment.content,
                            style: const TextStyle(fontSize: 16),
                          ),
                          
                          const SizedBox(height: 8,),

                          // like button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // display the like Icon if it is not the current user's comment
                                  if (widget.comment.userId != widget.currentUser.id)
                                    IconButton(
                                      icon: isLiked ? const Icon(Icons.favorite) : const Icon(Icons.favorite_border),
                                      onPressed: handleLikeComment,
                                    ),

                                  // number of likes
                                  Text('${widget.comment.likes_count} likes'),
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
          Divider(
            color: Colors.grey.shade200,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
