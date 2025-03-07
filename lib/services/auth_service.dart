import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  // Google Sign-In
  static Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception("Google sign-in canceled");

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("Google Sign-In Error: $e");
      rethrow; // Preserve original error
    }
  }

  //forgot password
  static Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  // Sign Out method
  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut(); // Add this line
    } catch (e) {
      print("Sign-out error: $e");
      rethrow;
    }
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
