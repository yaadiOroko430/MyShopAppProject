import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Sign In method
  static Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Sign Up method
  static Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    // Update display name
    await userCredential.user?.updateDisplayName(name);

    return userCredential;
  }

  // Sign Out method
  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  // Error handling
  static String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password';
      case 'email-already-in-use':
        return 'Email already registered';
      case 'weak-password':
        return 'Password too weak';
      default:
        return 'Authentication failed';
    }
  }
}
