/*

This class is the model for a user in the app

*/
class UserModel {
  // User's id, name, and username
  final String id;
  final String name;
  final String username;
  
  // List of IDs of users that this user is following
  final List<String> following;

  // Constructor with required named parameters
  UserModel({
    required this.id, 
    required this.name, 
    required this.username,
    required this.following,
  });

  // Factory constructor to create a User instance from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'], // Extract the 'id' field from the JSON map
      name: json['name'], // Extract the 'name' field from the JSON map
      username: json['username'], // Extract the 'username' field from the JSON map
      following: List<String>.from(json['following']), // Extract the 'following' field and convert it to a List<String>
    );
  }

  // Method to convert a User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'following': following,
    };
  }
}
