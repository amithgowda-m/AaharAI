// lib/data/local/isar_service.dart - REPLACE ENTIRE FILE

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'entities/food_log.dart';
import 'entities/user_profile.dart';

// Provider for Isar Service
final isarProvider = Provider<IsarService>((ref) {
  return IsarService();
});

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [FoodLogSchema, UserProfileSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // ==================== FOOD LOG METHODS ====================
  
  Future<void> addFoodLog(FoodLog newLog) async {
    final isar = await db;
    
    // Calculate total nutrition
    final baseCalories = newLog.calories * newLog.portionSize * newLog.itemCount;
    final baseProtein = newLog.protein * newLog.portionSize * newLog.itemCount;
    final baseCarbs = newLog.carbs * newLog.portionSize * newLog.itemCount;
    final baseFat = newLog.fat * newLog.portionSize * newLog.itemCount;
    final baseFiber = newLog.fiber * newLog.portionSize * newLog.itemCount;
    
    newLog.totalCalories = baseCalories + newLog.modifierCalories;
    newLog.totalProtein = baseProtein + newLog.modifierProtein;
    newLog.totalCarbs = baseCarbs + newLog.modifierCarbs;
    newLog.totalFat = baseFat + newLog.modifierFat;
    newLog.totalFiber = baseFiber;
    
    await isar.writeTxn(() async {
      await isar.foodLogs.put(newLog);
    });
    
    // Update user streak
    await _updateStreak(newLog.userId);
  }

  Future<List<FoodLog>> getTodayLogs(String userId) async {
    final isar = await db;
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return await isar.foodLogs
        .filter()
        .userIdEqualTo(userId)
        .timestampBetween(start, end)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<List<FoodLog>> getAllLogs(String userId) async {
    final isar = await db;
    return await isar.foodLogs
        .filter()
        .userIdEqualTo(userId)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<List<FoodLog>> getLogsByDateRange(String userId, DateTime start, DateTime end) async {
    final isar = await db;
    return await isar.foodLogs
        .filter()
        .userIdEqualTo(userId)
        .timestampBetween(start, end)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<List<FoodLog>> getLogsByMealType(String userId, String mealType) async {
    final isar = await db;
    return await isar.foodLogs
        .filter()
        .userIdEqualTo(userId)
        .mealTypeEqualTo(mealType)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<void> updateLog(FoodLog updatedLog) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.foodLogs.put(updatedLog);
    });
  }

  Future<void> deleteLog(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.foodLogs.delete(id);
    });
  }

  // Get today's nutrition totals
  Future<Map<String, double>> getTodayNutrition(String userId) async {
    final logs = await getTodayLogs(userId);
    
    double calories = 0.0;
    double protein = 0.0;
    double carbs = 0.0;
    double fat = 0.0;
    double fiber = 0.0;

    for (var log in logs) {
      calories += log.totalCalories;
      protein += log.totalProtein;
      carbs += log.totalCarbs;
      fat += log.totalFat;
      fiber += log.totalFiber;
    }

    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'fiber': fiber,
    };
  }

  // Get unsynced logs (for Supabase sync)
  Future<List<FoodLog>> getUnsyncedLogs(String userId) async {
    final isar = await db;
    return await isar.foodLogs
        .filter()
        .userIdEqualTo(userId)
        .isSyncedEqualTo(false)
        .findAll();
  }

  // Mark logs as synced
  Future<void> markLogsSynced(List<int> logIds) async {
    final isar = await db;
    await isar.writeTxn(() async {
      for (var id in logIds) {
        final log = await isar.foodLogs.get(id);
        if (log != null) {
          log.isSynced = true;
          await isar.foodLogs.put(log);
        }
      }
    });
  }

  // ==================== USER PROFILE METHODS ====================

  Future<void> saveUserProfile(UserProfile profile) async {
    final isar = await db;
    
    profile.updatedAt = DateTime.now();
    if (profile.createdAt == null) {
      profile.createdAt = DateTime.now();
    }
    
    // Calculate nutrition goals based on profile
    profile.dailyCalorieGoal = _calculateCalorieGoal(profile);
    profile.dailyProteinGoal = _calculateProteinGoal(profile);
    profile.dailyCarbsGoal = _calculateCarbsGoal(profile);
    profile.dailyFatGoal = _calculateFatGoal(profile);
    profile.dailyFiberGoal = 30.0; // Standard recommendation
    
    await isar.writeTxn(() async {
      await isar.userProfiles.put(profile);
    });
  }

  Future<UserProfile?> getUserProfile(String userId) async {
    final isar = await db;
    return await isar.userProfiles
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
  }

  Future<UserProfile?> getCurrentUserProfile() async {
    final isar = await db;
    return await isar.userProfiles.where().findFirst();
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await saveUserProfile(profile);
  }

  Future<void> deleteUserProfile(String userId) async {
    final isar = await db;
    final profile = await getUserProfile(userId);
    if (profile != null) {
      await isar.writeTxn(() async {
        await isar.userProfiles.delete(profile.id);
      });
    }
  }

  Future<bool> hasUserProfile() async {
    final profile = await getCurrentUserProfile();
    return profile != null;
  }

  // Update user streak
  Future<void> _updateStreak(String userId) async {
    final profile = await getUserProfile(userId);
    if (profile == null) return;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (profile.lastLogDate == null) {
      // First log ever
      profile.currentStreak = 1;
      profile.lastLogDate = today;
    } else {
      final lastLog = DateTime(
        profile.lastLogDate!.year,
        profile.lastLogDate!.month,
        profile.lastLogDate!.day,
      );
      
      final daysDifference = today.difference(lastLog).inDays;
      
      if (daysDifference == 0) {
        // Same day - no change
        return;
      } else if (daysDifference == 1) {
        // Consecutive day - increment streak
        profile.currentStreak += 1;
        profile.lastLogDate = today;
      } else {
        // Broke streak - reset
        profile.currentStreak = 1;
        profile.lastLogDate = today;
      }
    }
    
    await saveUserProfile(profile);
  }

  // ==================== DASHBOARD STATS ====================

  Future<Map<String, dynamic>> getDashboardStats(String userId) async {
    final profile = await getUserProfile(userId);
    final todayNutrition = await getTodayNutrition(userId);
    final todayLogs = await getTodayLogs(userId);

    return {
      'todayCalories': todayNutrition['calories'] ?? 0.0,
      'calorieGoal': profile?.dailyCalorieGoal ?? 2100.0,
      'todayProtein': todayNutrition['protein'] ?? 0.0,
      'proteinGoal': profile?.dailyProteinGoal ?? 105.0,
      'todayCarbs': todayNutrition['carbs'] ?? 0.0,
      'carbsGoal': profile?.dailyCarbsGoal ?? 260.0,
      'todayFat': todayNutrition['fat'] ?? 0.0,
      'fatGoal': profile?.dailyFatGoal ?? 70.0,
      'todayFiber': todayNutrition['fiber'] ?? 0.0,
      'fiberGoal': profile?.dailyFiberGoal ?? 30.0,
      'mealsLogged': todayLogs.length,
      'currentStreak': profile?.currentStreak ?? 0,
    };
  }

  // Get meal distribution for today
  Future<Map<String, int>> getTodayMealDistribution(String userId) async {
    final logs = await getTodayLogs(userId);
    final distribution = <String, int>{};

    for (var log in logs) {
      distribution[log.mealType] = (distribution[log.mealType] ?? 0) + 1;
    }

    return distribution;
  }

  // ==================== NUTRITION GOAL CALCULATIONS ====================

  double _calculateCalorieGoal(UserProfile profile) {
    // BMR calculation (Mifflin-St Jeor Equation)
    double bmr;
    if (profile.gender == 'male') {
      bmr = (10 * profile.currentWeight) + (6.25 * profile.height) - (5 * profile.age) + 5;
    } else {
      bmr = (10 * profile.currentWeight) + (6.25 * profile.height) - (5 * profile.age) - 161;
    }
    
    // Activity multiplier
    double activityMultiplier;
    switch (profile.activityLevel) {
      case 'sedentary':
        activityMultiplier = 1.2;
        break;
      case 'light':
        activityMultiplier = 1.375;
        break;
      case 'moderate':
        activityMultiplier = 1.55;
        break;
      case 'active':
        activityMultiplier = 1.725;
        break;
      case 'very_active':
        activityMultiplier = 1.9;
        break;
      default:
        activityMultiplier = 1.2;
    }
    
    double tdee = bmr * activityMultiplier;
    
    // Adjust based on goal
    switch (profile.goal) {
      case 'weight_loss':
        return tdee - 500; // 500 calorie deficit
      case 'weight_gain':
      case 'muscle_gain':
        return tdee + 500; // 500 calorie surplus
      case 'maintain':
      default:
        return tdee;
    }
  }

  double _calculateProteinGoal(UserProfile profile) {
    // Protein: 1.6-2.2g per kg body weight for muscle gain, 1.2-1.6g for maintenance/loss
    if (profile.goal == 'muscle_gain') {
      return profile.currentWeight * 2.0;
    } else {
      return profile.currentWeight * 1.5;
    }
  }

  double _calculateCarbsGoal(UserProfile profile) {
    // Carbs: 45-65% of total calories (using 50%)
    final calorieGoal = _calculateCalorieGoal(profile);
    return (calorieGoal * 0.5) / 4; // 4 calories per gram of carbs
  }

  double _calculateFatGoal(UserProfile profile) {
    // Fat: 20-35% of total calories (using 25%)
    final calorieGoal = _calculateCalorieGoal(profile);
    return (calorieGoal * 0.25) / 9; // 9 calories per gram of fat
  }

  // ==================== DATABASE MAINTENANCE ====================

  Future<void> clearAllLogs(String userId) async {
    final isar = await db;
    final logs = await getAllLogs(userId);
    await isar.writeTxn(() async {
      for (var log in logs) {
        await isar.foodLogs.delete(log.id);
      }
    });
  }

  Future<void> clearOldLogs(String userId, int daysToKeep) async {
    final isar = await db;
    final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));

    final oldLogs = await isar.foodLogs
        .filter()
        .userIdEqualTo(userId)
        .timestampLessThan(cutoffDate)
        .findAll();

    if (oldLogs.isNotEmpty) {
      await isar.writeTxn(() async {
        for (var log in oldLogs) {
          await isar.foodLogs.delete(log.id);
        }
      });
    }
  }

  Future<int> getLogCount(String userId) async {
    final isar = await db;
    return await isar.foodLogs
        .filter()
        .userIdEqualTo(userId)
        .count();
  }

  Future<void> closeDB() async {
    final isar = await db;
    await isar.close();
  }
}
