import 'package:isar/isar.dart';

part 'meal_recommendation.g.dart';

@collection
class MealRecommendation {
  Id id = Isar.autoIncrement;

  late String name;
  late String mealType; // breakfast, lunch, dinner, snack
  
  double calories = 0;
  double protein = 0;
  double carbs = 0;
  double fat = 0;
  double fiber = 0;

  List<String> ingredients = [];
  String? reason;
  
  bool isUsed = false; // If user accepted/logged this meal
  
  late DateTime createdAt;
  late DateTime validUntil; // Expiry for recommendation
  late DateTime timestamp;
}