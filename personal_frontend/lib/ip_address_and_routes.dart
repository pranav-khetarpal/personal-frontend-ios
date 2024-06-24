
class IPAddressAndRoutes {
  // This specifies the host address on which the server will listen for incoming requests
  // This is a local address, so the server will only be accessible from the local machine
  // NOTE: This means that the backend code is being run on my local machine
  // static String ip_address = 'http://127.0.0.1:8000';

  // String of IP address on home wifi
  static String ipAddress = 'http://10.0.0.32:8000';

  // map to make retrieving routes easier when needed
  static Map<String, String> routes = {
    'createUser': '/user/create',
    'getOtherUser': '/user/',
    'getCurrentUser': '/user/current',
    'followOtherUser': '/user/follow',
    'unfollowOtherUser': '/user/unfollow',
    'logout': '/user/logout',
    'updateUser': '/user/update',
    'updateProfileImage': '/user/updateProfileImage',
    'checkUsernameAvailability': '/user/usernameAvailability',
    'deleteUser': '/user/delete',

    'searchUsername': '/search/users?username=',

    'createPost': '/posts/create',
    'fetchPosts': '/posts/fetch',
    'fetchUserPosts': '/posts/user',
    'likePost': '/posts/like/',
    'unlikePost': '/posts/unlike/',
    'deletePost': '/posts/delete/',

    'searchTicker': '/search/stocks?ticker=',

    'stockInfo': '/stock/info/',
    'stockPrices': '/stock/prices?',
    'deleteStockList': '/stock/stockLists/delete/',
    'updateStockList': '/stock/stockLists/update/',
    'createStockList': '/stock/stockLists/create',

    'createComment': '/comments/create',
    'deleteComment': '/comments/delete/',
    'fetchComments': '/comments/fetch',
    'likeComment': '/comments/like/',
    'unlikeComment': '/comments/unlike/',

    'isFollowingUser': '/user/is_following/',

  };

  // Returns the route for given needed for a specific operation, defined by the given key
  static String getRoute(String key) {
    final route = routes[key];
    if (route != null) {
      return '$ipAddress$route';
    } else {
      throw ArgumentError('No route defined for key: $key');
    }
  }


}
