import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:personal_frontend/pages/models/post_model.dart';
import 'package:personal_frontend/services/post_services.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  // Variables for pagination
  final List<PostModel> _posts = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String? _lastPostId;
  final int _limit = 10;

  // object to use PostService methods
  PostServices postServices = PostServices();

  @override
  void initState() {
    super.initState();
    _fetchInitialPosts(); // Fetch initial posts when the screen is loaded
  }

  // Fetch the initial posts
  Future<void> _fetchInitialPosts() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchPosts(); // Fetch posts from the server
    setState(() {
      _isLoading = false;
    });
  }

  // Fetch posts with pagination
  Future<void> _fetchPosts() async {
    try {
      String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
      // String? token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
      if (token == null) {
        throw Exception('Failed to retrieve Firebase token');
      }

      // makes sure to get rid of all new line characters
      token = token.replaceAll('\n', '').trim();

      print("\n");
      print("Firebase token from following feed page: $token");
      print("\n");

      List<PostModel> fetchedPosts = await postServices.fetchPosts(
        token: token,
        limit: _limit,
        startAfterId: _lastPostId,
      );

      setState(() {
        _posts.addAll(fetchedPosts);
        _hasMore = fetchedPosts.length == _limit;
        if (fetchedPosts.isNotEmpty) {
          _lastPostId = fetchedPosts.last.id;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Handle when the user refreshes the page
  Future<void> _refreshPosts() async {
      // When the user refreshes the page and new posts were created, update the state to reflect the change
    setState(() {
      _posts.clear();
      _lastPostId = null;
      _hasMore = true;
    });
    await _fetchInitialPosts();
  }

  // Load more posts when the user scrolls to the bottom
  Future<void> _loadMorePosts() async {
    if (_hasMore && !_isLoading) {
      setState(() {
        _isLoading = true;
      });
      await _fetchPosts();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Social Media'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.extentAfter == 0) {
              // Load more posts when the user scrolls to the bottom
              _loadMorePosts();
              return true;
            }
            return false;
          },
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    PostModel post = _posts[index];
                    return ListTile(
                      title: Text(post.content), // Display post content
                      subtitle: Text(post.timestamp.toLocal().toString()), // Display post timestamp
                    );
                  },
                ),
              ),
              if (_isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
