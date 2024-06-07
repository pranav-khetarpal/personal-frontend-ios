import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/authorization/auth.dart';
import 'package:personal_frontend/firebase_options.dart';
import 'package:personal_frontend/themes/dark_mode.dart';
import 'package:personal_frontend/themes/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      home: const AuthPage(),
      routes: {

      }
    );
  }
}

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:personal_frontend/authorization/auth.dart';
// import 'package:personal_frontend/firebase_options.dart';
// import 'package:personal_frontend/pages/add_post.dart';
// import 'package:personal_frontend/pages/following_feed.dart';
// import 'package:personal_frontend/pages/home_page.dart';
// import 'package:personal_frontend/pages/profiles/current_user_profile.dart';
// import 'package:personal_frontend/pages/search_stocks.dart';
// import 'package:personal_frontend/pages/search_users.dart';
// import 'package:personal_frontend/themes/dark_mode.dart';
// import 'package:personal_frontend/themes/light_mode.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: lightMode,
//       darkTheme: darkMode,
//       home: const AuthPage(),
//       routes: {
//         '/home': (context) => const HomePage(),
//         '/following_feed': (context) => const FollowingFeed(),
//         '/search_stocks': (context) => const SearchStocks(),
//         '/search_users': (context) => const SearchUsers(),
//         '/add_post': (context) => const AddPost(),
//         '/current_user_profile': (context) => const CurrentUserProfile(),
//       },
//       onGenerateRoute: (settings) {
//         // Add any dynamic route handling here
//         // Example: Passing arguments to a profile page
//         if (settings.name == '/profile') {
//           final userId = settings.arguments as String;
//           return MaterialPageRoute(
//             builder: (context) => UserProfilePage(userId: userId),
//           );
//         }
//         return null; // Return null if no match is found
//       },
//     );
//   }
// }
