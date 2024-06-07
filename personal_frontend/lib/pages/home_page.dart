// import 'package:flutter/material.dart';
// import 'package:personal_frontend/pages/base_layout.dart';
// import 'package:personal_frontend/pages/profiles/current_user_profile.dart';
// import 'package:personal_frontend/pages/search_tickers.dart';
// import 'package:personal_frontend/pages/search_users.dart';
// import 'package:personal_frontend/pages/following_feed.dart';
// import 'package:personal_frontend/pages/add_post.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _selectedIndex = 0;

//   // // object to use AuthService methods
//   // final AuthServices authServices = AuthServices();

//   // // logout user
//   // void logout() {
//   //   authServices.clearCachedToken();
//   //   FirebaseAuth.instance.signOut();
//   // }

//   // navigate to the page tapped on the bottom navigattion bar
//   void navigateBottomBar(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   final List<Widget> _pages = [
//     const FollowingPage(),
//     const SearchStocks(),
//     const SearchUsers(),
//     const AddPost(),
//     const CurrentUserProfile(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return BaseLayout(
//       child: Scaffold(
//         // appBar: AppBar(
//         //   title: Text("APP BAR"),
//         //   // actions: [
//         //   //   IconButton(onPressed: logout, icon: Icon(Icons.logout)),
//         //   // ],
//         // ),
//         body: _pages[_selectedIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: navigateBottomBar,
//           type: BottomNavigationBarType.fixed,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.stacked_line_chart),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.search),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.add),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: '',
//             ),
//             // BottomNavigationBarItem(
//             //   icon: Icon(Icons.home), 
//             //   label: 'Home'
//             // ),
//             // BottomNavigationBarItem(
//             //   icon: Icon(Icons.search), 
//             //   label: 'Search'
//             // ),
//             // BottomNavigationBarItem(
//             //   icon: Icon(Icons.add), 
//             //   label: 'Add Post'
//             // ),
//             // BottomNavigationBarItem(
//             //   icon: Icon(Icons.person), 
//             //   label: 'Account'
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:personal_frontend/pages/base_layout.dart';
import 'package:personal_frontend/pages/profiles/current_user_profile.dart';
import 'package:personal_frontend/pages/search_stocks.dart';
import 'package:personal_frontend/pages/search_users.dart';
import 'package:personal_frontend/pages/following_feed.dart';
import 'package:personal_frontend/pages/add_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => const FollowingFeed());
      },
    ),
    Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => const SearchStocks());
      },
    ),
    Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => const SearchUsers());
      },
    ),
    Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => const AddPost());
      },
    ),
    Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => const CurrentUserProfile());
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_line_chart),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}


