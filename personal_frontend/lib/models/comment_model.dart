/*

This class is the model for a comment in the app

*/

class CommentModel {
  final String id;
  final String userId;
  final String content;
  final DateTime timestamp;
  int likes_count;
  final bool? isLikedByUser; // hold whether the current user likes the comment in question

  CommentModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.timestamp,
    required this.likes_count,
    required this.isLikedByUser,
  });

  // Factory constructor to create a Post instance from a JSON map
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
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