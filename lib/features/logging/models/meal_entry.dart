// lib/features/logging/models/meal_entry.dart
import 'package:isar/isar.dart';

part 'meal_entry.g.dart';

@collection
class MealEntry {
  Id id = Isar.autoIncrement;
  
  late String foodName;
  late String mealType; // Breakfast, Lunch, Dinner, Snack
  late DateTime timestamp;
  
  late double calories;
  late double protein;
  late double carbs;
  late double fat;
  late double fiber;
  
  late String? imagePath; // Store captured image locally
  late double portionSize; // User-adjustable multiplier
  
  late int healthScore; // 1-10 rating
  late String? aiInsight; // Nutria's comment
}
