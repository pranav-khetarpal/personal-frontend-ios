import 'package:flutter/material.dart';
import 'package:personal_frontend/models/post_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/services/comments_services.dart';

class PostAndCommentsPage extends StatefulWidget {
  final PostModel post;
  final UserModel postUser;
  final UserModel currentUser;

  const PostAndCommentsPage({
    super.key,
    required this.post,
    required this.postUser,
    required this.currentUser,
  });

  @override
  State<PostAndCommentsPage> createState() => _PostAndCommentsPageState();
}

class _PostAndCommentsPageState extends State<PostAndCommentsPage> {
  final CommentServices commentServices = CommentServices();
  final TextEditingController _commentController = TextEditingController();

  // Dummy comments data
  List<String> comments = [
    'This is the first comment!',
    'Here is another comment.',
    'Nice post!',
    'I totally agree with this!',
    'This is insightful.',
  ];

  // Method to add a comment
  Future<void> _addComment() async {
    if (_commentController.text.isEmpty) return;

    try {
      await commentServices.submitComment(
        postId: widget.post.id,
        content: _commentController.text,
      );
      setState(() {
        comments.add(_commentController.text);
        _commentController.clear();
      });
    } catch (e) {
      print('Error occurred while adding comment: $e');
    }
  }

  // Method to delete a comment
  Future<void> _deleteComment(int index, String commentId) async {
    try {
      await commentServices.deleteComment(
        postId: widget.post.id,
        commentId: commentId,
      );
      setState(() {
        comments.removeAt(index);
      });
    } catch (e) {
      print('Error occurred while deleting comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post and Comments'),
      ),
      body: Column(
        children: [
          // Display the post at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.postUser.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.post.content,
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
          const Divider(thickness: 1),

          // Display comments in a scrollable ListView
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                String commentId = 'dummy_comment_id_$index'; // This should be the actual comment ID from the backend
                return ListTile(
                  title: Text(comments[index]),
                  trailing: widget.currentUser.id == widget.postUser.id
                      ? IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteComment(index, commentId),
                        )
                      : null,
                );
              },
            ),
          ),

          // TextField and Post Button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Write a comment...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
