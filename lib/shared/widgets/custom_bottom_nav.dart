// lib/shared/widgets/custom_bottom_nav.dart - REPLACE ENTIRE FILE

import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF1A1A1A),
      selectedItemColor: const Color(0xFF2E7D32),
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt_outlined),
          activeIcon: Icon(Icons.camera_alt),
          label: 'Snap',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome_outlined), // NEW - Smart Plans
          activeIcon: Icon(Icons.auto_awesome),
          label: 'Smart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_fire_department_outlined),
          activeIcon: Icon(Icons.local_fire_department),
          label: 'Streaks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble),
          label: 'Nutria',
        ),
      ],
    );
  }
}
