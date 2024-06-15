/*

This class is the model for a user in the app

*/
class UserModel {
  // User's id, name, username, and bio
  final String id;
  final String name;
  final String username;
  final String bio;
  String profile_image_url;

  // List of IDs of users that this user is following
  final List<String> following;

  // Constructor with required named parameters
  UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.bio,
    required this.profile_image_url,
    required this.following,
  });

  // Factory constructor to create a User instance from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      bio: json['bio'],
      profile_image_url: json['profile_image_url'],
      following: List<String>.from(json['following']),
    );
  }

  // Method to convert a User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'bio': bio,
      'profile_image_url': profile_image_url,
      'following': following,
    };
  }
}
