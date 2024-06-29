// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:personal_frontend/authorization/login_or_register.dart';
// import 'package:personal_frontend/pages/main_scaffold.dart';

// class AuthPage extends StatelessWidget {
//   const AuthPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           // user is logged in
//           if (snapshot.hasData) {
//             return const MainScaffold();
//           }

//           // user is NOT logged in
//           else {
//             return const LoginOrRegister();
//           }
//         }
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/authorization/login_or_register.dart';
import 'package:personal_frontend/authorization/email_verification_page.dart';
import 'package:personal_frontend/pages/main_scaffold.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  Future<bool> _checkUserDocumentExists(String uid) async {
    final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return docSnapshot.exists;
  }

  Future<Map<String, String?>> _getUserDetails(String uid) async {
    final docSnapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = docSnapshot.data();
    return {
      'name': data?['name'],
      'username': data?['username'],
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            if (user.emailVerified) {
              return FutureBuilder<bool>(
                future: _checkUserDocumentExists(user.uid),
                builder: (context, docExistsSnapshot) {
                  if (docExistsSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (docExistsSnapshot.hasData && docExistsSnapshot.data!) {
                    return const MainScaffold();
                  } else {
                    return const Center(child: Text('User document not found'));
                  }
                },
              );
            } else {
              return FutureBuilder<Map<String, String?>>(
                future: _getUserDetails(user.uid),
                builder: (context, userDetailsSnapshot) {
                  if (userDetailsSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userDetailsSnapshot.hasData) {
                    final userDetails = userDetailsSnapshot.data!;
                    return EmailVerificationPage(
                      user: user,
                      name: userDetails['name'] ?? '',
                      email: user.email!,
                      username: userDetails['username'] ?? '',
                    );
                  } else {
                    return const Center(child: Text('Error fetching user details'));
                  }
                },
              );
            }
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
