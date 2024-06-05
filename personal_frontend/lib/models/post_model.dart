/*

This class is the model for a user in the app

*/

class PostModel {
  // Unique identifier for the post
  final String id;
  
  // ID of the user who created the post
  final String userId;
  
  // Content of the post
  final String content;
  
  // Timestamp of when the post was created
  final DateTime timestamp;

  PostModel({required this.id, 
    required this.userId, 
    required this.content, 
    required this.timestamp
  });

  // Factory constructor to create a Post instance from a JSON map
  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'], // Extract the 'id' field from the JSON map
      userId: json['userId'], // Extract the 'userId' field from the JSON map
      content: json['content'], // Extract the 'content' field from the JSON map
      timestamp: DateTime.parse(json['timestamp']), // Convert the 'timestamp' string to a DateTime object
    );
  }

  // Method to convert a Post instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(), // Convert DateTime to ISO 8601 string
    };
  }
}
