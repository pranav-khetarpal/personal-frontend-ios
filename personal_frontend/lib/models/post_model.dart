/*

This class is the model for a user in the app

*/

class PostModel {
  final String id; // Unique identifier for the post
  final String userId; // ID of the user who created the post
  final String content; // Content of the post
  final DateTime timestamp; // Timestamp of when the post was created
  int likes_count; // number of likes on the post
  final bool? isLikedByUser; // hold whether the current user likes the post in question

  PostModel({
    required this.id, 
    required this.userId, 
    required this.content, 
    required this.timestamp,
    required this.likes_count,
    this.isLikedByUser,
  });

  // Factory constructor to create a Post instance from a JSON map
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      likes_count: json['likes_count'],
      isLikedByUser: json['isLikedByUser'] ?? false, // Default to false if the field is not present
    );
  }

  // Method to convert a Post instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to ISO 8601 string
      'likes_count': likes_count,
      'isLikedByUser': isLikedByUser ?? false, // Ensure a default value if the field is null
    };
  }
}
