
class IPAddressAndRoutes {
  // This specifies the host address on which the server will listen for incoming requests
  // This is a local address, so the server will only be accessible from the local machine
  // NOTE: This means that the backend code is being run on my local machine
  // static String ip_address = 'http://127.0.0.1:8000';

  // String of IP address on home wifi
  static String ip_address = 'http://10.0.0.32:8000';

  // map to make retrieving routes easier when needed
  static Map<String, String> routes = {
    'createUser': '/user/create',
    
    'getOtherUser': '/user/',
    'getCurrentUser': '/user/current',
    'followOtherUser': '/user/follow',
    
    'searchUsername': '/search/users?username=',

    'createPost': '/posts/create',
    'fetchPosts': '/posts/fetch',

    'logout': '/user/logout',

    'deleteUser': '/user/delete',

    'searchTicker': '/search/stocks?ticker=',
    'stockInfo': '/stock/info/',

    'fetchUserPosts': '/posts/user',

    'stockPrices': '/stock/prices?',

    'updateUser': '/user/update',

    'checkUsernameAvailability': '/user/usernameAvailability',

    'unfollowOtherUser': '/user/unfollow',
  };

  // Returns the route for given needed for a specific operation, defined by the given key
  static String getRoute(String key) {
    final route = routes[key];
    if (route != null) {
      return '$ip_address$route';
    } else {
      throw ArgumentError('No route defined for key: $key');
    }
  }


}
