// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:personal_frontend/authorization/auth.dart';
// import 'package:personal_frontend/firebase_options.dart';
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

//       }
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/authorization/auth_page.dart';
import 'package:personal_frontend/firebase_options.dart';
import 'package:personal_frontend/themes/dark_mode.dart';
import 'package:personal_frontend/themes/light_mode.dart';
import 'package:personal_frontend/pages/main_scaffold.dart';

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
        '/home': (context) => const MainScaffold(),
      },
      onGenerateRoute: (settings) {
        // if (settings.name == '/stock_detail') {
        //   final symbol = settings.arguments as String;
        //   return MaterialPageRoute(
        //     builder: (context) => StockDetailPage(symbol: symbol),
        //   );
        // } else if (settings.name == '/message') {
        //   return MaterialPageRoute(
        //     builder: (context) => const UserMessage(),
        //   );
        // }
        return null;
      },
    );
  }
}
