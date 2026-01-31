import 'package:isar/isar.dart';

part 'food_log.g.dart';

@collection
class FoodLog {
  Id id = Isar.autoIncrement;

  @Index()
  late String userId;
  late String foodName;

  // --- BASE VALUES (Per Serving) ---
  // These were missing and causing your errors
  double calories = 0.0; 
  double protein = 0.0;
  double carbs = 0.0;
  double fat = 0.0;
  double fiber = 0.0;

  // --- QUANTITY ---
  double portionSize = 1.0;
  double itemCount = 1.0;

  // --- MODIFIERS (e.g. "Extra Cheese") ---
  double modifierCalories = 0.0;
  double modifierProtein = 0.0;
  double modifierCarbs = 0.0;
  double modifierFat = 0.0;

  // --- CALCULATED TOTALS (Base * Qty + Modifiers) ---
  // These are used for your Dashboard & History
  double totalCalories = 0.0;
  double totalProtein = 0.0;
  double totalCarbs = 0.0;
  double totalFat = 0.0;
  double totalFiber = 0.0;

  // --- MICRONUTRIENTS (Professional Data) ---
  double sugar = 0.0;       // Crucial for Diabetics
  double sodium = 0.0;      // Crucial for Hypertension
  double cholesterol = 0.0; // Crucial for Heart Health
  double iron = 0.0;        // Crucial for Anemia (Females)
  double potassium = 0.0;   // General Health

  // --- METADATA ---
  late DateTime timestamp;
  late String mealType;
  
  List<String> modifiers = [];
  String? notes;
  
  String? imagePath;    // Was missing, causing Scanner error
  bool isSynced = false; // Was missing, causing IsarService error
}