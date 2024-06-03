import 'package:flutter/material.dart';
import 'package:personal_frontend/pages/models/user_model.dart';
import 'package:personal_frontend/services/user_services.dart';

// class OtherUserProfile extends StatefulWidget {
//   final String userID;

//   const OtherUserProfile({
//     super.key, 
//     required this.userID,
//   });

//   @override
//   State<OtherUserProfile> createState() => _OtherUserProfileState();
// }

// class _OtherUserProfileState extends State<OtherUserProfile> {
//   late Future<UserModel> futureUser;
//   late UserModel currentUser;
//   final UserServices userServices = UserServices();

//   @override
//   void initState() {
//     super.initState();
//     futureUser = userServices.fetchUserProfile(widget.userID);
//     userServices.fetchCurrentUser().then((user) {
//       setState(() {
//         currentUser = user;
//       });
//     });
//   }

// // Handle the follow button press
// Future<void> followUser(String userIdToFollow) async {
//   try {
//     // calling the followUser method to add a new user to the following list and then update the state
//     await userServices.followUser(userIdToFollow, currentUser);
//     setState(() {
//       currentUser.following.add(userIdToFollow);
//     });
//   } catch (e) {
//     // Log the error
//     print('Error following user: $e');

//     // Optionally, throw the exception if it needs to be handled at a higher level
//     // throw Exception('Error following user: $e');

//     // Show an error message to the user
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error following user: $e')),
//     );
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//       ),
//       body: FutureBuilder<UserModel>(
//         future: futureUser,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData) {
//             return const Center(child: Text('User not found'));
//           } else {
//             UserModel user = snapshot.data!;
//             bool isFollowing = currentUser.following.contains(user.id);

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   const Icon(Icons.account_circle, size: 100), // Placeholder icon for user image
//                   const SizedBox(height: 16),
//                   Text(user.name, style: const TextStyle(fontSize: 24)),
//                   Text('@${user.username}', style: const TextStyle(fontSize: 18, color: Colors.grey)),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: isFollowing ? null : () => followUser(user.id),
//                     child: Text(isFollowing ? 'Following' : 'Follow'),
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

class OtherUserProfile extends StatefulWidget {
  final String userID;

  const OtherUserProfile({
    super.key, 
    required this.userID,
  });

  @override
  State<OtherUserProfile> createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  late Future<UserModel> futureUser;
  UserModel? currentUser;
  bool isLoadingCurrentUser = true;
  final UserServices userServices = UserServices();

  @override
  void initState() {
    super.initState();
    futureUser = userServices.fetchUserProfile(widget.userID);
    userServices.fetchCurrentUser().then((user) {
      setState(() {
        currentUser = user;
        isLoadingCurrentUser = false;
      });
    }).catchError((error) {
      setState(() {
        isLoadingCurrentUser = false;
      });
      // Handle error fetching current user
      print('Error fetching current user: $error');
    });
  }

  // Handle the follow button press
  Future<void> followUser(String userIdToFollow) async {
    if (currentUser == null) {
      return;
    }
    
    try {
      // calling the followUser method to add a new user to the following list and then update the state
      await userServices.followUser(userIdToFollow, currentUser!);
      setState(() {
        currentUser!.following.add(userIdToFollow);
      });
    } catch (e) {
      // Log the error
      print('Error following user: $e');

      // Optionally, throw the exception if it needs to be handled at a higher level
      // throw Exception('Error following user: $e');

      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error following user: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: FutureBuilder<UserModel>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('User not found'));
          } else {
            UserModel user = snapshot.data!;
            bool isFollowing = currentUser?.following.contains(user.id) ?? false;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.account_circle, size: 100), // Placeholder icon for user image
                  const SizedBox(height: 16),
                  Text(user.name, style: const TextStyle(fontSize: 24)),
                  Text('@${user.username}', style: const TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 16),
                  isLoadingCurrentUser
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: isFollowing ? null : () => followUser(user.id),
                          child: Text(isFollowing ? 'Following' : 'Follow'),
                        ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

