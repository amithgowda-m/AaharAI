// lib/features/dashboard/presentation/home_screen.dart - REPLACE ENTIRE FILE

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/calorie_ring.dart';
import 'widgets/macro_bars.dart';
import '../../scanner/presentation/camera_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../../data/local/isar_service.dart';
import '../../../data/local/entities/food_log.dart';
import '../../../services/auth_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  double caloriesConsumed = 0.0;
  double caloriesTarget = 2100.0;
  double proteinConsumed = 0.0;
  double carbsConsumed = 0.0;
  double fatConsumed = 0.0;
  double fiberConsumed = 0.0;
  String userName = 'User';
  List<FoodLog> recentMeals = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => isLoading = true);

    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) {
        setState(() => isLoading = false);
        return;
      }

      final isarService = ref.read(isarProvider);
      
      // Load user profile
      final profile = await isarService.getUserProfile(currentUser.id);
      if (profile != null) {
        userName = profile.name;
        caloriesTarget = profile.dailyCalorieGoal;
      }

      // Load dashboard stats
      final stats = await isarService.getDashboardStats(currentUser.id);
      caloriesConsumed = stats['todayCalories'] ?? 0.0;
      proteinConsumed = stats['todayProtein'] ?? 0.0;
      carbsConsumed = stats['todayCarbs'] ?? 0.0;
      fatConsumed = stats['todayFat'] ?? 0.0;
      fiberConsumed = stats['todayFiber'] ?? 0.0;

      // Load recent meals (today's meals)
      recentMeals = await isarService.getTodayLogs(currentUser.id);

      setState(() => isLoading = false);
    } catch (e) {
      print('Error loading dashboard: $e');
      setState(() => isLoading = false);
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    if (hour < 21) return 'Good Evening';
    return 'Good Night';
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _formatTime(DateTime timestamp) {
    final hour = timestamp.hour > 12 ? timestamp.hour - 12 : timestamp.hour;
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    final minute = timestamp.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          color: Color(0xFF2E7D32),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Profile
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            userName,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    // Profile Icon Button
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                        // Refresh data after returning from profile
                        _loadDashboardData();
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFF2E7D32),
                        child: Text(
                          _getInitials(userName),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 32),
                
                // Calorie Ring
                Center(
                  child: CalorieRing(
                    consumed: caloriesConsumed,
                    target: caloriesTarget,
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Quick Action Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CameraScreen()),
                      );
                      // Refresh data after returning from camera
                      _loadDashboardData();
                    },
                    icon: Icon(Icons.camera_alt),
                    label: Text('Scan Food', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                
                SizedBox(height: 32),
                
                // Macros Section
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today\'s Macros',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      MacroProgressBar(
                        name: 'Protein',
                        consumed: proteinConsumed,
                        target: 105.0,
                        color: Colors.red,
                      ),
                      SizedBox(height: 12),
                      MacroProgressBar(
                        name: 'Carbs',
                        consumed: carbsConsumed,
                        target: 260.0,
                        color: Colors.orange,
                      ),
                      SizedBox(height: 12),
                      MacroProgressBar(
                        name: 'Fat',
                        consumed: fatConsumed,
                        target: 70.0,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 12),
                      MacroProgressBar(
                        name: 'Fiber',
                        consumed: fiberConsumed,
                        target: 30.0,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Recent Meals Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Today\'s Meals',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (recentMeals.isNotEmpty)
                      Text(
                        '${recentMeals.length} logged',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12),
                
                // Recent Meals List
                if (recentMeals.isEmpty)
                  Container(
                    padding: EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'No meals logged today',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap "Scan Food" to start logging',
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...recentMeals.map((meal) => _buildRecentMealCard(meal)).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildRecentMealCard(FoodLog meal) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getMealTypeColor(meal.mealType),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getMealTypeIcon(meal.mealType),
              color: Colors.white,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.mealType,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(height: 2),
                Text(
                  meal.foodName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (meal.modifiers.isNotEmpty)
                  Text(
                    '+ ${meal.modifiers.join(", ")}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${meal.totalCalories.toInt()} Cal',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: 2),
              Text(
                _formatTime(meal.timestamp),
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Colors.orange;
      case 'Morning Snack':
        return Colors.amber;
      case 'Lunch':
        return Colors.green;
      case 'Evening Snack':
        return Colors.blue;
      case 'Dinner':
        return Colors.deepPurple;
      case 'Late Night Snack':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return Icons.wb_sunny;
      case 'Morning Snack':
        return Icons.coffee;
      case 'Lunch':
        return Icons.restaurant;
      case 'Evening Snack':
        return Icons.local_cafe;
      case 'Dinner':
        return Icons.dinner_dining;
      case 'Late Night Snack':
        return Icons.nightlight_round;
      default:
        return Icons.fastfood;
    }
  }
}
