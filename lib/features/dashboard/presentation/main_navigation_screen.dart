// lib/features/dashboard/presentation/main_navigation_screen.dart

import 'package:flutter/material.dart';

// 1. Home
import 'package:aahar_ai/features/dashboard/presentation/home_screen.dart';

// 2. Scan (Camera)
import 'package:aahar_ai/features/scanner/presentation/camera_screen.dart'; 

// 3. Diet Plan (The new screen we created)
import 'package:aahar_ai/features/recommendations/presentation/diet_plan_screen.dart';

// 4. History
import 'package:aahar_ai/features/dashboard/presentation/history_screen.dart';

// 5. Chat (Nutria)
import 'package:aahar_ai/features/nutria_chat/presentation/chat_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  _MainNavigationScreenState createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // Define screens here to avoid "const" errors
  final List<Widget> _screens = [
    HomeScreen(),
    CameraScreen(),
    DietPlanScreen(), // New Tab
    HistoryScreen(),
    ChatScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // IndexedStack preserves the state of tabs (doesn't reload when switching)
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      
      // Bottom Navigation Bar - LIGHT THEME
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: const Color(0xFF2E7D32).withOpacity(0.15),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          iconTheme: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: Color(0xFF2E7D32));
            }
            return const IconThemeData(color: Colors.grey);
          }),
        ),
        child: NavigationBar(
          height: 70,
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white, // Ensures it stays white
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.qr_code_scanner),
              selectedIcon: Icon(Icons.qr_code_scanner),
              label: 'Scan',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_awesome_outlined), // "Smart" icon
              selectedIcon: Icon(Icons.auto_awesome),
              label: 'Diet Plan',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history),
              label: 'History',
            ),
            NavigationDestination(
              icon: Icon(Icons.chat_bubble_outline),
              selectedIcon: Icon(Icons.chat_bubble),
              label: 'Nutria',
            ),
          ],
        ),
      ),
    );
  }
}