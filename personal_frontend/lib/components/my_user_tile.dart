import 'package:flutter/material.dart';
import 'package:personal_frontend/models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const UserTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.tertiary,
      onTap: onTap,

      // Profile Image
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: user.profileImageUrl.isNotEmpty
            ? NetworkImage(user.profileImageUrl)
            : null,
        onBackgroundImageError: (exception, stackTrace) {
          print('Error loading profile image: $exception');
        },
        child: user.profileImageUrl.isEmpty
            ? const Icon(Icons.account_circle, size: 50)
            : null,
      ),
      
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        '@${user.username}',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
