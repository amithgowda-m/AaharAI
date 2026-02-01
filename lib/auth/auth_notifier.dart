import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// A ChangeNotifier that listens to Supabase auth state changes
/// and notifies GoRouter to rebuild when auth state changes
class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.passwordRecovery) {
        _isPasswordRecovery = true;
      } else if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.signedOut) {
        _isPasswordRecovery = false;
      }
      notifyListeners();
    });
  }

  bool _isPasswordRecovery = false;
  bool get isPasswordRecovery => _isPasswordRecovery;

  bool get isAuthenticated => Supabase.instance.client.auth.currentUser != null;
}
