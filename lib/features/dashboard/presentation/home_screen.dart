import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/calorie_ring.dart';
import 'widgets/macro_bars.dart';
import '../../scanner/presentation/camera_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../../data/local/isar_service.dart';
import '../../../data/local/entities/food_log.dart';
import '../../../services/auth_service.dart';
import '../logic/wellness_calculator.dart'; // Import the new logic

class HomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Stats
  double caloriesConsumed = 0.0;
  double caloriesTarget = 2000.0; // Will be overwritten by Calculator
  double proteinConsumed = 0.0;
  double carbsConsumed = 0.0;
  double fatConsumed = 0.0;
  double fiberConsumed = 0.0;
  
  // Profile Data
  String userName = 'User';
  List<FoodLog> recentMeals = [];
  bool isLoading = true;

  // Wellness Score Data
  int wellnessScore = 100;
  String wellnessMessage = "Start your day right!";
  int wellnessColor = 0xFF2E7D32;
  
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final currentUser = AuthService.getCurrentUser();
      if (currentUser == null) {
        setState(() => isLoading = false);
        return;
      }

      final isarService = ref.read(isarProvider);
      
      // 1. Load user profile & Calculate Dynamic Goals
      final profile = await isarService.getUserProfile(currentUser.id);
      
      if (profile != null) {
        userName = profile.name;
        // DYNAMIC CALCULATION:
        caloriesTarget = WellnessCalculator.calculateDailyCalories(profile);
      }

      // 2. Load dashboard stats
      final stats = await isarService.getDashboardStats(currentUser.id);
      caloriesConsumed = stats['todayCalories'] ?? 0.0;
      proteinConsumed = stats['todayProtein'] ?? 0.0;
      carbsConsumed = stats['todayCarbs'] ?? 0.0;
      fatConsumed = stats['todayFat'] ?? 0.0;
      fiberConsumed = stats['todayFiber'] ?? 0.0;

      // 3. Load recent meals
      recentMeals = await isarService.getTodayLogs(currentUser.id);

      // 4. Calculate Wellness/Metabolic Score
      if (profile != null) {
        final scoreData = WellnessCalculator.calculateMetabolicScore(recentMeals, profile);
        wellnessScore = scoreData['score'];
        wellnessMessage = scoreData['message'];
        wellnessColor = scoreData['color'];
      }

      if (mounted) setState(() => isLoading = false);
    } catch (e) {
      print('Error loading dashboard: $e');
      if (mounted) setState(() => isLoading = false);
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
        backgroundColor: const Color(0xFFFAFAFA),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF2E7D32)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          color: const Color(0xFF2E7D32),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header with Profile
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
                          const SizedBox(height: 4),
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                        _loadDashboardData();
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: const Color(0xFF2E7D32),
                        child: Text(
                          _getInitials(userName),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),

                // 2. NEW: Wellness Score Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(wellnessColor).withOpacity(0.85), Color(wellnessColor)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(wellnessColor).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Score Circle
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "$wellnessScore",
                          style: TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold, 
                            color: Color(wellnessColor)
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Insight Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Metabolic Score",
                              style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              wellnessMessage,
                              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                
                // 3. Calorie Ring (Personalized Target)
                Center(
                  child: CalorieRing(
                    consumed: caloriesConsumed,
                    target: caloriesTarget,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // 4. Quick Scan Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CameraScreen()),
                      );
                      _loadDashboardData();
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Scan Food', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // 5. Macros Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Today\'s Macros',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      MacroProgressBar(
                        name: 'Protein',
                        consumed: proteinConsumed,
                        target: (caloriesTarget * 0.3) / 4, // Dynamic Goal
                        color: Colors.red,
                      ),
                      const SizedBox(height: 12),
                      MacroProgressBar(
                        name: 'Carbs',
                        consumed: carbsConsumed,
                        target: (caloriesTarget * 0.4) / 4, // Dynamic Goal
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 12),
                      MacroProgressBar(
                        name: 'Fat',
                        consumed: fatConsumed,
                        target: (caloriesTarget * 0.3) / 9, // Dynamic Goal
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 12),
                      MacroProgressBar(
                        name: 'Fiber',
                        consumed: fiberConsumed,
                        target: 30.0,
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // 6. Recent Meals
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
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
                const SizedBox(height: 12),
                
                if (recentMeals.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(40),
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
                          const SizedBox(height: 12),
                          Text(
                            'No meals logged today',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                  
                const SizedBox(height: 80), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildRecentMealCard(FoodLog meal) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
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
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.mealType,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text(
                  meal.foodName,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _formatTime(meal.timestamp),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getMealTypeColor(String mealType) {
    switch (mealType) {
      case 'Breakfast': return Colors.orange;
      case 'Morning Snack': return Colors.amber;
      case 'Lunch': return Colors.green;
      case 'Evening Snack': return Colors.blue;
      case 'Dinner': return Colors.deepPurple;
      case 'Late Night Snack': return Colors.indigo;
      default: return Colors.grey;
    }
  }

  IconData _getMealTypeIcon(String mealType) {
    switch (mealType) {
      case 'Breakfast': return Icons.wb_sunny;
      case 'Morning Snack': return Icons.coffee;
      case 'Lunch': return Icons.restaurant;
      case 'Evening Snack': return Icons.local_cafe;
      case 'Dinner': return Icons.dinner_dining;
      case 'Late Night Snack': return Icons.nightlight_round;
      default: return Icons.fastfood;
    }
  }
}