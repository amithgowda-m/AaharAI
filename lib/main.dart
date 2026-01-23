// lib/main.dart - FIX THIS
import 'package:flutter/material.dart';
import 'features/dashboard/presentation/main_navigation_screen.dart'; // ADD THIS LINE

void main() {
  runApp(AaharAIApp());
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
      home: MainNavigationScreen(), // This will work after adding import
      debugShowCheckedModeBanner: false,
    );
  }
}
