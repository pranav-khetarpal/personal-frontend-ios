import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:personal_frontend/components/my_small_button.dart';
import 'package:personal_frontend/helper/helper_functions.dart';
import 'package:personal_frontend/pages/profiles/current_user_profile.dart';

class NewEmailVerificationPage extends StatefulWidget {
  final User user;
  final String newEmail;
  final int verificationTimeoutMinutes; // Timeout duration in minutes

  const NewEmailVerificationPage({
    super.key,
    required this.user,
    required this.newEmail,
    this.verificationTimeoutMinutes = 1, // Default timeout of 1 minute
  });

  @override
  State<NewEmailVerificationPage> createState() => _NewEmailVerificationPageState();
}

class _NewEmailVerificationPageState extends State<NewEmailVerificationPage> {
  bool isEmailVerified = false;
  late int _timeoutInSeconds;
  bool _timeoutOccurred = false;
  Timer? _timeoutTimer;
  Timer? _periodicReloadTimer;

  @override
  void initState() {
    super.initState();
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
    _periodicReloadTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
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
    displayMessageToUser("Email verification successful.", context);
    _navigateToProfilePage();
  }

  void _navigateToProfilePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CurrentUserProfile()),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error sending verification email: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify New Email')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please verify your new email to continue.'),
            const SizedBox(height: 16),
            MySmallButton(text: 'Resend Verification Email', onTap: _resendVerificationEmail),
            if (_timeoutOccurred) ...[
              const SizedBox(height: 16),
              const Text('Verification timed out. Please request a new verification email.'),
            ],
          ],
        ),
      ),
    );
  }
}
