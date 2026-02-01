
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart' as provider;

// Imports based on your file structure
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/presentation/main_navigation_screen.dart';
import 'auth/auth_service.dart';

// Recommendation system imports
import 'data/local/isar_service.dart';
import 'services/groq_recommendation_service.dart';
import 'services/subscription_service.dart';
import 'features/recommendations/logic/recommendation_provider.dart';
import 'features/recommendations/logic/meal_pattern_analyzer.dart';
import 'features/recommendations/logic/subscription_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load .env first
  await dotenv.load(fileName: ".env");
  
  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  // Initialize services for recommendations
  final isarService = IsarService();
  final groqService = GroqRecommendationService();
  final subscriptionService = SubscriptionService(isarService);
  final patternAnalyzer = MealPatternAnalyzer(isarService);
  
  // Initialize free subscription for new users
  await subscriptionService.initializeFreeSubscription();

  runApp(
    ProviderScope(
      child: provider.MultiProvider(
        providers: [
          // Service providers
          provider.Provider<IsarService>.value(value: isarService),
          provider.Provider<GroqRecommendationService>.value(value: groqService),
          provider.Provider<SubscriptionService>.value(value: subscriptionService),
          provider.Provider<MealPatternAnalyzer>.value(value: patternAnalyzer),
          
          // ChangeNotifier providers
          provider.ChangeNotifierProvider(
            create: (context) => SubscriptionProvider(subscriptionService),
          ),
          provider.ChangeNotifierProvider(
            create: (context) => RecommendationProvider(
              groqService: groqService,
              isarService: isarService,
              patternAnalyzer: patternAnalyzer,
            ),
          ),
        ],
        child: AaharAIApp(),
      ),
    ),
  );
}

class AaharAIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aahar AI',
      // CHANGED: Reverted to Light Theme
      theme: ThemeData(
        brightness: Brightness.light, // Light mode
        primaryColor: const Color(0xFF2E7D32), // Green
        scaffoldBackgroundColor: Colors.white, // White background
        
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF2E7D32),
          secondary: const Color(0xFF4CAF50),
          surface: Colors.white,
          background: Colors.white,
          onPrimary: Colors.white,
          onSurface: Colors.black87, // Black text
        ),
        
        useMaterial3: true,
        
        // Light App Bar
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.black87),
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Green Buttons
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const AuthChecker(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

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
    await Future.delayed(const Duration(seconds: 1)); // Splash effect
    
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
    // Splash Screen (Kept green for branding impact)
    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant_menu_rounded,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 32),
            const Text(
              'Aahar AI',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your AI Nutrition Companion',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 64),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}