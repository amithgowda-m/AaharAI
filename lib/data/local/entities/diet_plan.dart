import 'package:isar/isar.dart';

part 'diet_plan.g.dart';

@collection
class DietPlan {
  Id id = Isar.autoIncrement;

  late String name;
  late String description;
  late String goal; // weight_loss, muscle_gain, maintain
  
  double dailyCalories = 0;
  double proteinRatio = 0;
  double carbsRatio = 0;
  double fatRatio = 0;
  
  bool isActive = false;
  
  late DateTime createdAt;
  DateTime? startDate;
  DateTime? endDate;
}