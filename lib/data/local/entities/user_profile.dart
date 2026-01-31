// lib/data/local/entities/user_profile.dart - REPLACE ENTIRE FILE

import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String userId; // Supabase user ID
  
  // Basic Info
  late String email;
  late String name;
  late int age;
  late String gender; // 'male' or 'female'
  
  // Physical Stats
  late double currentWeight; // in kg
  late double targetWeight; // in kg
  late double height; // in cm
  
  // Goals
  late String goal; // 'weight_loss', 'weight_gain', 'maintain', 'muscle_gain'
  late String activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'
  
  // Health Conditions
  List<String> healthConditions = []; // ['none', 'diabetic', 'hypertension', etc.]
  String? healthConditionDetails;
  
  // Exercise
  late String exerciseGoal; // 'none', 'light', 'moderate', 'intense'
  int exerciseMinutesPerWeek = 0;
  
  // Nutrition Goals (calculated)
  late double dailyCalorieGoal;
  late double dailyProteinGoal;
  late double dailyCarbsGoal;
  late double dailyFatGoal;
  late double dailyFiberGoal;
  
  // Budget & Preferences
  double? weeklyBudget;
  List<String> dietaryRestrictions = [];
  List<String> foodAllergies = [];
  // NEW: Added this field to match your RecommendationProvider logic
  List<String> dietaryPreferences = []; 
  
  // Timestamps
  DateTime? createdAt;
  DateTime? updatedAt;
  
  // Streak tracking
  int currentStreak = 0;
  DateTime? lastLogDate;
  
  // Legacy field (keep for compatibility)
  int? dailyCalorieTarget;
}