import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/authorization/login_or_register.dart';
import 'package:personal_frontend/pages/main_scaffold.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user is logged in
          if (snapshot.hasData) {
            return const MainScaffold();
          }

          // user is NOT logged in
          else {
            return const LoginOrRegister();
          }
        }
      ),
    );
  }
}
