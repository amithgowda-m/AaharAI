import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String userId; // Supabase user ID
  
  // --- BASIC INFO ---
  late String email;
  late String name;
  late int age;
  late String gender; // 'male' or 'female'
  
  // --- PHYSICAL STATS (Used by Mifflin-St Jeor Equation) ---
  late double currentWeight; // in kg
  late double targetWeight; // in kg
  late double height; // in cm
  
  // --- GOALS & LIFESTYLE ---
  late String goal; // 'weight_loss', 'weight_gain', 'maintain', 'muscle_gain'
  late String activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'
  
  // --- HEALTH & MEDICAL ---
  List<String> healthConditions = []; // ['Diabetes', 'Hypertension', 'PCOS', etc.]
  String? healthConditionDetails;
  
  // --- EXERCISE ---
  late String exerciseGoal; // 'none', 'light', 'moderate', 'intense'
  int exerciseMinutesPerWeek = 0;
  
  // --- NUTRITION TARGETS (Calculated or Manual) ---
  late double dailyCalorieGoal;
  late double dailyProteinGoal;
  late double dailyCarbsGoal;
  late double dailyFatGoal;
  late double dailyFiberGoal;
  
  // --- PREFERENCES ---
  double? weeklyBudget;
  List<String> dietaryRestrictions = [];
  List<String> foodAllergies = [];
  List<String> dietaryPreferences = []; 
  
  // --- METADATA ---
  DateTime? createdAt;
  DateTime? updatedAt;
  
  // --- STREAK TRACKING ---
  int currentStreak = 0;
  DateTime? lastLogDate;
  
  // --- LEGACY ---
  int? dailyCalorieTarget;

  // =========================================================
  // HELPER GETTERS (Required for PDF & Insights)
  // =========================================================

  /// Calculates BMI dynamically based on current weight and height
  double get bmi {
    if (height <= 0) return 0;
    // Formula: Weight (kg) / Height (m)²
    double heightInMeters = height / 100;
    return currentWeight / (heightInMeters * heightInMeters);
  }

  /// Returns the medical category for the current BMI
  String get bmiCategory {
    double val = bmi;
    if (val <= 0) return "Unknown";
    if (val < 18.5) return "Underweight";
    if (val < 24.9) return "Normal Weight";
    if (val < 29.9) return "Overweight";
    return "Obese";
  }
}