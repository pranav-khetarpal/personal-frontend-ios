import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  String? _cachedToken;

  // Get the ID token, refreshing if necessary
  Future<String> getIdToken() async {
    if (_cachedToken == null) {
      _cachedToken = await FirebaseAuth.instance.currentUser?.getIdToken();

      // get rid of all space creating characters
      _cachedToken = _cachedToken?.replaceAll(RegExp(r'\s+'), '');

      if (_cachedToken == null) {
        throw Exception("Failed to retrieve auth token");
      }
    }

    return _cachedToken!;
  }

  // Clear the cached token (e.g., after logout)
  void clearCachedToken() {
    _cachedToken = null;
  }

  // Call this method to get a fresh token if needed
  Future<String> getFreshIdToken() async {
    _cachedToken = await FirebaseAuth.instance.currentUser?.getIdToken(true);

    // get rid of all space creating characters
    _cachedToken = _cachedToken?.replaceAll(RegExp(r'\s+'), '');

    return _cachedToken!;
  }
}
