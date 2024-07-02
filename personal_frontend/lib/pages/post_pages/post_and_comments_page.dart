import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_comment_tile.dart';
import 'package:personal_frontend/components/my_post_tile.dart';
import 'package:personal_frontend/components/my_square_textfield.dart';
import 'package:personal_frontend/models/comment_model.dart';
import 'package:personal_frontend/models/post_model.dart';
import 'package:personal_frontend/models/user_model.dart';
import 'package:personal_frontend/services/comments_services.dart';
import 'package:personal_frontend/services/post_services.dart';
import 'package:personal_frontend/services/user_interation_services.dart';

class PostAndCommentsPage extends StatefulWidget {
  final PostModel post;
  final UserModel postUser;
  final UserModel currentUser;
  final PostServices postServices;

  const PostAndCommentsPage({
    super.key,
    required this.post,
    required this.postUser,
    required this.currentUser,
    required this.postServices,
  });

  @override
  State<PostAndCommentsPage> createState() => _PostAndCommentsPageState();
}

class _PostAndCommentsPageState extends State<PostAndCommentsPage> {
  final List<CommentModel> comments = [];
  final Map<String, UserModel> commentUsers = {};
  bool isLoading = false;
  bool hasMore = true;
  String? lastCommentId;
  final int limit = 10;

  // object to use CommentServices methods
  final CommentServices commentServices = CommentServices();

  // text controller
  final TextEditingController commentController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchInitialComments();
  }

  // Method to fetch the initial comments when the page is loaded
  Future<void> fetchInitialComments() async {
    setState(() {
      isLoading = true;
    });
    await fetchComments();
    setState(() {
      isLoading = false;
    });
  }

  // Method fetch comments up to a certain limit at a time
  Future<void> fetchComments() async {
    try {
      List<CommentModel> fetchedComments = await commentServices.fetchComments(
        postId: widget.post.id,
        limit: limit,
        startAfterId: lastCommentId,
      );

      for (var comment in fetchedComments) {
        if (!commentUsers.containsKey(comment.userId)) {
          UserModel user = await UserInteractionServices().fetchUserProfile(comment.userId);
          commentUsers[comment.userId] = user;
        }
      }

      setState(() {
        comments.addAll(fetchedComments);
        hasMore = fetchedComments.length == limit;
        if (fetchedComments.isNotEmpty) {
          lastCommentId = fetchedComments.last.id;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Refresh the comment feed when the user chooses to do so
  Future<void> refreshComments() async {
    setState(() {
      comments.clear();
      commentUsers.clear();
      lastCommentId = null;
      hasMore = true;
    });
    await fetchInitialComments();
  }

  // Load more comments when the user scrolls to the bottom of their available feed
  Future<void> loadMoreComments() async {
    if (hasMore && !isLoading) {
      setState(() {
        isLoading = true;
      });
      await fetchComments();
      setState(() {
        isLoading = false;
      });
    }
  }

    // Method to add a comment
  Future<void> addComment() async {
    if (commentController.text.isEmpty) return;

    try {
      await commentServices.submitComment(
        postId: widget.post.id,
        content: commentController.text,
      );

      setState(() {
        refreshComments();
        commentController.clear();
      });
    } catch (e) {
      print('Error occurred while adding comment: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post and Comments"),
      ),
      body: RefreshIndicator(
        onRefresh: refreshComments,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.extentAfter == 0) {
              loadMoreComments();
              return true;
            }
            return false;
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 202, 231, 255),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: PostTile(
                    post: widget.post,
                    postUser: widget.postUser,
                    feedLoadTime: DateTime.now(),
                    currentUser: widget.currentUser,
                    postServices: widget.postServices,
                    allowCommentPageNavigation: false,
                  ),
                ),

                const SizedBox(height: 16.0),

                Expanded(
                  child: ListView.builder(
                    itemCount: comments.length + 1,
                    itemBuilder: (context, index) {
                      if (index == comments.length) {
                        return hasMore
                            ? const Center(child: CircularProgressIndicator())
                            : const SizedBox.shrink();
                      }
                      CommentModel comment = comments[index];
                      UserModel? commentUser = commentUsers[comment.userId];
                      return commentUser != null
                          ? CommentTile(
                              comment: comment,
                              commentUser: commentUser,
                              feedLoadTime: DateTime.now(),
                              currentUser: widget.currentUser,
                              commentServices: commentServices,
                              postId: widget.post.id,
                            )
                          : const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),

                const SizedBox(height: 8.0),

                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 202, 231, 255),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: MySquareTextField(
                            hintText: "Write a comment...", 
                            obscureText: false, 
                            controller: commentController, 
                            maxLength: 280, 
                            allowSpaces: true,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: addComment,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
