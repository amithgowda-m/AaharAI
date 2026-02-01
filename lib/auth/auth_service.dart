import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  // Sign up new user
  static Future<String?> signup(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return "Failed to create account. Please try again.";
      }

      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred: $e";
    }
  }

  // Sign in existing user
  static Future<String?> login(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return "Login failed. Please check your credentials.";
      }

      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred: $e";
    }
  }

  // Sign in with Google
  static Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return "Google sign-in canceled";
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        return "No Access Token found.";
      }
      if (idToken == null) {
        return "No ID Token found.";
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        return "Google Login failed.";
      }

      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred: $e";
    }
  }

  // Sign out current user
  static Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current user
  static User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  // Get current session
  static Session? getCurrentSession() {
    return _supabase.auth.currentSession;
  }

  // Check if user is authenticated
  static bool isAuthenticated() {
    return _supabase.auth.currentUser != null;
  }

  // Stream of auth state changes
  static Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }

  // Request password reset email
  static Future<String?> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred: $e";
    }
  }
}
