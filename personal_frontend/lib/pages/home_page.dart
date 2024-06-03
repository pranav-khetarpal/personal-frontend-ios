import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/pages/profiles/current_user_profile.dart';
import 'package:personal_frontend/pages/search_users.dart';
import 'package:personal_frontend/pages/following_feed.dart';
import 'package:personal_frontend/pages/add_post.dart';
import 'package:personal_frontend/services/user_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // object to use UserService methods
  final UserServices userService = UserServices();

  // logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  // navigate to the page tapped on the bottom navigattion bar
  void _navigateBottonBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const FollowingPage(),
    const SearchUsers(),
    const AddPost(),
    const CurrentUserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APP BAR"),
        // actions: [
        //   IconButton(
        //     onPressed: () async {
        //       await userService.logout(); // Call the logout method from UserServices
        //       Navigator.of(context).pushReplacementNamed('C:/GitHub/personal-frontend/personal_frontend/lib/pages/login_register/login_page.dart'); // Navigate to login page
        //     },
        //     icon: const Icon(Icons.logout),
        //   ),
        // ],
        actions: [
          IconButton(onPressed: logout, icon: Icon(Icons.logout)),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _navigateBottonBar,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home), 
            label: 'Home'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), 
            label: 'Search'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add), 
            label: 'Add Post'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Account'
          ),
        ],
      ),
    );
  }
}
