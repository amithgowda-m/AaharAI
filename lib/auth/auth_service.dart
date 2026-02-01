import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aahar_ai/data/local/isar_service.dart';

class AuthService {
  static final _supabase = Supabase.instance.client;

  // Sign up new user
  static Future<String?> signup(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: 'io.supabase.aaharai://login-callback',
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
      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

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
      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'io.supabase.aaharai://login-callback',
      );
      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred: $e";
    }
  }

  // Update password (for authenticated user)
  static Future<String?> updatePassword(String password) async {
    try {
      final response = await _supabase.auth.updateUser(
        UserAttributes(password: password),
      );
      
      if (response.user == null) {
        return "Failed to update password.";
      }
      return null; // Success
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return "An unexpected error occurred: $e";
    }
  }

  // Delete account
  static Future<String?> deleteAccount() async {
    try {
      // 1. Clear Supabase User 
      try {
        await _supabase.rpc('delete_user');
      } catch (e) {
        print('Supabase RPC delete_user failed (this is expected if not setup): $e');
      }
      
      // 2. Clear ALL local data (Isar)
      await IsarService().clearAllLocalData();
      
      // 3. Clear SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      
      // 4. Final Sign Out
      await signOut();
      
      return null; // Success
    } catch (e) {
      return "An unexpected error occurred during account deletion: $e";
    }
  }
}
