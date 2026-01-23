// lib/main.dart - COMPLETE FILE

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/main_navigation_screen.dart';
import 'services/auth_service.dart'; // Add this import for AuthService

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env first
  await dotenv.load(fileName: ".env");
  
  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(ProviderScope(child: AaharAIApp()));
}

class AaharAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aahar AI',
      theme: ThemeData(
        primaryColor: Color(0xFF2E7D32),
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: AuthChecker(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthChecker extends StatefulWidget {
  @override
  _AuthCheckerState createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await Future.delayed(Duration(seconds: 1)); // Splash effect
    
    final isAuthenticated = AuthService.isAuthenticated();
    
    if (mounted) {
      if (isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigationScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2E7D32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo/Icon
            Icon(
              Icons.restaurant_menu_rounded,
              size: 120,
              color: Colors.white,
            ),
            SizedBox(height: 32),
            // App Name
            Text(
              'Aahar AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 8),
            // Tagline
            Text(
              'Your AI Nutrition Companion',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 64),
            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
