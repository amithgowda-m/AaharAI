// lib/data/local/entities/food_log.dart - REPLACE ENTIRE FILE

import 'package:isar/isar.dart';

part 'food_log.g.dart';

@collection
class FoodLog {
  Id id = Isar.autoIncrement;

  late String userId; // Link to user
  
  // Food Details
  late String foodName;
  late String mealType; // 'Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner', 'Late Night Snack'
  
  // Nutrition (base values)
  late double calories;
  late double protein;
  late double carbs;
  late double fat;
  double fiber = 0.0;
  
  // Portion & Quantity
  double portionSize = 1.0; // 0.5x, 1x, 1.5x, 2x, etc.
  int itemCount = 1; // Number of items
  
  // Modifiers (toppings, additions)
  List<String> modifiers = []; // e.g., ['1 tsp ghee', 'extra cheese', 'no oil']
  
  // Modifier Nutrition (added separately)
  double modifierCalories = 0.0;
  double modifierProtein = 0.0;
  double modifierCarbs = 0.0;
  double modifierFat = 0.0;
  
  // Total Nutrition (base + modifiers + portion * count)
  late double totalCalories;
  late double totalProtein;
  late double totalCarbs;
  late double totalFat;
  late double totalFiber;
  
  // Image & Metadata
  String? imagePath; // Local path to food image
  DateTime timestamp = DateTime.now();
  
  // AI Insights
  String? nutriaComment; // AI feedback on this meal
  int healthScore = 0; // 1-10 rating from AI
  
  // Synced to cloud
  bool isSynced = false;
  String? supabaseId; // ID in Supabase table
}
