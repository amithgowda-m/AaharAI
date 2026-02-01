import 'package:aahar_ai/data/local/entities/user_profile.dart';

class WellnessCalculator {
  
  /// Calculates scientifically accurate nutrition targets.
  /// Returns a Map with keys: 'calories', 'protein', 'fat', 'carbs', 'fiber'
  static Map<String, double> calculateScientificTargets(UserProfile profile) {
    // 1. Calculate BMR (Mifflin-St Jeor Equation) - The clinical standard
    double bmr;
    // Safety check for height/weight/age to prevent crashes
    double weight = profile.currentWeight > 0 ? profile.currentWeight : 70.0;
    double height = profile.height > 0 ? profile.height : 170.0;
    int age = profile.age > 0 ? profile.age : 25;

    if (profile.gender.toLowerCase() == 'male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    }

    // 2. Define Factors based on Activity Level
    double tdeeMultiplier = 1.2; // For Calories
    double proteinMultiplier = 1.0; // Grams per KG of bodyweight

    switch (profile.activityLevel.toLowerCase()) {
      case 'sedentary':
        tdeeMultiplier = 1.2;
        proteinMultiplier = 1.0; // Basic health
        break;
      case 'light':
        tdeeMultiplier = 1.375;
        proteinMultiplier = 1.2; // Light movement
        break;
      case 'moderate':
        tdeeMultiplier = 1.55;
        proteinMultiplier = 1.6; // Regular training
        break;
      case 'active':
        tdeeMultiplier = 1.725;
        proteinMultiplier = 1.8; // Athlete
        break;
      case 'very_active':
      case 'very active':
        tdeeMultiplier = 1.9;
        proteinMultiplier = 2.0; // Endurance athlete
        break;
      default:
        // Default to sedentary if unknown string
        tdeeMultiplier = 1.2;
        proteinMultiplier = 1.0;
    }

    // -- Goal Adjustments --
    // If goal is muscle gain or weight loss, protein needs are higher to preserve/build muscle.
    if (profile.goal.toLowerCase().contains('loss') || profile.goal.toLowerCase().contains('muscle')) {
      if (proteinMultiplier < 1.6) proteinMultiplier = 1.6; 
    }

    // 3. Calculate Calories (TDEE + Goal)
    double tdee = bmr * tdeeMultiplier;
    double targetCalories = tdee;

    if (profile.goal.toLowerCase().contains('loss')) {
      targetCalories = tdee - 500; // Safe deficit
    } else if (profile.goal.toLowerCase().contains('gain') || profile.goal.toLowerCase().contains('muscle')) {
      targetCalories = tdee + 300; // Lean surplus
    }

    // --- 4. MACRO CALCULATIONS (Scientific Priority) ---

    // A. PROTEIN: Based on Body Weight (Not Calories)
    // Science: Needs are driven by lean mass & activity.
    double targetProtein = weight * proteinMultiplier;

    // B. FAT: Hormonal Minimum
    // Science: 0.8g/kg is standard to maintain hormone function.
    double targetFat = weight * 0.8;

    // C. CARBS: The Energy Lever (Remainder)
    // Science: Carbs fill the remaining energy budget after essential protein/fats.
    double caloriesFromProtein = targetProtein * 4;
    double caloriesFromFat = targetFat * 9;
    double remainingCalories = targetCalories - (caloriesFromProtein + caloriesFromFat);
    
    // Ensure carbs don't go negative
    if (remainingCalories < 0) remainingCalories = 0;
    double targetCarbs = remainingCalories / 4;

    // D. FIBER: Calorie Based
    // Science: 14g per 1000kcal is the dietary guideline.
    double targetFiber = (targetCalories / 1000) * 14;
    if (targetFiber < 25) targetFiber = 25; // Minimum floor

    return {
      'calories': targetCalories,
      'protein': targetProtein,
      'fat': targetFat,
      'carbs': targetCarbs,
      'fiber': targetFiber,
    };
  }
}