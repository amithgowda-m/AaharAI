import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'features/dashboard/presentation/dashboard_screen.dart'; // <--- IMPORT THIS

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found.");
  }

  // Initialize Supabase (or skip if not using yet)
  final supabaseUrl = dotenv.env['SUPABASE_URL'];
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];
  
  if (supabaseUrl != null && supabaseKey != null) {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  }

  runApp(const ProviderScope(child: AaharAIApp()));
}

class AaharAIApp extends StatelessWidget {
  const AaharAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aahar AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      // 👇 THIS MUST BE DashboardScreen, NOT AddMealScreen
      home: const DashboardScreen(), 
    );
  }
}