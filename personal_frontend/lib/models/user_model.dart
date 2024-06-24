/*

This class is the model for a user in the app

*/
class UserModel {
  // User's id, name, username, and bio
  final String id;
  final String name;
  final String username;
  final String bio;
  String profileImageUrl;

  // Count of followers and following
  final int followersCount;
  final int followingCount;

  // Map to hold the name of a user's stock list and the corresponding list of tickers in that stock list
  final Map<String, List<String>>? stockLists;

  // Constructor with required named parameters
  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.bio,
    required this.profileImageUrl,
    required this.followersCount,
    required this.followingCount,
    this.stockLists,
  });

  // Factory constructor to create a User instance from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      bio: json['bio'],
      profileImageUrl: json['profile_image_url'],
      followersCount: json['followers_count'],
      followingCount: json['following_count'],
      stockLists: json['stockLists'] != null ? 
          (json['stockLists'] as Map<String, dynamic>).map((key, value) =>
              MapEntry(key, List<String>.from(value))) : {},
    );
  }

  // Method to convert a User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      'followers_count': followersCount,
      'following_count': followingCount,
      'stockLists': stockLists ?? {}, // Default to an empty map if the field is not present
    };
  }
}
