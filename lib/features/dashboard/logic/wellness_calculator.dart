import 'package:aahar_ai/data/local/entities/food_log.dart';
import 'package:aahar_ai/data/local/entities/user_profile.dart';

class WellnessCalculator {
  
  /// Calculates the EXACT Daily Calorie Goal using Mifflin-St Jeor Equation
  static double calculateDailyCalories(UserProfile profile) {
    // 1. Base BMR (Basal Metabolic Rate)
    double bmr;
    if (profile.gender.toLowerCase() == 'male') {
      bmr = (10 * profile.currentWeight) + (6.25 * profile.height) - (5 * profile.age) + 5;
    } else {
      // Female calculation
      bmr = (10 * profile.currentWeight) + (6.25 * profile.height) - (5 * profile.age) - 161;
    }

    // 2. Activity Multiplier
    double multiplier = 1.2; // Default Sedentary
    switch (profile.activityLevel.toLowerCase()) {
      case 'light': multiplier = 1.375; break;
      case 'moderate': multiplier = 1.55; break;
      case 'active': multiplier = 1.725; break;
      case 'very_active': // Matching your enum style
      case 'very active': multiplier = 1.9; break;
    }

    double maintenanceCalories = bmr * multiplier;

    // 3. Adjust for Goal
    if (profile.goal.contains('loss')) {
      return maintenanceCalories - 500; // Deficit
    } else if (profile.goal.contains('gain') || profile.goal.contains('muscle')) {
      return maintenanceCalories + 300; // Surplus
    }
    
    return maintenanceCalories; // Maintain
  }

  /// Calculates a 0-100 Health Score based on User's specific conditions
  static Map<String, dynamic> calculateMetabolicScore(List<FoodLog> logs, UserProfile profile) {
    if (logs.isEmpty) {
      return {
        'score': 100, 
        'message': 'Ready to fuel your body? Log your first meal!', 
        'color': 0xFF2E7D32 // Green
      };
    }

    double score = 100;
    double totalCarbs = 0;
    double totalFiber = 0;
    double totalProtein = 0;
    double totalSugar = 0; 

    // Aggregate data
    for (var log in logs) {
      totalCarbs += log.totalCarbs;
      totalFiber += log.totalFiber;
      totalProtein += log.totalProtein;
    }

    // --- 1. THE "JUNK FOOD" PENALTY (Generic) ---
    // If high carbs but low fiber, it's likely processed food
    if (totalCarbs > 40 && totalFiber < 3) {
      score -= 10;
    }

    // --- 2. DIABETIC / INSULIN CHECK ---
    // Checks if 'diabetic' exists in healthConditions OR dietaryPreferences
    bool isDiabetic = profile.healthConditions.any((c) => c.toLowerCase().contains('diabetic')) || 
                      profile.dietaryPreferences.any((p) => p.toLowerCase().contains('diabetic'));
    
    if (isDiabetic) {
      // Strict rule: Fiber needs to be high to buffer sugar
      if (totalCarbs > 100 && totalFiber < 10) {
        score -= 15; // Heavy penalty for sugar spikes
      }
    }

    // --- 3. FEMALE HEALTH CHECK (Hormonal Health) ---
    if (profile.gender.toLowerCase() == 'female') {
      // Protein is crucial for hormonal balance and energy
      if (totalProtein < 20 && totalCarbs > 80) {
        score -= 5;
      }
    }

    // --- 4. MUSCLE GAIN CHECK ---
    if (profile.goal.contains('muscle') && totalProtein < 30) {
      score -= 5; // Penalty for missing protein target
    }

    // Clamp score
    score = score.clamp(0, 100);

    // --- GENERATE PERSONALIZED INSIGHT ---
    String message = "You're doing great!";
    int color = 0xFF2E7D32; // Green

    if (score >= 80) {
      message = "Metabolic state is optimized. Keep it up! 🔥";
      color = 0xFF2E7D32;
    } else if (score >= 60) {
      color = 0xFFFFA000; // Orange
      if (isDiabetic) {
        message = "⚠️ Watch your carb intake to prevent blood sugar spikes.";
      } else if (profile.gender.toLowerCase() == 'female') {
        message = "💡 Energy dip detected. Try adding more iron/protein.";
      } else if (totalFiber < 10) {
        message = "📉 Fiber is low. Eat a fruit or veggie for better digestion.";
      } else {
        message = "Good, but try to eat cleaner whole foods next meal.";
      }
    } else {
      color = 0xFFD32F2F; // Red
      message = "🚨 Nutrition off-balance. Focus on protein and veggies for dinner.";
    }

    return {
      'score': score.round(),
      'message': message,
      'color': color,
    };
  }
}