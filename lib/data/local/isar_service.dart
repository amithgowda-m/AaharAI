// lib/data/local/isar_service.dart

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:aahar_ai/data/local/entities/food_log.dart';
import 'package:aahar_ai/data/local/entities/user_profile.dart';
import 'package:aahar_ai/data/local/entities/meal_recommendation.dart';
import 'package:aahar_ai/data/local/entities/diet_plan.dart';
import 'package:aahar_ai/data/local/entities/user_subscription.dart';

final isarProvider = Provider<IsarService>((ref) {
  return IsarService();
});

class IsarService {
  late Future<Isar> db;

  static const int freeDailyScanLimit = 5;
  static const int freeDailyChatLimit = 10;
  static const int unlimitedLimit = 999999;
  static const double standardFiberGoal = 30.0;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [
          FoodLogSchema,
          UserProfileSchema,
          MealRecommendationSchema,
          DietPlanSchema,
          UserSubscriptionSchema,
        ],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  // ==================== FOOD LOG METHODS ====================
  
  Future<void> addFoodLog(FoodLog newLog) async {
    final isar = await db;
    
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

  Future<List<FoodLog>> getUnsyncedLogs(String userId) async {
    final isar = await db;
    return await isar.foodLogs
        .filter()
        .userIdEqualTo(userId)
        .isSyncedEqualTo(false)
        .findAll();
  }

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

  // ==================== MEAL PATTERN ANALYSIS ====================

  Future<List<FoodLog>> getMealsBetweenDates(DateTime startDate, DateTime endDate) async {
    final isar = await db;
    return await isar.foodLogs
        .filter()
        .timestampBetween(startDate, endDate)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<List<FoodLog>> getRecentMeals(int days) async {
    final isar = await db;
    final startDate = DateTime.now().subtract(Duration(days: days));
    return await isar.foodLogs
        .filter()
        .timestampGreaterThan(startDate)
        .sortByTimestampDesc()
        .findAll();
  }

  // ==================== RECOMMENDATIONS ====================
  
  Future<void> saveRecommendation(MealRecommendation recommendation) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.mealRecommendations.put(recommendation);
    });
  }

  Future<void> saveRecommendations(List<MealRecommendation> recommendations) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.mealRecommendations.putAll(recommendations);
    });
  }

  Future<List<MealRecommendation>> getValidRecommendations(String mealType) async {
    final isar = await db;
    final now = DateTime.now();
    return await isar.mealRecommendations
        .filter()
        .mealTypeEqualTo(mealType)
        .validUntilGreaterThan(now)
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<List<MealRecommendation>> getAllRecommendations() async {
    final isar = await db;
    return await isar.mealRecommendations
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<void> markRecommendationAsUsed(int recommendationId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final rec = await isar.mealRecommendations.get(recommendationId);
      if (rec != null) {
        rec.isUsed = true;
        await isar.mealRecommendations.put(rec);
      }
    });
  }

  Future<void> clearExpiredRecommendations() async {
    final isar = await db;
    final now = DateTime.now();
    await isar.writeTxn(() async {
      final expired = await isar.mealRecommendations
          .filter()
          .validUntilLessThan(now)
          .findAll();
      await isar.mealRecommendations.deleteAll(expired.map((e) => e.id).toList());
    });
  }

  Future<void> clearAllRecommendations() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.mealRecommendations.clear();
    });
  }

  // ==================== DIET PLANS ====================
  
  Future<void> saveDietPlan(DietPlan plan) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final existingPlans = await isar.dietPlans.where().findAll();
      for (var p in existingPlans) {
        p.isActive = false;
        await isar.dietPlans.put(p);
      }
      await isar.dietPlans.put(plan);
    });
  }

  Future<DietPlan?> getActiveDietPlan() async {
    final isar = await db;
    return await isar.dietPlans
        .filter()
        .isActiveEqualTo(true)
        .findFirst();
  }

  Future<List<DietPlan>> getAllDietPlans() async {
    final isar = await db;
    return await isar.dietPlans
        .where()
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<void> deactivateDietPlan(int planId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final plan = await isar.dietPlans.get(planId);
      if (plan != null) {
        plan.isActive = false;
        await isar.dietPlans.put(plan);
      }
    });
  }

  Future<void> deleteDietPlan(int planId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.dietPlans.delete(planId);
    });
  }

  // ==================== SUBSCRIPTION ====================
  
  Future<void> saveSubscription(UserSubscription subscription) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.userSubscriptions.put(subscription);
    });
  }

  Future<UserSubscription?> getSubscription() async {
    final isar = await db;
    return await isar.userSubscriptions.where().findFirst();
  }

  Future<void> incrementDailyScanCount() async {
    final isar = await db;
    final sub = await getSubscription();
    
    if (sub != null) {
      await isar.writeTxn(() async {
        _resetCountsIfNeeded(sub);
        sub.dailyScanCount++;
        sub.updatedAt = DateTime.now();
        await isar.userSubscriptions.put(sub);
      });
    }
  }

  Future<void> incrementDailyChatCount() async {
    final isar = await db;
    final sub = await getSubscription();
    
    if (sub != null) {
      await isar.writeTxn(() async {
        _resetCountsIfNeeded(sub);
        sub.dailyChatCount++;
        sub.updatedAt = DateTime.now();
        await isar.userSubscriptions.put(sub);
      });
    }
  }

  void _resetCountsIfNeeded(UserSubscription sub) {
    final now = DateTime.now();
    if (sub.lastResetDate.day != now.day || 
        sub.lastResetDate.month != now.month || 
        sub.lastResetDate.year != now.year) {
      sub.dailyScanCount = 0;
      sub.dailyChatCount = 0;
      sub.lastResetDate = now;
    }
  }

  Future<bool> canScanToday() async {
    final sub = await getSubscription();
    if (sub == null) return false;
    
    final now = DateTime.now();
    if (sub.lastResetDate.day != now.day || 
        sub.lastResetDate.month != now.month || 
        sub.lastResetDate.year != now.year) {
       
       // FIXED: Added 'final isar' definition here
       final isar = await db; 
       await isar.writeTxn(() async {
          _resetCountsIfNeeded(sub);
          await isar.userSubscriptions.put(sub);
       });
    }
    
    if (sub.subscriptionType == 'premium' || sub.subscriptionType == 'premium_plus') {
      return true;
    }
    
    return sub.dailyScanCount < freeDailyScanLimit;
  }

  Future<bool> canChatToday() async {
    final sub = await getSubscription();
    if (sub == null) return false;
    
    final now = DateTime.now();
    if (sub.lastResetDate.day != now.day || 
        sub.lastResetDate.month != now.month || 
        sub.lastResetDate.year != now.year) {
       
       // FIXED: Added 'final isar' definition here
       final isar = await db;
       await isar.writeTxn(() async {
          _resetCountsIfNeeded(sub);
          await isar.userSubscriptions.put(sub);
       });
    }
    
    if (sub.subscriptionType == 'premium' || sub.subscriptionType == 'premium_plus') {
      return true;
    }
    
    return sub.dailyChatCount < freeDailyChatLimit;
  }

  Future<int> getRemainingScanCount() async {
    final sub = await getSubscription();
    if (sub == null) return 0;
    
    if (sub.subscriptionType == 'premium' || sub.subscriptionType == 'premium_plus') {
      return unlimitedLimit; 
    }
    
    return (freeDailyScanLimit - sub.dailyScanCount).clamp(0, freeDailyScanLimit);
  }

  Future<int> getRemainingChatCount() async {
    final sub = await getSubscription();
    if (sub == null) return 0;
    
    if (sub.subscriptionType == 'premium' || sub.subscriptionType == 'premium_plus') {
      return unlimitedLimit;
    }
    
    return (freeDailyChatLimit - sub.dailyChatCount).clamp(0, freeDailyChatLimit);
  }

  // ==================== USER PROFILE METHODS ====================

  Future<void> saveUserProfile(UserProfile profile) async {
    final isar = await db;
    
    profile.updatedAt = DateTime.now();
    if (profile.createdAt == null) {
      profile.createdAt = DateTime.now();
    }
    
    profile.dailyCalorieGoal = _calculateCalorieGoal(profile);
    profile.dailyProteinGoal = _calculateProteinGoal(profile);
    profile.dailyCarbsGoal = _calculateCarbsGoal(profile);
    profile.dailyFatGoal = _calculateFatGoal(profile);
    profile.dailyFiberGoal = standardFiberGoal;
    
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

  Future<void> _updateStreak(String userId) async {
    final profile = await getUserProfile(userId);
    if (profile == null) return;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (profile.lastLogDate == null) {
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
        return;
      } else if (daysDifference == 1) {
        profile.currentStreak += 1;
        profile.lastLogDate = today;
      } else {
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
      'fiberGoal': profile?.dailyFiberGoal ?? standardFiberGoal,
      'mealsLogged': todayLogs.length,
      'currentStreak': profile?.currentStreak ?? 0,
    };
  }

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
    double bmr;
    if (profile.gender == 'male') {
      bmr = (10 * profile.currentWeight) + (6.25 * profile.height) - (5 * profile.age) + 5;
    } else {
      bmr = (10 * profile.currentWeight) + (6.25 * profile.height) - (5 * profile.age) - 161;
    }
    
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
    
    switch (profile.goal) {
      case 'weight_loss':
        return tdee - 500; 
      case 'weight_gain':
      case 'muscle_gain':
        return tdee + 500; 
      case 'maintain':
      default:
        return tdee;
    }
  }

  double _calculateProteinGoal(UserProfile profile) {
    if (profile.goal == 'muscle_gain') {
      return profile.currentWeight * 2.0;
    } else {
      return profile.currentWeight * 1.5;
    }
  }

  double _calculateCarbsGoal(UserProfile profile) {
    final calorieGoal = _calculateCalorieGoal(profile);
    return (calorieGoal * 0.5) / 4; 
  }

  double _calculateFatGoal(UserProfile profile) {
    final calorieGoal = _calculateCalorieGoal(profile);
    return (calorieGoal * 0.25) / 9; 
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

  // ==================== COMPREHENSIVE STATS ====================

  Future<Map<String, dynamic>> getWeeklyStats(String userId) async {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final logs = await getLogsByDateRange(
      userId,
      DateTime(weekStart.year, weekStart.month, weekStart.day),
      DateTime(now.year, now.month, now.day, 23, 59, 59),
    );

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var log in logs) {
      totalCalories += log.totalCalories;
      totalProtein += log.totalProtein;
      totalCarbs += log.totalCarbs;
      totalFat += log.totalFat;
    }

    final daysLogged = logs.map((log) => 
      DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day)
    ).toSet().length;

    return {
      'totalMeals': logs.length,
      'daysLogged': daysLogged,
      'avgDailyCalories': daysLogged > 0 ? totalCalories / daysLogged : 0,
      'avgDailyProtein': daysLogged > 0 ? totalProtein / daysLogged : 0,
      'avgDailyCarbs': daysLogged > 0 ? totalCarbs / daysLogged : 0,
      'avgDailyFat': daysLogged > 0 ? totalFat / daysLogged : 0,
    };
  }

  Future<Map<String, dynamic>> getMonthlyStats(String userId) async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final logs = await getLogsByDateRange(
      userId,
      monthStart,
      DateTime(now.year, now.month, now.day, 23, 59, 59),
    );

    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    for (var log in logs) {
      totalCalories += log.totalCalories;
      totalProtein += log.totalProtein;
      totalCarbs += log.totalCarbs;
      totalFat += log.totalFat;
    }

    final daysLogged = logs.map((log) => 
      DateTime(log.timestamp.year, log.timestamp.month, log.timestamp.day)
    ).toSet().length;

    return {
      'totalMeals': logs.length,
      'daysLogged': daysLogged,
      'avgDailyCalories': daysLogged > 0 ? totalCalories / daysLogged : 0,
      'avgDailyProtein': daysLogged > 0 ? totalProtein / daysLogged : 0,
      'avgDailyCarbs': daysLogged > 0 ? totalCarbs / daysLogged : 0,
      'avgDailyFat': daysLogged > 0 ? totalFat / daysLogged : 0,
    };
  }

  Future<void> closeDB() async {
    final isar = await db;
    await isar.close();
  }
}