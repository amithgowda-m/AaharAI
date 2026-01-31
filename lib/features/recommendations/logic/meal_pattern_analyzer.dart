// lib/features/recommendations/logic/meal_pattern_analyzer.dart

import 'package:aahar_ai/data/local/isar_service.dart';
import 'package:aahar_ai/data/local/entities/food_log.dart';

class MealPatternAnalyzer {
  final IsarService _isarService;

  MealPatternAnalyzer(this._isarService);

  /// Get recent meals for analysis
  Future<List<Map<String, dynamic>>> getRecentMeals(int days) async {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    
    // Fetch from Isar database
    final meals = await _isarService.getMealsBetweenDates(startDate, now);
    
    return meals.map((meal) => {
      'id': meal.id,
      'name': meal.foodName,
      'date': meal.timestamp.toString().split(' ')[0],
      'time': meal.timestamp.toString().split(' ')[1].substring(0, 5),
      'type': _getMealType(meal.timestamp),
      'calories': meal.calories,
      'protein': meal.protein,
      'carbs': meal.carbs,
      'fat': meal.fat,
    }).toList();
  }

  /// Determine meal type based on time
  String _getMealType(DateTime time) {
    final hour = time.hour;
    if (hour >= 5 && hour < 11) return 'breakfast';
    if (hour >= 11 && hour < 16) return 'lunch';
    if (hour >= 16 && hour < 20) return 'dinner';
    return 'snack';
  }

  /// Calculate target calories for a specific meal
  int calculateMealCalories(String mealType, int dailyTarget) {
    switch (mealType) {
      case 'breakfast':
        return (dailyTarget * 0.25).round(); // 25%
      case 'lunch':
        return (dailyTarget * 0.35).round(); // 35%
      case 'dinner':
        return (dailyTarget * 0.30).round(); // 30%
      case 'snack':
        return (dailyTarget * 0.10).round(); // 10%
      default:
        return (dailyTarget * 0.25).round();
    }
  }

  /// Calculate daily calorie target based on user profile
  int calculateDailyCalorieTarget(Map<String, dynamic> profile) {
    // BMR calculation (Mifflin-St Jeor Equation)
    double bmr;
    final weight = profile['weight'] ?? 70;
    final height = profile['height'] ?? 170;
    final age = profile['age'] ?? 25;
    final gender = profile['gender'] ?? 'male';

    if (gender.toLowerCase() == 'male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // Activity multiplier
    double activityMultiplier = 1.55; // Moderate activity default
    final activityLevel = profile['activityLevel'] ?? 'moderate';
    
    switch (activityLevel.toLowerCase()) {
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
    }

    double tdee = bmr * activityMultiplier;

    // Adjust for weight goal
    final weightGoal = profile['weightGoal'] ?? 'maintain';
    switch (weightGoal.toLowerCase()) {
      case 'lose':
        tdee -= 500; // 500 calorie deficit
        break;
      case 'gain':
        tdee += 300; // 300 calorie surplus
        break;
    }

    return tdee.round();
  }

  /// Get current meal type based on time of day
  String getCurrentMealType() {
    return _getMealType(DateTime.now());
  }
}
