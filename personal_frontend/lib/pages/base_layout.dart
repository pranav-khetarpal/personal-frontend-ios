import 'package:flutter/material.dart';

/*
This widget is designed to ensure that the top status bar on mobile devices is not covered by the app's features
*/

class BaseLayout extends StatelessWidget {
  final Widget child;

  const BaseLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: child,
      ),
    );
  }
}
