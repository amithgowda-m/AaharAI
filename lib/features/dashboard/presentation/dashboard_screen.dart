import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../../../data/local/isar_service.dart';
import '../../../data/local/entities/food_log.dart';
import '../../scanner/presentation/camera_screen.dart';
import '../../onboarding/presentation/onboarding_screen.dart'; // We will create this next

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final IsarService _isarService = IsarService();
  List<FoodLog> _todayLogs = [];
  int _consumedCalories = 0;
  int _targetCalories = 2200; // Default, will fetch from Profile later

  @override
  void initState() {
    super.initState();
    _checkUserAndLoadData();
  }

  Future<void> _checkUserAndLoadData() async {
    // 1. Check if user profile exists
    final user = await _isarService.getCurrentUserProfile();

    if (user == null) {
      // User doesn't exist -> Go to Onboarding
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
      return;
    }

    // 2. User exists -> Update state with their calorie target
    setState(() {
      _targetCalories = user.dailyCalorieGoal.toInt();
    });

    // 3. Load Logs
    await _loadTodayLogs(user.userId);
  }

  Future<void> _loadTodayLogs(String userId) async {
    final logs = await _isarService.getTodayLogs(userId);
    setState(() {
      _todayLogs = logs;
      _consumedCalories = logs.fold(
        0,
        (sum, item) => sum + item.totalCalories.toInt(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. PHONEPE STYLE HEADER ---
            _buildHeader(),

            // --- 2. CALORIE RING ---
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildCalorieCard(),
                    const SizedBox(height: 20),
                    _buildRecentMeals(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF673AB7), // PhonePe Purple-ish
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Hello, User! 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Let's hit your goals.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- THE SCANNER BUTTON ---
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CameraScreen()),
              );
              final user = await _isarService.getCurrentUserProfile();
              if (user != null) {
                await _loadTodayLogs(user.userId);
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.qr_code_scanner, color: Color(0xFF673AB7)),
                  SizedBox(width: 10),
                  Text(
                    "Scan Food / QR",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF673AB7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieCard() {
    double progress = (_consumedCalories / _targetCalories).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Calories Today",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey[200],
                  color: Colors.orange,
                ),
              ),
              Column(
                children: [
                  Text(
                    "$_consumedCalories",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "of $_targetCalories kcal",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Today's Meals",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        _todayLogs.isEmpty
            ? const Center(
                child: Text(
                  "No food logged yet 🍽️",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _todayLogs.length,
                itemBuilder: (context, index) {
                  final log = _todayLogs[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orangeAccent,
                      child: Icon(Icons.restaurant, color: Colors.white),
                    ),
                    title: Text(
                      log.foodName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${log.timestamp.hour}:${log.timestamp.minute}",
                    ),
                    trailing: Text(
                      "${log.calories.toInt()} cal",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
