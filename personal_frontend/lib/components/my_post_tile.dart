import 'package:flutter/material.dart';
import 'package:personal_frontend/models/post_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/pages/profiles/other_user_profile.dart';

class PostTile extends StatelessWidget {
  final PostModel post;
  final UserModel user;
  final DateTime feedLoadTime;

  const PostTile({
    Key? key,
    required this.post,
    required this.user,
    required this.feedLoadTime,
  }) : super(key: key);

  // Helper method to format the elapsed time
  String getElapsedTime(DateTime postTime) {
    final duration = feedLoadTime.difference(postTime);
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
                            builder: (context) => OtherUserProfile(userID: user.id),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person),
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
                                  builder: (context) => OtherUserProfile(userID: user.id),
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
                                          text: '${user.name} ',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '@${user.username}',
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
                                  getElapsedTime(post.timestamp),
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Post content
                          Text(
                            post.content,
                            style: const TextStyle(fontSize: 16),
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
            color: Theme.of(context).colorScheme.inversePrimary,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}

