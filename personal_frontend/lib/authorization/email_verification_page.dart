// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:personal_frontend/components/my_small_button.dart';
// import 'package:personal_frontend/helper/helper_functions.dart';
// import 'package:personal_frontend/pages/login_register/initialize_profile_page.dart';
// import 'package:personal_frontend/services/user_account_services.dart';
// import 'package:personal_frontend/services/user_interation_services.dart';

// class EmailVerificationPage extends StatefulWidget {
//   final User user;
//   final String name;
//   final String email;
//   final String username;
//   final int verificationTimeoutMinutes; // Timeout duration in minutes

//   const EmailVerificationPage({
//     super.key,
//     required this.user,
//     required this.name,
//     required this.email,
//     required this.username,
//     this.verificationTimeoutMinutes = 1, // Default timeout of 1 minute
//   });

//   @override
//   State<EmailVerificationPage> createState() => _EmailVerificationPageState();
// }

// class _EmailVerificationPageState extends State<EmailVerificationPage> {
//   late UserAccountServices userAccountServices;
//   bool isEmailVerified = false;
//   late int _timeoutInSeconds;
//   bool _timeoutOccurred = false;
//   Timer? _timeoutTimer;
//   Timer? _periodicReloadTimer;

//   UserInteractionServices userInteractionServices = UserInteractionServices();

//   @override
//   void initState() {

//     super.initState();
//     userAccountServices = UserAccountServices();
//     isEmailVerified = widget.user.emailVerified;
//     _timeoutInSeconds = widget.verificationTimeoutMinutes * 60;

//     // print("Initial email verification status: $isEmailVerified");
//     // print(_timeoutOccurred);

//     // Start periodic reloads
//     _startPeriodicReload();

//     // Start the timeout countdown
//     _startTimeoutTimer();

//     // Send verification email on initialization
//     _sendVerificationEmail();
//   }

//   @override
//   void dispose() {
//     _timeoutTimer?.cancel();
//     _periodicReloadTimer?.cancel();
//     super.dispose();
//   }

//   void _startTimeoutTimer() {
//     _timeoutTimer = Timer(Duration(seconds: _timeoutInSeconds), () {
//       print("Timeout occurred");
//       if (!isEmailVerified) {
//         print("Verification timed out");
//         setState(() {
//           _timeoutOccurred = true;
//         });
//         displayMessageToUser("Verification timed out. Please request a new verification email.", context);
//         _periodicReloadTimer?.cancel();
//       }
//     });
//   }

//   void _startPeriodicReload() {
//     _periodicReloadTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
//       await _reloadUser();
//     });
//   }

//   Future<void> _reloadUser() async {
//     print("Reloading user...");
//     await widget.user.reload();
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null && user.emailVerified) {
//       print("User reloaded, emailVerified: ${user.emailVerified}");
//       setState(() {
//         isEmailVerified = true;
//       });
//       _handleEmailVerified();
//       _periodicReloadTimer?.cancel();
//     }
//   }

//   // void _handleEmailVerified() async {

//   //   await userAccountServices.createUserDocument(
//   //     name: widget.name,
//   //     email: widget.email,
//   //     username: widget.username,
//   //     bio: "", // Initially empty
//   //   );
//   //   _navigateToMainScaffold();
//   // }

//   void _handleEmailVerified() async {
//     await userAccountServices.createUserDocument(
//       name: widget.name,
//       email: widget.email,
//       username: widget.username,
//       bio: "", // Initially empty
//     );

//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => const InitializeProfilePage(),
//       ),
//     );
//   }

//   // void _navigateToMainScaffold() {
//   //   Navigator.pushReplacement(
//   //     context,
//   //     MaterialPageRoute(builder: (context) => const MainScaffold()),
//   //   );
//   // }

//   Future<void> _resendVerificationEmail() async {
//     try {
//       await widget.user.sendEmailVerification();
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("Verification email resent. Please check your email."),
//       ));
//       _timeoutTimer?.cancel();
//       _timeoutOccurred = false;
//       _startTimeoutTimer();
//       _startPeriodicReload();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Error: $e"),
//       ));
//     }
//   }

//   Future<void> _sendVerificationEmail() async {
//     try {
//       await widget.user.sendEmailVerification();
//     } catch (e) {
//       print("Error sending verification email: $e");
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Error sending verification email: $e"),
//       ));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Verify Email')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Please verify your email to continue.'),
//             const SizedBox(height: 16),
//             MySmallButton(text: 'Resend Verification Email', onTap: _resendVerificationEmail),
//             if (_timeoutOccurred) ...[
//               const SizedBox(height: 16),
//               const Text('Verification timed out. Please request a new verification email.'),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/authorization/login_or_register.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/pages/login_register/initialize_profile_page.dart';
import 'package:personal_frontend/services/user_account_services.dart';
import 'package:personal_frontend/services/user_interation_services.dart';

class EmailVerificationPage extends StatefulWidget {
  final User user;
  final String name;
  final String email;
  final String username;
  final int verificationTimeoutMinutes; // Timeout duration in minutes

  const EmailVerificationPage({
    super.key,
    required this.user,
    required this.name,
    required this.email,
    required this.username,
    this.verificationTimeoutMinutes = 1, // Default timeout of 1 minute
  });

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  late UserAccountServices userAccountServices;
  bool isEmailVerified = false;
  late int _timeoutInSeconds;
  bool _timeoutOccurred = false;
  Timer? _timeoutTimer;
  Timer? _periodicReloadTimer;

  UserInteractionServices userInteractionServices = UserInteractionServices();

  @override
  void initState() {
    super.initState();
    userAccountServices = UserAccountServices();
    isEmailVerified = widget.user.emailVerified;
    _timeoutInSeconds = widget.verificationTimeoutMinutes * 60;

    // Start periodic reloads
    _startPeriodicReload();

    // Start the timeout countdown
    _startTimeoutTimer();

    // Send verification email on initialization
    _sendVerificationEmail();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    _periodicReloadTimer?.cancel();
    super.dispose();
  }

  void _startTimeoutTimer() {
    _timeoutTimer = Timer(Duration(seconds: _timeoutInSeconds), () {
      if (!isEmailVerified) {
        setState(() {
          _timeoutOccurred = true;
        });
        displayMessageToUser("Verification timed out. Please request a new verification email.", context);
        _periodicReloadTimer?.cancel();
      }
    });
  }

  void _startPeriodicReload() {
    _periodicReloadTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _reloadUser();
    });
  }

  Future<void> _reloadUser() async {
    await widget.user.reload();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.emailVerified) {
      setState(() {
        isEmailVerified = true;
      });
      _handleEmailVerified();
      _periodicReloadTimer?.cancel();
    }
  }

  void _handleEmailVerified() async {
    await userAccountServices.createUserDocument(
      name: widget.name,
      email: widget.email,
      username: widget.username,
      bio: "", // Initially empty
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const InitializeProfilePage(),
      ),
    );
  }

  Future<void> _resendVerificationEmail() async {
    try {
      await widget.user.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Verification email resent. Please check your email."),
      ));
      _timeoutTimer?.cancel();
      _timeoutOccurred = false;
      _startTimeoutTimer();
      _startPeriodicReload();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      await widget.user.sendEmailVerification();
    } catch (e) {
      displayMessageToUser("Error sending verification email: $e", context);
    }
  }

  Future<void> _deleteUserCredentials() async {
    try {
      await widget.user.delete();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error deleting user credentials: $e"),
      ));
    }
  }

  void _goBackToLoginOrRegister() async {
    await _deleteUserCredentials();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginOrRegister(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please verify your email to continue.'),
              const SizedBox(height: 16),
              MySmallButton(text: 'Resend Verification Email', onTap: _resendVerificationEmail),
              const SizedBox(height: 16),
              MySmallButton(text: 'Go Back', onTap: _goBackToLoginOrRegister),
              if (_timeoutOccurred) ...[
                const SizedBox(height: 16),
                const Text('Verification timed out. Please request a new verification email.'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
