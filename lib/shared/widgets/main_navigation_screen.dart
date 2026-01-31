// lib/shared/widgets/main_navigation_screen.dart - CREATE NEW FILE

import 'package:flutter/material.dart';
import 'package:aaharai/shared/widgets/custom_bottom_nav.dart';
import 'package:aaharai/features/dashboard/presentation/home_screen.dart';
import 'package:aaharai/features/scanner/presentation/camera_screen.dart';
import 'package:aaharai/features/recommendations/presentation/smart_plans_screen.dart';
import 'package:aaharai/features/streaks/presentation/streaks_screen.dart';
import 'package:aaharai/features/nutria_chat/presentation/chat_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  // List of screens corresponding to each tab
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeScreen(),          // 0: Home
      const CameraScreen(),        // 1: Snap (Food Scanner)
      const SmartPlansScreen(),    // 2: Smart Plans (NEW)
      const StreaksScreen(),       // 3: Streaks
      const ChatScreen(),          // 4: Nutria Chat
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
